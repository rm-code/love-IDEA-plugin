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

local function openFile(name)
    local file = io.open(OUTPUT_DIR .. '/' .. name, 'w')
    assert(file, "ERROR: Can't write file: " .. name)
    return file
end

---
-- The LÖVE API lives at https://github.com/love2d-community/love-api
--
local function generate()
    local api = require('api.love_api')

    assert(api, 'LÖVE api not found.')

    print('Generating LOVE snippets ... ')

    local sourceFile = openFile('love.lua')
    local docFile = openFile('love.doclua')

    -- docFile2:write("love = {}\r\n")
    sourceFile:write("module('love')\r\n")
    docFile:write(DOCLUA_HEADER)
    docFile:write("SIGNATURES = {\r\n")

    for _, f in ipairs(api.callbacks) do
        sourceFile:write('function ' .. f.name .. '() end\r\n')

        --docFile2:write('---[Callback]\n---' .. f.description:gsub('\n', '\n--- ') .. '\r\n')
        -- Find the args of the first variant
        local args = {}
        local variant = f.variants[1]
        if variant.arguments then
            for _, a in ipairs(variant.arguments) do
                --docFile2:write("---@param " .. a.name .. ' ' .. a.type .. ' @' .. a.description:gsub('\n', '\n--- ') .. '\r\n')
                table.insert(args, a.name)
            end
        end

        docFile:write('["love.' .. f.name .. '"] = [=[' .. f.name .. '(' .. table.concat(args, ', ') .. ') - ' .. f.description .. ']=],\r\n')
        --docFile2:write('function love.' .. f.name .. '(' .. table.concat(args, ', ') .. ') end\r\n')
    end

    for _, f in ipairs(api.functions) do
        sourceFile:write('function ' .. f.name .. '() end\r\n')

        -- Find the args of the first variant
        local args = {}
        local variant = f.variants[1]

        --docFile2:write('--- ' .. f.description:gsub('\n', '\n--- ') .. '\r\n')
        if variant.arguments then
            for _, a in ipairs(variant.arguments) do
                --docFile2:write("---@param " .. a.name .. ' ' .. a.type .. ' @' .. a.description:gsub('\n', '\n--- ') .. '\r\n')
                table.insert(args, a.name)
            end
        end

        docFile:write('["love.' .. f.name .. '"] = [=[' .. f.name .. '(' .. table.concat(args, ', ') .. ') - ' .. f.description .. ']=],\r\n')
        --docFile2:write('function love.' .. f.name .. '(' .. table.concat(args, ', ') .. ') end\r\n')
    end

    docFile:write('}\r\n');

    for _, m in ipairs(api.modules) do
        -- Create new files for each module.
        sourceFile = openFile(m.name .. '.lua')
        docFile = openFile(m.name .. '.doclua')

        --docFile2:write("---@class _" .. m.name .. '\r\n')
        -- docFile2:write("local  "..m.name..' = {}\r\n')
        --docFile2:write("---@type _" .. m.name .. '\r\n')
        --docFile2:write("love." .. m.name .. ' = {}\r\n')

        sourceFile:write("module('love." .. m.name .. "')\r\n\n")

        docFile:write(DOCLUA_HEADER)
        docFile:write("SIGNATURES = {\r\n")
        docFile:write('["love.' .. m.name .. '"] = [=[love.' .. m.name .. ' - ' .. m.description .. ']=],\r\n')

        for _, f in ipairs(m.functions) do
            sourceFile:write('function ' .. f.name .. '() end\r\n')
            -- Find the args of the first variant
            local args = {}
            local variant = f.variants and f.variants[1] or {}

            --docFile2:write('--- ' .. f.description:gsub('\n', '\n--- ') .. '\r\n')
            if variant.arguments then
                for _, a in ipairs(variant.arguments) do
                    --docFile2:write("---@param " .. a.name .. ' ' .. a.type .. ' @' .. a.description:gsub('\n', '\n--- ') .. '\r\n')
                    table.insert(args, a.name)
                end
            end

            docFile:write('["love.' .. m.name .. '.' .. f.name .. '"] = [=[' .. f.name .. '(' .. table.concat(args, ', ') .. ') - ' .. f.description .. ']=],\r\n')
            --docFile2:write('function _' .. m.name .. '.' .. f.name .. '(' .. table.concat(args, ', ') .. ') end\r\n')
        end
        docFile:write('}\r\n')
    end

    print('Done!')
end

function checkType(n)
    if n == 'thread' then
        return 'Thread'
    end
    return n;
