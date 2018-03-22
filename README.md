# PICA - Pixel Canvas
PICA is a simple library for creating pixel art games in LOVE. Basically what it does is let you make your game run in a low resolution (for example 320x240) and then it handles the scaling for you.

This is useful for pixel art games, fantasy consoles, emulators, ect.

## Usage
First drop the module in your project and import it.
```lua
local Screen = require 'pica'
```

### Creating a Screen
screens are basically a wrapper around LOVE's canvases.
```lua
function love.load()
    ...
    screen = Screen(width, height) -- or Screen(width, height, scaling_mode)
    ...
end
```

### Drawing to it
```lua
screen:draw(function ()
    love.graphics.clear()
    -- Draw your game in here
end)
```

### Showing it in the LOVE Window
To show the canvas in the window use ```screen:present```. It will handle the scaling of the canvas.
You might be able to use this inside another canvas too, though i haven't tested that.
```lua
function love.draw()
    screen:draw(function ()
        love.graphics.clear()
        -- Draw your game here
    end)
    screen:present()
end
```

### Getting Mouse Coordinates
PICA provides a method to transform window coordinates into the coordinates of the canvas.
Local variables included mainly for clarity.
```lua
-- Doesn't have to be in love.draw, but makes this code simpler.
function love.draw()
    local mx, my = love.mouse.getPosition()
    mx, my = screen:transformCoords(mx, my)

    screen:draw(function ()
        love.graphics.clear()
        love.graphics.circle('fill', mx, my, 4)
    end)
```

## Scaling Modes
- default: Just scales up your game without any squishing or stretching. Results in black border. Works well with anti-aliasing when drawing the screen.
- integer: Same as default, but it only scales up in integer increments. This means it won't ever have pixels of an uneven size. Results in more black borders

## Full example
```lua
local Screen = require 'pica'

function love.load()
    screen = Screen(320, 240, 'integer')
end

function love.draw()
    screen:draw(function ()
        love.graphics.clear()
        love.graphics.circle('fill', 16, 16, 8)
    end)
    screen:present()
end
```