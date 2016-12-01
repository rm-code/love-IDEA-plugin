#!/bin/bash
readonly LOVE_DIR=love_0102

rm -rf api
git clone --depth=1 https://github.com/rm-code/love-api api
mkdir docs
lua generator.lua
mv docs/ ../$LOVE_DIR
rm -rf api
