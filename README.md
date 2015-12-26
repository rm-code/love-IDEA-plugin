# love-IDEA-plugin
A [LÖVE](http://love2d.org)-Plugin for [IntelliJ IDEA](http://www.jetbrains.com/idea/).

![example](https://raw.githubusercontent.com/rm-code/love-IDEA-plugin/master/screenshots/preview.png)

-----------

This plugin enables auto-complete functionality for functions of the LÖVE-framework while using [Lua for IntelliJ Idea](https://bitbucket.org/sylvanaar2/lua-for-idea/wiki/Home).

The repository contains different folders for the following LÖVE versions:
- [0.10.0](https://love2d.org/wiki/0.10.0)
- [0.9.2](https://love2d.org/wiki/0.9.2)
- [0.9.1](https://love2d.org/wiki/0.9.1)

##Prerequisites

- [IntelliJ IDEA](http://www.jetbrains.com/idea/)
- [Lua Plugin for IntelliJ Idea](https://bitbucket.org/sylvanaar2/lua-for-idea/wiki/Home)
- This Plugin

## Installing the Plugin

1. Open a Project in IntelliJ IDEA
2. Search for the __External Libraries__ Item in the Project View and extend it
3. Right click on the Lua SDK your project uses
4. Select __Open Library Settings__
5. In the new window look for a __+__ button on the right side
6. From the menu select the path where this Plugin can be found on your computer and press __OK__
7. The __Classpath__-Tab should now contain a new item showing the path to the Plugin
8. Select __Apply__ and __OK__

[Additional Instructions](https://bitbucket.org/sylvanaar2/lua-for-idea/wiki/Installing_a_Custom_API)

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
