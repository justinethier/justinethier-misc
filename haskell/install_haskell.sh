#!/usr/bin/env bash
# Script to automate building of GHC 7.2.2

sudo apt-get install libc6-dev libedit-dev libncurses5-dev libgmp3-dev autoconf automake libtool gcc make perl python ghc6 happy alex darcs libffi-dev docbook-utils docbook-utils-pdf docbook-style-xsl strace patch libcurl-dev zlib-dev

cd /tmp

wget http://www.haskell.org/ghc/dist/7.6.1/ghc-7.6.1-src.tar.bz2
tar jxvf ghc-7.6.1-src.tar.bz2
cd ghc-7.6.1

echo "BuildFlavour = quick" > mk/build.mk
cat mk/build.mk.sample >> mk/build.mk

perl boot
./configure --prefix=/usr/local
make
sudo make install
