#!/bin/bash
readonly LOVE_DIR=love_113

git clone --depth=1 https://github.com/rm-code/love-api api
mkdir docs
lua generator.lua
mv -v docs/* ../$LOVE_DIR/
rmdir docs
rm -rf api
