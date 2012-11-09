#!/usr/bin/env bash
# Script to automate the laborious process of building and installing Cabal

cd /tmp

# download and extract array
wget http://hackage.haskell.org/packages/archive/array/0.3.0.3/array-0.3.0.3.tar.gz
tar zxvf array-0.3.0.3.tar.gz

# download and extract bytestring
wget http://hackage.haskell.org/packages/archive/bytestring/0.9.2.0/bytestring-0.9.2.0.tar.gz
tar zxvf bytestring-0.9.2.0.tar.gz

# download and extract Cabal
wget http://hackage.haskell.org/packages/archive/Cabal/1.10.2.0/Cabal-1.10.2.0.tar.gz
tar zxvf Cabal-1.10.2.0.tar.gz

# download and extract containers
wget http://hackage.haskell.org/packages/archive/containers/0.4.2.0/containers-0.4.2.0.tar.gz
tar zxvf containers-0.4.2.0.tar.gz

# download and extract HTTP
wget http://hackage.haskell.org/packages/archive/HTTP/4000.1.2/HTTP-4000.1.2.tar.gz
tar zxvf HTTP-4000.1.2.tar.gz

# download and extract network
wget http://hackage.haskell.org/packages/archive/network/2.3.0.7/network-2.3.0.7.tar.gz
tar zxvf network-2.3.0.7.tar.gz

# download and extract zlib
wget http://hackage.haskell.org/packages/archive/zlib/0.5.3.1/zlib-0.5.3.1.tar.gz
tar zxvf zlib-0.5.3.1.tar.gz

# download and extract unix
wget http://hackage.haskell.org/packages/archive/unix/2.4.2.0/unix-2.4.2.0.tar.gz
tar zxvf unix-2.4.2.0.tar.gz

PKGS="zlib unix network array bytestring containers HTTP Cabal"
for p in ${PKGS}; { cd ${p}*/; runghc Setup.?hs configure; runghc Setup.?hs build; sudo runghc Setup.?hs install; }