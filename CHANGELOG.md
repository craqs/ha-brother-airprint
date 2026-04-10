# Changelog

## 0.2.7

- Fix AirPrint cross-VLAN on iPhone: advertise printer under `homeassistant.local`
  - Added `DNSSDHostName homeassistant` to cupsd.conf so CUPS registers the printer with a hostname that resolves on all devices
  - Container's Avahi keeps its own hostname, but the DNS-SD SRV record points to `homeassistant.local`
  - Reverted failed `host_dbus` approach (HAOS doesn't expose Avahi to addons via D-Bus)

## 0.2.5

- Fix AirPrint cross-VLAN on iPhone: disable IPv6 in Avahi mDNS
  - iOS prefers IPv6 but ULA addresses (fd::/8) are often not routable between VLANs
  - Avahi now only advertises IPv4, ensuring iPhones connect to the correct routable IP
- Fix Avahi crash on startup: wait for D-Bus socket before starting

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
