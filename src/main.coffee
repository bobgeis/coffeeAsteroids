
"""
Asteroids in Coffeescript
or
Look Out Space Mice!

This is a learning project made while learning coffeescript.
"""

"""

TODO:
1) Implement space mice and mousepods.
2) Changing message text at bases.
3) Save/Restore games.
4) Mouse station.
5) Better asteroid graphics.

Things to try:
1) Proper build tools/package managers.
2) Things other than canvas

"""

E = _first.request('engine')

ctx = null
engine = null

stopToken = null
lastTime = 0

setup = ->
    $canvas = $('<canvas>',{'id':'gameCanvas'})
    $('#addCanvasHere').append($canvas)
    ctx = $canvas[0].getContext '2d'
    engine = new E.Engine(ctx)

raf = (time = 0) ->
    dt = time - lastTime
    lastTime = time
    stopToken = requestAnimationFrame raf
    engine.draw()
    engine.update(dt)

$ ->
    console.log "DOM ready"
    _first.applyAllModules()
    setup()
    raf()


