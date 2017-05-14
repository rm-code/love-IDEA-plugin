# love-IDEA-plugin
A [LÖVE](http://love2d.org)-Plugin for [IntelliJ IDEA](http://www.jetbrains.com/idea/) and [PHPStorm](https://www.jetbrains.com/phpstorm/).

![example](https://raw.githubusercontent.com/rm-code/love-IDEA-plugin/master/screenshots/preview.png)

-----------

This plugin enables auto-complete functionality and quick documentation for functions of the LÖVE-framework while using [Lua for IntelliJ Idea](https://bitbucket.org/sylvanaar2/lua-for-idea/wiki/Home).

## Features

- Smart code completion: Start typing and IntelliJ will show you suggestions based on the LÖVE API
- Bring up the quick documentation of a function by hovering over it while pressing CTRL

## LÖVE versions

The repository contains different folders for the following LÖVE versions:
- [0.10.2](https://love2d.org/wiki/0.10.2)
- [0.10.1](https://love2d.org/wiki/0.10.1)
- [0.10.0](https://love2d.org/wiki/0.10.0)
- [0.9.2](https://love2d.org/wiki/0.9.2)
- [0.9.1](https://love2d.org/wiki/0.9.1)

## Prerequisites

- [IntelliJ IDEA](http://www.jetbrains.com/idea/) or [PHPStorm](https://www.jetbrains.com/phpstorm/)
- [Lua Plugin for IntelliJ Idea](https://bitbucket.org/sylvanaar2/lua-for-idea/wiki/Home)
- This Plugin

## Installing the Plugin

### IntelliJ-IDEA
1. Open a Project in IntelliJ IDEA
2. Open __File__ > __Project Structure__
3. Select __Libraries__ (under Project Settings) or __Global Libraries__ (under Platform Settings)
4. Click on the __+__-button
5. Select __New Lua Library__
6. From the menu select the appropriate path to the doc files for your LÖVE version (e.g. love_0101 for LÖVE 0.10.1) and press __OK__
7. Select __Apply__ and __OK__

If you run into problems you can find additional instructions [here](https://www.jetbrains.com/idea/help/configuring-module-dependencies-and-libraries.html) and [here](https://bitbucket.org/sylvanaar2/lua-for-idea/wiki/Installing_a_Custom_API). There's also a great tutorial [available on youtube](https://www.youtube.com/watch?v=pw7WU-hnU0g).

### PHPStorm
You can also use the library with PHPStorm:
![scr](https://cloud.githubusercontent.com/assets/5689499/23850658/a3f72b54-07e0-11e7-8832-6c514d91ba87.png)

## License

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
