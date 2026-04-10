# Home Assistant AirBrother addon

## Goal

The goal of this Home Assistant addon is to create an addon/app that will be running in Home Assistant and providing support for AirPrint to locally connected printer: Brother HL1100

## Challenge

The problem is that Brother doesn't offer fully compatible drivers for this printer on ARM64 platform. There are some opensource alternatives, but they lack features and proper quality, so I want to stick to original linux driver. The challenge might be the fact, that driver was designed for i386, and needs to be deployed in 64bit ARM environment inside of container.

## What I tried

### CUPS Addon
I used CUPS/AirPrint integration before, with opensource driver, you can find it here: https://github.com/craqs/homeassistant-addon-cups-airprint but it wasn't working well. Basically the opensource driver has serious problem with buffers, and it doesn't work in HQ mode, also it requires some additional patching of CUPS wrappers to make it properly work and ignore some errors.

### Separate RPi instance
After many issues with previous approach I tried another one - I used my spare RPi 3B and followed this guide: https://taswar.zeytinsoft.com/brother-1110-printer-on-raspberry-pi/ and it actually worked really well! It is sort of hacky way to install i386 version of driver, but it worked and I was pretty satisified.

## What I want
### Plan
I want you to investigate and implement (if possible) a Home Assistant Addon that will run CUPS with the driver for my printer from this guide https://github.com/craqs/homeassistant-addon-cups-airprint
I have RPi 4 with Home Assistant running on HAOS (so it supports containers, etc.). I'm not sure if this is possible, but it would be great if I could just get rid of separate RPi instance in favor of addon running in Home Assistant (and printer connected via USB to this RPi).

### Implementation
- create repository with gh tool (is configured)
- make sure my real name and last name is not used as an author or commiter, use "craqs" instead
- commit and push all changes to repo, create tags/releases when feature is complete
- ask me to test changes on HA if needed
- if something is unclear - don't hesitate, just ask to get clarification from user
- the implementation should include CUPS server with original linux driver (based on guide I mentioned before), with airprint enabled (I have plenty of Apple devices and want to use this way to print)

### Environment
- target is latest version of Home Assistant running in 64bit mode on RPi 4
- printer will be connected locally via USB
- you can use podman for tests (but I'm not sure if we can build cross-arch images)

If that helps, I can provide you access to Home Assistant instance and maybe you could test your changes without my assistance. Please confirm if this is needed.
