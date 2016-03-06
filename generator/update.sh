#!/bin/bash
readonly LOVE_DIR=love_0101

rm -rf api
git clone https://github.com/rm-code/love-api api
lua generator.lua
mv docs/*lua ../$LOVE_DIR
rm -rf api
