
"""
Asteroids in Coffeescript
or
Look Out Space Mice!

This is a learning project made while learning coffeescript.
"""

"""
Some things learned:


TODO:


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


