local tiny = require('lib.tiny')

---@class HitTestSystem
---@field objects HitTestTree[]
---@field hitObject HitTestTree
---@field private roots table<number, HitTestTree[]>
---@field private jmp table<number, number>
local HitTestSystem = tiny.system(Base:extend())

---@class Position
---@field public x number
---@field public y number

---@class Size
---@field public w number
---@field public h number

---@class HitTestTree
---@field public zIndex number
---@field public pos Position
---@field public size Size
---@field public isChild boolean
---@field public children HitTestTree[]

function HitTestSystem:new(layer)
    self.filter = tiny.requireAll("pos", "size", 'zIndex', function(s, e)
        return e.layer == layer
    end)
    self.objects = {}
    self.roots = {}
    self.jmp = {}
    self.dt = 0
end

---@param e HitTestTree
---@param y number
---@param x number
local function check(e, x, y)
    --if e.parent then
        --print(e.parent.pos.x + x, e.parent.pos.y + y, x, y)
    --end
    local ex = (e.parent and e.parent.pos.x or 0) + e.pos.x
    local ey = (e.parent and e.parent.pos.y or 0) + e.pos.y
    return ex <= x and ex + e.size.w >= x and ey <= y and ey + e.size.h >= y
end

local frameDt = 1 / 60

function HitTestSystem:update(dt)
    if not love.window.hasFocus() then
        return
    end
    self.dt = self.dt + dt
    if (self.dt >= frameDt) then
        self.dt = 0
    else
        return
    end
    local x, y = love.mouse.getPosition()
    if self.hitObject then
        self.hitObject.mouseOver = false
        self.hitObject = nil
    end
    local keys = map(keys(self.roots), function(e) return tonumber(e) end)
    sort(keys, function(b, a) return b > a end)
    local hit = false
    for i, v in pairs(keys) do
        hit = self:check(x, y, self.roots[v], not hit)
    end
end

---@param elements HitTestTree[]
---@param y number
---@param x number
function HitTestSystem:check(x, y, elements, unhit)
    for i, e in ipairs(elements) do
        local hit = unhit and e.hitTest and check(e, x, y)
        if e.children and #e.children > 0 then
            unhit = not self:check(x, y, e.children, unhit)
            hit = hit and unhit
        end
        unhit = unhit and not hit
        e.mouseOver = hit
        if hit then
            self.hitObject = e;
        end
    end
    return not unhit
end

function HitTestSystem:pressed(button, x, y, isTouch)
    local e = self.hitObject
    if not check(e, x, y) then
        e = nil
    end
    if e and e.onPressed then
        e:onPressed(button, x, y, isTouch)
    end
end

function HitTestSystem:released(button, x, y, isTouch)
    local e = self.hitObject
    if e and check(e, x, y) then
        e:onReleased(button, x, y, isTouch)
    end
end

---@param e HitTestTree
function HitTestSystem:onAdd(e)
    print(string.format("id: %s, z: %s", e._id, e.zIndex))
    local jmp = self.jmp
    if not jmp[e.zIndex] then
        local last, p = nil, {}
        for i, v in pairs(jmp) do
            table.insert(p, tonumber(i))
        end
        table.sort(p)
        last = p[1]
        for _, i in ipairs(p) do
            if i > e.zIndex then
                break
            else
                last = i
            end
        end
        jmp[e.zIndex] = last and jmp[last] or 1;
    end
    table.insert(self.objects, jmp[e.zIndex], e)
    for i, v in pairs(jmp) do
        if tonumber(i) <= e.zIndex then
            jmp[i] = v + 1;
        end
    end
    if not e.isChild then
        if not self.roots[e.zIndex] then
            self.roots[e.zIndex] = {}
        end
        table.insert(self.roots[e.zIndex], 1, e)
    end
    --table.sort(self.roots, function(a, b) return b.zIndex - a.zIndex end)
    --print('jmp')
    --printAsJson(jmp)
    --print('roots', #self.roots)
    --printAsJson(toDictionary(self.roots, function(e, i)
    --    return i, map(e, function(c)
    --        return c._id
    --    end)
    --end))
    --print('objects', #self.objects)
    --printAsJson(map(self.objects, function(c)
    --    return tostring(c)
    --end))
end

function HitTestSystem:onRemove(e)
    if e.root then
        local t = self.roots[e.zIndex]
        for i, v in ipairs(t) do
            if v == e then
                table.remove(t, i)
                break
            end
        end
    end
    for i = self.jmp[e.zIndex] - 1, 1, -1 do
        if self.objects[i] == e then
            table.remove(self.objects, i)
            break
        end
        if self.objects[i].zIndex ~= e.zIndex then
            break
        end
    end
    if self.hitObject == e then
        self.hitObject = nil
    end
end

return HitTestSystem
