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

# Update admin password from addon options if bashio is available
if command -v bashio &>/dev/null; then
    ADMIN_PASS=$(bashio::config 'cups_admin_password' 2>/dev/null) || true
    if [ -n "$ADMIN_PASS" ]; then
        echo "print:${ADMIN_PASS}" | chpasswd 2>/dev/null || true
    fi
fi