end

function generate2()
    local api = require('api.love_api')
    local docFile2 = openFile('love.spec.lua')
    local enumFile = openFile('love.enum.lua')

    local function writeLine(s)
        docFile2:write(s .. '\r\n')
    end

    local function writeMethods(m, tb, isType)
        local types = {}

        local function writeParam(prefix, tb, args)
            for _, a in ipairs(tb) do
                local typeName = checkType(a.type)
                if a.table then
                    typeName = "table_" .. (m.name or 'love') .. '_' .. a.name
                    types[typeName] = a.table
                end
                writeLine("---@" .. prefix .. " " .. a.name .. ' ' .. typeName .. ' @' .. a.description:gsub('\n', '\n--- ') .. '')
                if args then
                    table.insert(args, a.name)
                end
            end
        end

        for i, f in ipairs(tb) do
            writeLine('--- ' .. f.description:gsub('\n', '\n--- ') .. '')
            local args = {}
            local variant = f.variants and f.variants[1] or {}
            if variant.arguments then
                writeParam('param', variant.arguments, args)
            end
            if variant.returns then
                for _, a in ipairs(variant.returns) do
                    local typeName = checkType(a.type)
                    if a.table then
                        typeName = "table_" .. (m.name or 'love') .. '_' .. a.name
                        types[typeName] = a.table
                    end
                    writeLine("---@return " .. typeName .. ' @' .. a.name .. ' \n---' .. a.description:gsub('\n', '\n--- ') .. '')
                end
            end
            writeLine('function ' .. (m.name or 'love') .. (isType and ':' or '.') .. f.name .. '(' .. table.concat(args, ', ') .. ') end')
        end
        for k, v in pairs(types) do
            writeLine("---@class " .. k)
            for i, a in ipairs(v) do
                local typeName = checkType(a.type)
                if (a.table) then
                    typeName = k .. '_' .. a.name
                    types[typeName] = a.table
                end
                writeLine('---@field public ' .. a.name .. ' ' .. typeName .. ' @' .. a.description:gsub('\n', '\n--- '))
            end
            --writeLine('local ' .. k .. ' = {}')
            writeLine('')
            writeLine('')
        end
    end

    local function writeType(m, t)
        writeLine("--- " .. t.description:gsub('\n', '\n--- ') .. " ")
        writeLine("---@class " .. checkType(t.name) .. (t.parenttype and (" : " .. t.parenttype) or ""))
        if t.constructors then
            for i, ctor in ipairs(t.constructors) do
                writeLine("---[constructor]")
                writeLine("---@return " .. checkType(t.name) .. '')
                writeLine('function ' .. (m.name or 'love') .. '.' .. ctor .. "(...) end")
            end
        end
        if t.functions then
            writeMethods(t, t.functions, true)
        end
    end

    local function writeEnums(m, enums)
        local function writeLine(s)
            enumFile:write(s .. '\r\n')
        end

        for i, v in ipairs(enums) do
            writeLine("---" .. v.description:gsub('\n', '\n--- '))
            writeLine("---@class " .. v.name)
            writeLine("---@type " .. v.name)
            writeLine("" .. v.name .. '={}')
            for i, a in ipairs(v.constants) do
                writeLine("---@field " .. a.name .. ' @' .. a.description:gsub('\n', '\n--- '))
                local code = a.name:gsub("\\", "\\\\"):gsub("'", "\\'")
                writeLine('' .. v.name .. "['" .. code .. '\'] = \'' .. code .. "'")
            end
        end
    end

    function writeModule(m)
        if m.name then
            local n = m.name
            m.name = 'love_' .. m.name
            writeLine("---@class " .. checkType(m.name) .. " ")
            writeLine("---@type " .. checkType(m.name) .. '')
            writeLine("love." .. n .. ' = {}')
        end
        if m.enums then
            writeEnums(m, m.enums)
        end
        if m.types then
            for i, v in ipairs(m.types) do
                writeType(m, v)
            end
        end
        for i, v in ipairs(({ 'callbacks', 'functions' })) do
            if m[v] then
                writeMethods(m, m[v])
            end
        end
        if m.modules then
            for i, v in ipairs(m.modules) do
                writeModule(v)
            end
        end
    end

    writeLine("---@class love")
    --for i, v in ipairs(api.modules) do
    --    writeLine("---@field " .. v.name .. ' ' .. checkType(v.name) .. " @" .. v.description:gsub('\n', '\n--- '))
    --end
    writeModule(api)
end

generate();
generate2();
