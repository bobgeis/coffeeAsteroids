
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


H = _first.request('helper')
L = _first.request('loader')
E = _first.request('engine')

ctx = null
engine = null

$ ->
	console.log "DOM ready"
	_first.applyAllModules()
	setup()
	raf()

setup = ->
	L.loadAllImgs()
	$canvas = $('<canvas>',{'id':'gameCanvas'})
	$('#addCanvasHere').append($canvas)
	ctx = $canvas[0].getContext '2d'
	engine = new E.Engine(ctx)
	console.log  'setup'

stopToken = null
lastTime = 0
raf = (time = 0) ->
	dt = time - lastTime
	lastTime = time
	stopToken = requestAnimationFrame raf
	engine.draw()
	engine.update(dt)
	# # do stuff
	# ctx.fillStyle = "#000000"
	# ctx.fillRect(0,0,ctx.canvas.width,ctx.canvas.height)
	# x = 50
	# y = 50
	# # console.log L.ship
	# for key, img of L.img.ship 
	# 	ctx.drawImage img, x, y
	# 	x += 30
	# 	y += 30



