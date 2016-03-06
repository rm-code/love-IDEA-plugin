local OUTPUT_DIR = 'docs'
local DOCLUA_HEADER = [=[
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

local function openFile( name )
    local file = io.open( OUTPUT_DIR .. '/' .. name, 'w' )
    assert( file, "ERROR: Can't write file: " .. name )
    return file
end

---
-- The LÖVE API lives at https://github.com/love2d-community/love-api
--
local function generate()
    local api = require( 'api.love_api' )

    assert( api, 'LÖVE api not found.' )

    print( 'Generating LOVE snippets ... ' )

    local sourceFile = openFile( 'love.lua' )
    local docFile = openFile( 'love.doclua' )

    sourceFile:write( "module('love')\r\n" )
    docFile:write( DOCLUA_HEADER )
    docFile:write( "SIGNATURES = {\r\n" )

    for _, f in ipairs( api.callbacks ) do
        sourceFile:write( 'function ' .. f.name .. '() end\r\n' )

        -- Find the args of the first variant
        local args = {}
        local variant = f.variants[1]

        if variant.arguments then
            for _, a in ipairs( variant.arguments ) do
                table.insert( args, a.name )
            end
        end

        docFile:write( '["love.' .. f.name .. '"] = [=[' .. f.name .. '(' .. table.concat( args, ', ' )  .. ') - ' .. f.description .. ']=],\r\n' )
    end

    for _, f in ipairs( api.functions ) do
        sourceFile:write( 'function ' .. f.name .. '() end\r\n' )

        -- Find the args of the first variant
        local args = {}
        local variant = f.variants[1]

        if variant.arguments then
            for _, a in ipairs( variant.arguments ) do
                table.insert( args, a.name )
            end
        end

        docFile:write( '["love.' .. f.name .. '"] = [=[' .. f.name .. '(' .. table.concat( args, ', ' )  .. ') - ' .. f.description .. ']=],\r\n' )
    end

    docFile:write( '}\r\n' );

    for _, m in ipairs( api.modules ) do
        -- Create new files for each module.
        sourceFile = openFile( m.name .. '.lua' )
        docFile = openFile( m.name .. '.doclua' )

        sourceFile:write( "module('love." .. m.name .. "')\r\n\n" )

        docFile:write( DOCLUA_HEADER )
        docFile:write( "SIGNATURES = {\r\n" )
        docFile:write( '["love.' .. m.name .. '"] = [=[love.' .. m.name .. ' - ' .. m.description .. ']=],\r\n' )

        for _, f in ipairs( m.functions ) do
            sourceFile:write( 'function ' .. f.name .. '() end\r\n' )
            -- Find the args of the first variant
            local args = {}
            local variant = f.variants[1]

            if variant.arguments then
                for _, a in ipairs( variant.arguments ) do
                    table.insert( args, a.name )
                end
            end

            docFile:write( '["love.' .. m.name .. '.' .. f.name .. '"] = [=[' .. f.name .. '(' .. table.concat( args, ', ' )  .. ') - ' .. f.description .. ']=],\r\n' )
        end
        docFile:write( '}\r\n' )
    end

    print( 'Done!' )
end

generate();
