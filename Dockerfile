ARG BUILD_FROM
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install CUPS, Avahi, and supporting packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    cups \
    cups-pdf \
    avahi-daemon \
    libnss-mdns \
    dbus \
    colord \
    a2ps \
    procps \
    sudo \
    locales \
    && rm -rf /var/lib/apt/lists/*

# Enable i386 architecture and install qemu + i386 runtime libraries
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       qemu-user-static \
       libc6:i386 \
    && rm -rf /var/lib/apt/lists/*

# Install Brother HL-1110 drivers (i386)
COPY drivers/ /tmp/brother/
RUN dpkg -i --force-all /tmp/brother/hl1110lpr-3.0.1-1.i386.deb \
    && dpkg -i --force-all /tmp/brother/hl1110cupswrapper-3.0.1-1.i386.deb \
    && rm -rf /tmp/brother

# Wrap all i386 ELF binaries with qemu-i386-static launcher scripts.
# This avoids dependency on host binfmt_misc registration.
RUN for bin in \
      /opt/brother/Printers/HL1110/lpd/rawtobr3 \
      /opt/brother/Printers/HL1110/lpd/brprintconflsr3 \
      /opt/brother/Printers/HL1110/cupswrapper/brcupsconfig4; \
    do \
      if [ -f "$bin" ]; then \
        mv "$bin" "${bin}.orig" \
        && printf '#!/bin/sh\nexec /usr/bin/qemu-i386-static %s.orig "$@"\n' "$bin" > "$bin" \
        && chmod +x "$bin"; \
      fi; \
    done

# Create print user for CUPS administration
RUN useradd --groups sudo,lp,lpadmin --create-home \
    --home-dir /home/print --shell /bin/bash \
    --password "$(openssl passwd -1 print)" print \
    && sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Create required runtime directories
RUN mkdir -p /var/run/dbus /var/run/avahi-daemon

# Copy rootfs overlay
COPY rootfs /

EXPOSE 631
