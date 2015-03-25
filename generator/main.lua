---
-- Run as a love file to generate API code automatically.
--
-- The LÖVE API lives at https://github.com/rm-code/love-api
--
--
function love.load()
    local api = require('love_api');

    love.filesystem.append('love.lua', "module('love')\r\n");

    for i, f in ipairs(api.callbacks) do
        love.filesystem.append('love.lua', 'function ' .. f.name .. '() end\r\n');
    end

    for i, f in ipairs(api.functions) do
        love.filesystem.append('love.lua', 'function ' .. f.name .. '() end\r\n');
    end

    for i, m in ipairs(api.modules) do
        love.filesystem.append(m.name .. '.lua', "module('love." .. m.name .. "')\r\n\n");
        for ii, f in ipairs(m.functions) do
            love.filesystem.append(m.name .. '.lua', 'function ' .. f.name .. '() end\r\n');
        end
    end

    print('Done!');
    love.event.quit();
end

--==================================================================================================
-- Created 14.09.14 - 22:09                                                                        =
--==================================================================================================