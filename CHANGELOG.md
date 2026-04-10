# Changelog

## 0.2.4

- Fix AirPrint on iPhone: restrict Avahi to physical network interface only
  - Avahi was advertising the printer on Docker/veth interfaces, causing iPhones to resolve an unreachable IP
  - Auto-detects the default route interface at startup

## 0.2.3

- Fix CUPS rejecting Ingress requests (400 Bad Request) due to external Host header

## 0.2.2

- Fix Ingress iframe embedding blocked by CUPS security headers
- Widen Ingress proxy IP allowlist to cover full HA network subnet

## 0.2.0

- Add Home Assistant Ingress support for CUPS web interface
- CUPS web UI accessible from the HA sidebar ("Brother Printer")
- nginx reverse proxy with URL rewriting for Ingress compatibility

## 0.1.1

- Fix addon startup: permissive AppArmor profile
- Add explicit ENTRYPOINT for s6-overlay
- Restore init: false for s6-overlay PID 1 requirement

## 0.1.0

- Initial release
- CUPS print server with AirPrint support
- Original Brother HL-1110 i386 driver via QEMU emulation
- s6-overlay service management (dbus, avahi, cups)
- Persistent CUPS configuration across restarts
- Configurable printer name and admin password
