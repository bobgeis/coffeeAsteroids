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
        console.log pos
        @pos = pos.copyPos()
        @alive = true

	setImg : (@img) ->
        @r_img = @img.canvas.width/2

	getImg : ->
		@img

	update : (dt) ->
        if not @alive
            return false
        return true

	draw : (ctx) ->
        if H.onScreenEntity @pos, @r_img
            H.drawEntity ctx, @getImg(), @pos

	centerCamera : ->
		H.updateCamera @pos
E.Entity = Entity


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

E.Beam = Beam


class MovingEntity extends Entity

    constructor : (pos,@a,vel,@va) ->
        super pos
        @vel = vel.copyPos()

    update : (dt) ->
        @pos.transXY @vel.x*dt, -@vel.y*dt
        @a += @va * dt
        if @thrust
            @vel.transPolar @acc,@a
        if @drag
            @vel.scale @drag*dt
        super dt

    setAcc : (@acc) ->
        if @acc and @acc != 0
            @thrust = true
        else
            @thrust = false

    draw : (ctx) ->
        if H.onScreenEntity @pos, @r_img
            H.drawEntity ctx, @getImg(), @pos, @a

E.MovingEntity = MovingEntity



E.PlayerShip = () ->
    playerShip = new MovingEntity(H.origin,0,H.origin,0)
    playerShip.setImg A.img.ship.dropciv
    return playerShip



E.LuckyBase = ->
    luckyBase = new MovingEntity(H.origin,0,H.origin,0)
    luckyBase.setImg A.img.ship.baselucky
    return luckyBase
