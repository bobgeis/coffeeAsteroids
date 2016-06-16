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
        for row in @setClones()
            for pt in row
                if H.onScreenEntity pt, @r_img
                    H.drawEntity ctx, @getImg(), pt
    centerCamera : ->
        H.updateCamera @pos

    setClones : ->
        H.setClones @pos

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
            @vel.scale (1-@drag*dt)
        @wrap()
        super dt

    setAcc : (@acc) ->
        if @acc and @acc != 0
            @thrust = true
        else
            @thrust = false

    draw : (ctx) ->
        for row in @setClones()
            for pt in row
                if H.onScreenEntity pt, @r_img
                    if @watch then console.log pt
                    H.drawEntity ctx, @getImg(), pt, @a

    wrap : ->
        if @pos.x < -C.tileSize/2
            @pos.x += C.tileSize
        if @pos.x > C.tileSize/2
            @pos.x -= C.tileSize
        if @pos.y < -C.tileSize/2
            @pos.y += C.tileSize
        if @pos.y > C.tileSize/2
            @pos.y -= C.tileSize

E.MovingEntity = MovingEntity


E.BgTile = ->
    bgTile = new Entity(H.origin)
    bgTile.setImg A.img.bg.tile
    return bgTile




E.PlayerShip = ->
    playerShip = new MovingEntity(H.origin,0,H.origin,0)
    playerShip.setImg A.img.ship.dropciv
    playerShip.drag = C.shipDrag
    return playerShip



E.LuckyBase = ->
    luckyBase = new MovingEntity(H.origin,0,H.origin,0)
    luckyBase.setImg A.img.ship.baselucky
    return luckyBase

E.BuildBase = ->
    p = C.tileSize /2 - 20
    buildBase = new MovingEntity(H.pt.setXY(p,p),0,H.origin,0)
    buildBase.setImg A.img.ship.basebuild
    buildBase.watch = true
    return buildBase

E.RandRock = ->
    p = C.tileSize /2
    rock = new MovingEntity(H.pt1.randomInBox(-p,p,-p,p),0,
                            H.pt2.randomInCircle(C.rockVel),0)
    rock.setImg A.img.space.r0
    # console.log rock
    return rock

E.spawnRock = (dt) ->
    # console.log C.rockSpawnChance * dt
    Math.random() < C.rockSpawnChance * dt

