"""
The "Engine"

This should dispatch game input, update, and view
"""


# offering
E = {}
_first.offer('engine',E)

# requesting
C = _first.request('config')
H = _first.request('helper')
L = _first.request('loader')

MODE = {
	'load' : 1
	'splash' : 2
	'play' : 2
}

class Engine 
	constructor : (@ctx) ->
		@mode = 1
		@ctx.canvas.width = C.WID
		@ctx.canvas.height = C.HEI

	draw : ->
		"Draw the game state to the canvas"
		@ctx.fillStyle = "#000000"
		@ctx.fillRect(0,0,@ctx.canvas.width,@ctx.canvas.height)
		x = 50
		y = 50
		# console.log L.ship
		for key, img of L.img.ship 
			@ctx.drawImage img, x, y
			x += 30
			y += 30

	update : (dt) ->
		"Update the game state by dt"

	input : ->
		"Handle user input"

E.Engine = Engine














