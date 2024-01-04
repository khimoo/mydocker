#!/bin/bash
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar xvf install-tl-unx.tar.gz
cd install-tl-2*
# scheme-full,collection-langjapaneseを選択
echo "selected_scheme scheme-full" > texlive.profile
echo "collection-langjapanese 1" >> texlive.profile
./install-tl -profile texlive.profile

latest=$(ls -d /usr/local/texlive/20* | sort -V | tail -n 1)
$latest/bin/x86_64-linux/tlmgr install latexmk
