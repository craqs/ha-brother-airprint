#!/bin/bash

# Persist CUPS configuration across restarts.
# /data is provided by Home Assistant; skip if not available.
# Strategy: persist printer data (printers.conf, ppd/, ssl/) in /data/cups,
# but always use cupsd.conf from the image so upgrades take effect.
if [ -d /data ]; then
    if [ ! -d /data/cups ]; then
        cp -a /etc/cups /data/cups
    else
        # On upgrade: overwrite cupsd.conf with the image's version.
        # Printer definitions (printers.conf, ppd/, ssl/) are preserved.
        cp /etc/cups/cupsd.conf /data/cups/cupsd.conf
    fi
    rm -rf /etc/cups
    ln -sf /data/cups /etc/cups
fi

# Ensure runtime directories exist
mkdir -p /var/run/dbus
mkdir -p /var/run/avahi-daemon
mkdir -p /run/cups

# Update admin password from addon options if bashio is available
if command -v bashio &>/dev/null; then
    ADMIN_PASS=$(bashio::config 'cups_admin_password' 2>/dev/null) || true
    if [ -n "$ADMIN_PASS" ]; then
        echo "print:${ADMIN_PASS}" | chpasswd 2>/dev/null || true
    fi
fi
