# Brother AirPrint - Home Assistant Addon

CUPS print server with the original Brother HL-1110 driver and AirPrint support for Home Assistant.

## About

This addon runs a CUPS print server inside Home Assistant with the official Brother HL-1110 i386 driver. Since the driver is x86-only and Home Assistant typically runs on ARM (aarch64), QEMU user-mode emulation is used to run the driver binaries transparently.

## Features

- Original Brother HL-1110 driver (not the open-source brlaser alternative)
- AirPrint support via Avahi/mDNS — print from any Apple device
- CUPS web interface accessible from the HA sidebar via Ingress
- Direct CUPS access on port 631 for advanced management
- Persistent configuration across addon restarts
- s6-overlay service management (dbus, avahi, cups, nginx)

## Installation

1. Add this repository URL to your Home Assistant addon store:
   ```
   https://github.com/craqs/ha-brother-airprint
   ```
2. Install the **Brother AirPrint** addon
3. Start the addon
4. The CUPS web interface is available from the HA sidebar ("Brother Printer")

## Web Interface

The addon provides two ways to access the CUPS web interface:

- **HA Sidebar (Ingress)** — click "Brother Printer" in the sidebar. No extra ports or authentication needed, it's handled by Home Assistant.
- **Direct access** — `http://<your-ha-ip>:631` for full CUPS admin access outside of HA (login: `print` / your configured password).

## Printer Setup

1. Connect your Brother HL-1110 printer via USB to your Home Assistant host
2. Open the CUPS web UI (sidebar or direct)
3. Go to **Administration** > **Add Printer**
4. Log in with username `print` and your configured password (default: `print`)
5. Select your USB printer from the list
6. Choose the Brother HL-1110 driver (should be auto-detected)
7. Enable **Share This Printer** for AirPrint

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| `printer_name` | `Brother_HL-1110` | Display name for the printer |
| `cups_admin_password` | `print` | Password for CUPS admin (username: `print`) |

## How It Works

The Brother HL-1110 driver is only available as i386 (32-bit x86) binaries. To run these on aarch64 (RPi 4), the addon uses QEMU user-mode emulation. Each i386 binary (`rawtobr3`, `brprintconflsr3`, `brcupsconfig4`) is wrapped with a shell script that invokes `qemu-i386-static`, making the emulation transparent to CUPS.

## Requirements

- Home Assistant OS on Raspberry Pi 4 (aarch64)
- Brother HL-1110 printer connected via USB

## Troubleshooting

- **Printer not detected**: Check that the USB cable is connected and the printer is powered on. Check addon logs for USB device detection.
- **AirPrint not visible**: Ensure the addon is running with host network mode. Avahi needs direct network access for mDNS.
- **Print quality issues**: Access CUPS web UI and adjust printer options (resolution, paper type).
- **Ingress shows blank page**: Check addon logs for nginx errors. The CUPS UI should load in the HA sidebar after a few seconds.
