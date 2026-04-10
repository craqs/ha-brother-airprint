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

# Force-update persisted cupsd.conf to current version's settings.
# This ensures BrowseLocalProtocols and Browsing are correct after upgrades.
if [ -f /etc/cups/cupsd.conf ]; then
    sed -i '/^DNSSDHostName/d' /etc/cups/cupsd.conf
    sed -i '/^BrowseLocalProtocols/d' /etc/cups/cupsd.conf
    sed -i 's/^Browsing.*/Browsing Yes/' /etc/cups/cupsd.conf
    grep -q "^BrowseLocalProtocols" /etc/cups/cupsd.conf || \
        sed -i '/^Browsing Yes/a BrowseLocalProtocols all' /etc/cups/cupsd.conf
fi

# Update admin password from addon options if bashio is available
if command -v bashio &>/dev/null; then
    ADMIN_PASS=$(bashio::config 'cups_admin_password' 2>/dev/null) || true
    if [ -n "$ADMIN_PASS" ]; then
        echo "print:${ADMIN_PASS}" | chpasswd 2>/dev/null || true
    fi
fi
