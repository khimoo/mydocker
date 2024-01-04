FROM debian:bookworm-slim

# https://wiki.winehq.org/Debian
# Install sudo and x11-apps
RUN dpkg --add-architecture i386 && \
    mkdir -pm755 /etc/apt/keyrings/ && \
    apt-get update && apt-get upgrade && \
    apt-cache search x11 && \
    apt-get install -y x11-apps wget apt-utils cabextract && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources && \
    apt-get update && \
    apt-get install -y --install-recommends winehq-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workdir
COPY ./exefiles/ /workdir/exefiles/
RUN wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    apt-get update && \
    apt-get install -y cabextract && \
    ./winetricks -q corefonts cjkfonts
#    wget --no-check-certificate https://ja.osdn.net/projects/ume-font/downloads/22212/umefont_670.tar.xz && \
#    tar Jxvf umefont_670.tar.xz && \
#    rm umefont_670.tar.xz && \
#    mv umefont_670 /usr/share/fonts/truetype/ && \
#    mkdir NotoSansCJKjp && \
#    cd NotoSansCJKjp && \
#    wget --no-check-certificate https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip && \
#    unzip NotoSansCJKjp-hinted.zip && \
#    rm NotoSansCJKjp-hinted.zip && \
#    cd ../ && \
#    mv NotoSansCJKjp /usr/share/fonts/truetype/ && \
#    mkdir NotoSerifCJKjp && \
#    cd NotoSerifCJKjp && \
#    wget --no-check-certificate https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKjp-hinted.zip && \
#    unzip NotoSerifCJKjp-hinted.zip && \
#    rm NotoSerifCJKjp-hinted.zip && \
#    cd ../ && \
#    mv NotoSerifCJKjp /usr/share/fonts/truetype/ && \
#    fc-cache -fv && \
#    wget --no-check-certificate https://gist.githubusercontent.com/nogajun/6095ed8488ef9449e63dc1ce578ae55e/raw/85ced2a3dd8a8ed960e3de96b2127f960cfc1de6/wine-japanese.reg && \
#    regedit wine-japanese.reg
