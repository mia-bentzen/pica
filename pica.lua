-- PICA Screen library
--[[
MIT License

Copyright (c) 2018 Mia Bentzen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local function get_scale(width, height)
    local scale = love.graphics.getHeight() / height
    if love.graphics.getWidth()/love.graphics.getHeight() < width/height then
            scale = love.graphics.getWidth() / width
    end
    return scale
end
local function get_coords(width, height, scale)
    local w, h = width * scale, height * scale
    return love.graphics.getWidth() / 2 - w / 2, love.graphics.getHeight() / 2 - h / 2, scale
end

local scaling_modes = {
    ['default']=function (self)
        return get_coords(self.width, self.height, get_scale(self.width, self.height))
    end,
    ['integer']=function (self)
        local scale = get_scale(self.width, self.height)
        scale = math.floor(scale)
        if scale < 1 then scale = 1 end
        return get_coords(self.width, self.height, scale)
    end
}

local function Screen(width, height, scaling_mode)
    scaling_mode = scaling_mode or 'default'
    if not scaling_modes[scaling_mode] then
        error("invalid scaling_mode '"..scaling_mode.."'")
    end

    local screen = {}

    screen.width = width
    screen.height = height
    screen.canvas = love.graphics.newCanvas(width, height)
    screen.canvas:setFilter('nearest', 'nearest')

    function screen:draw(func)
        love.graphics.setCanvas(self.canvas)
        love.graphics.push()
        love.graphics.origin()
        func()
        love.graphics.pop()
        love.graphics.setCanvas()
    end
    function screen:present()
        local x,y,s = scaling_modes[scaling_mode](self)
        love.graphics.draw(self.canvas, math.floor(x), math.floor(y), 0, s)
    end

    function screen:transform(x, y)
        local sx,sy,s = scaling_modes[scaling_mode](self)
        return (x-sx) / s, (y-sy) / s
    end
    screen.transformCoords = screen.transform

    return screen
end

return Screen
