# Brother AirPrint - Home Assistant Addon

CUPS print server with the original Brother HL-1110 driver and AirPrint support for Home Assistant.

## About

This addon runs a CUPS print server inside Home Assistant with the official Brother HL-1110 i386 driver. Since the driver is x86-only and Home Assistant typically runs on ARM (aarch64), QEMU user-mode emulation is used to run the driver binaries transparently.

## Features

- Original Brother HL-1110 driver (not the open-source brlaser alternative)
- AirPrint support via Avahi/mDNS - print from any Apple device
- CUPS web interface for printer management
- Persistent configuration across addon restarts

## Installation

1. Add this repository URL to your Home Assistant addon store:
   ```
   https://github.com/craqs/ha-brother-airprint
   ```
2. Install the "Brother AirPrint" addon
3. Start the addon
4. Open the CUPS web interface at `http://<your-ha-ip>:631`

## Printer Setup

1. Connect your Brother HL-1110 printer via USB to your Home Assistant host
2. Open CUPS web UI: `http://<your-ha-ip>:631`
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

## Requirements

- Home Assistant OS on Raspberry Pi 4 (aarch64)
- Brother HL-1110 printer connected via USB

## Troubleshooting

- **Printer not detected**: Check that the USB cable is connected and the printer is powered on. Check addon logs for USB device detection.
- **AirPrint not visible**: Ensure the addon is running with host network mode. Avahi needs direct network access for mDNS.
- **Print quality issues**: Access CUPS web UI and adjust printer options (resolution, paper type).
