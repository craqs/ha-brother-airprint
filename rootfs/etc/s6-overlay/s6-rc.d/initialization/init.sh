#!/bin/bash

# Persist CUPS configuration across restarts
# /data is provided by Home Assistant; skip if not available
if [ -d /data ]; then
    if [ ! -d /data/cups ]; then
        cp -a /etc/cups /data/cups
    fi
    rm -rf /etc/cups
    ln -sf /data/cups /etc/cups
fi

# Ensure runtime directories exist
mkdir -p /var/run/dbus
mkdir -p /var/run/avahi-daemon
mkdir -p /run/cups

# Restrict Avahi to the physical network interface only.
# Without this, Avahi advertises the printer on Docker/veth interfaces,
# causing iPhones to resolve the printer hostname to an unreachable IP.
IFACE=$(ip route show default 0.0.0.0/0 | awk '{print $5; exit}')
if [ -n "$IFACE" ]; then
    sed -i "/^\[server\]/a allow-interfaces=${IFACE}" /etc/avahi/avahi-daemon.conf
fi

# Remove DNSSDHostName from persisted config (if leftover from older version).
sed -i '/^DNSSDHostName/d' /etc/cups/cupsd.conf 2>/dev/null || true

# Set Avahi hostname to the HA host's mDNS hostname (UUID-based).
# The container's default hostname doesn't resolve cross-VLAN via UniFi mDNS reflection,
# but the host's UUID hostname does. This makes DNS-SD SRV records point to a hostname
# that resolves on all VLANs. publish-addresses=no avoids conflict with host's mDNS.
sed -i '/^host-name=/d' /etc/avahi/avahi-daemon.conf 2>/dev/null || true
if command -v bashio &>/dev/null; then
    HOST_UUID=$(curl -s -H "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/core/info 2>/dev/null \
        | sed -n 's/.*"uuid"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
    if [ -n "$HOST_UUID" ]; then
        sed -i "/^\[server\]/a host-name=${HOST_UUID}" /etc/avahi/avahi-daemon.conf
        # Don't publish A records — the host's mDNS already handles that hostname
        if ! grep -q "^publish-addresses=" /etc/avahi/avahi-daemon.conf; then
            sed -i "/^\[publish\]/a publish-addresses=no" /etc/avahi/avahi-daemon.conf
        fi
    fi
fi

# Update admin password from addon options if bashio is available
if command -v bashio &>/dev/null; then
    ADMIN_PASS=$(bashio::config 'cups_admin_password' 2>/dev/null) || true
    if [ -n "$ADMIN_PASS" ]; then
        echo "print:${ADMIN_PASS}" | chpasswd 2>/dev/null || true
    fi
fi
