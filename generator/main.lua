---
-- Run as a love file to generate API code automatically.
--
-- The LÖVE API lives at https://github.com/rm-code/love-api
--
--
function love.load()
    local api = require('love_api');

    love.filesystem.append('love.lua', "module('love')\r\n");
    love.filesystem.append('love.doclua', DOCLUA);
    love.filesystem.append('love.doclua', "SIGNATURES = {\r\n");

    for i, f in ipairs(api.callbacks) do
        love.filesystem.append('love.lua', 'function ' .. f.name .. '() end\r\n');

        -- Find the args of the first variant
        local args = {}
        local variant = f.variants[1]

        if variant.arguments then
            for ii, a in ipairs(variant.arguments) do
                table.insert(args, a.name)
            end
        end
        love.filesystem.append('love.doclua', '["love.' .. f.name .. '"] = [=[' .. f.name .. '(' .. table.concat(args, ', ')  .. ') - ' .. f.description .. ']=],\r\n');
    end

    for i, f in ipairs(api.functions) do
        love.filesystem.append('love.lua', 'function ' .. f.name .. '() end\r\n');

        -- Find the args of the first variant
        local args = {}
        local variant = f.variants[1]

        if variant.arguments then
            for ii, a in ipairs(variant.arguments) do
                table.insert(args, a.name)
            end
        end
        love.filesystem.append('love.doclua', '["love.' .. f.name .. '"] = [=[' .. f.name .. '(' .. table.concat(args, ', ')  .. ') - ' .. f.description .. ']=],\r\n');
    end

    love.filesystem.append('love.doclua', "}\r\n");

    for i, m in ipairs(api.modules) do
        love.filesystem.append(m.name .. '.lua', "module('love." .. m.name .. "')\r\n\n");
        love.filesystem.append(m.name .. '.doclua', DOCLUA);
        love.filesystem.append(m.name .. '.doclua', "SIGNATURES = {\r\n");
        love.filesystem.append(m.name .. '.doclua', '["love.' .. m.name .. '"] = [=[love.' .. m.name .. ' - ' .. m.description .. ']=],\r\n');
        for ii, f in ipairs(m.functions) do
            love.filesystem.append(m.name .. '.lua', 'function ' .. f.name .. '() end\r\n');
            -- Find the args of the first variant
            local args = {}
            local variant = f.variants[1]

            if variant.arguments then
                for ii, a in ipairs(variant.arguments) do
                    table.insert(args, a.name)
                end
            end
            love.filesystem.append(m.name .. '.doclua', '["love.' .. m.name .. '.' .. f.name .. '"] = [=[' .. f.name .. '(' .. table.concat(args, ', ')  .. ') - ' .. f.description .. ']=],\r\n');
        end
        love.filesystem.append(m.name .. '.doclua', "}\r\n");
    end

    print('Done!');
    love.event.quit();
end

DOCLUA = [=[
local BASE_URL = "https://love2d.org"

--- Quickhelp Documentation (ctrl-J)
-- This is called when the user invokes quick help via ctrl-j, or by
-- having the quickhelp panel open and set to autolookup
-- @param name The name to get documentation for.
-- @return the documentation as an HTML or plain text string
function getDocumentation(name)
    -- Use for development
    -- disableCache()

    local data = fetchURL(getDocumentationUrl(name))

    local contentTag = [[<div id="bodyContent">]]
    local footerTag = [[<div class="printfooter]]

    local contentPos = data:find(contentTag)
    local footerPos = data:find(footerTag)

    if contentPos == nil then
        return "<html><h3>" .. name .. "</h3>Could not load from Love wiki.<br><br><b>[data from love2d.org]</b></html>"
    end

    data = data:sub(contentPos, footerPos)

    data =  data:gsub([[href="]], [[href="]]..BASE_URL)
    data =  data:gsub([[src="]], [[src="]]..BASE_URL)

    data = "<html><h3>" .. name .. "</h3>" .. data .. "<br><br><b>[data from love2d.org]</b></html>"

    return data
end

--- External Documentation URL (shift-F1)
-- This is called by shift-F1 on the symbol, or by the
-- external documentation button on the quick help panel
-- @param name The name to get documentation for.
-- @return the URL of the external documentation
function getDocumentationUrl(name)
    return BASE_URL .. "/wiki/" .. name
end


--- Quick Navigation Tooltip Text, (ctrl-hover on symbol)
-- This is called when the user ctrl-hovers over a symbol
-- @param name The name to get documentation for.
-- @return the documentation as a plain text string
function getQuickNavigateDocumentation(name)
    local sig = SIGNATURES[name]
    if not sig then return name end
    return SIGNATURES[name]
end


]=]


--==================================================================================================
-- Created 14.09.14 - 22:09                                                                        =
--==================================================================================================