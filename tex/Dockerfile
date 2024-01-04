FROM debian:bookworm-slim

# Install sudo and x11-apps
RUN apt-get update && apt-get upgrade && \
    apt-get install -y sudo && \
    apt-cache search x11 && \
    apt-get install -y x11-apps xdg-utils xpdf perl wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

## useradd
#RUN mkdir /home/texuser/ && mkdir /home/texuser/workdir && \
#    useradd -d /home/texuser -s /bin/bash -g users -G audio,cdrom,floppy,lp,plugdev,video texuser && \
#    echo "texuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# install TeXLive and latexmk
WORKDIR /tmp
COPY ./install.sh ./
RUN chmod +x /tmp/install.sh && \
    TERM=xterm /tmp/install.sh
CMD PATH="/usr/local/texlive/$(ls -d /tmp/install-tl-2* | cut -c 17-20)/bin/x86_64-linux:$PATH" && \
    export PATH=$PATH && \
    bash

WORKDIR /workdir
