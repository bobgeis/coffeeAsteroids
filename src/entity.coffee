"""
Entity

An entity is a thing in the game world.
The player ship, rocks, shots, etc are all entities.
"""



# offering
E = {}
_first.offer('entity',E)

# requesting
A = _first.request('assets')
C = _first.request('config')
H = _first.request('helper')


# entities are game objects that exist within the game universe
class Entity

	# some default fields
	img : null

	constructor : (pos) ->
		@pos = pos.copy()
		@alive = true

	setImg : (@img) ->

	getImg : ->
		@img		

	update : (dt) ->
		if not @alive
			return false
		return true

	draw : (ctx) ->
		if H.onScreen @pos
			H.drawEntity ctx, @getImg(), @pos

	centerCamera : ->
		H.updateCamera @pos



# beams are game objects that are line segments: eg targeting beam, disruptor beam, etc.
class Beam 

	# some default fields
	wid : null
	color : null

	constructor : (@line) ->
		@alive = true

	getWidth : ->
		@wid

	getColor : ->
		@color

	update : (dt) ->
		if not @alive
			return false
		return true

	draw : (ctx) ->
        H.drawLineEntity ctx, @line, @getWidth(), @getColor()



