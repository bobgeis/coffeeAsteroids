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
    r_img : 0

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


# beams are game objects that are line segments, eg: disruptor beam
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

    acc : 0     # acceleration
    r : 0       # radius
    m : 0       # mass
    thrust : false  # thrusting?
    drag : false    # affected by drag?

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

    setR : (@r) ->
    setM : (@m) ->

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

    # is obj colliding with this? (both need .r as radius)
    collide : (obj) ->
        @pos.collide obj.pos, @r+obj.r

    # bounce this of off obj (both need .r as radius .m as mass)
    bounce : (obj) ->
        @bouncePos obj
        @bounceVel obj

    bouncePos : (obj) ->
        a = obj.pos.getFaceAngle @pos
        r = obj.r + @r
        H.pt.setPos obj.pos
        @pos.setPos H.pt.transPolar r,a

    bounceVel : (obj) ->
        ma = (@m - obj.m) / (@m + obj.m)
        mb = obj.m * 2 / (@m + obj.m)
        vxf = ma * @vel.x + mb * obj.vel.x
        vyf = ma * @vel.y + mb * obj.vel.y
        @vel.setXY vxf, vyf
# (firstBall.speed.x * (firstBall.mass – secondBall.mass) +
# (2 * secondBall.mass * secondBall.speed.x))
#  / (firstBall.mass + secondBall.mass);

E.MovingEntity = MovingEntity


E.BgTile = ->
    bgTile = new Entity(H.origin)
    bgTile.setImg A.img.bg.tile
    return bgTile


E.PlayerShip = ->
    playerShip = new MovingEntity(H.origin,0,H.origin,0)
    playerShip.setImg A.img.ship.raymine
    playerShip.setR playerShip.r_img
    playerShip.setM C.shipMass
    playerShip.drag = C.shipDrag
    return playerShip


E.LuckyBase = ->
    luckyBase = new MovingEntity(H.origin,0,H.origin,0)
    luckyBase.setImg A.img.ship.baselucky
    luckyBase.setR luckyBase.r_img
    luckyBase.setM C.baseMass
    return luckyBase

E.BuildBase = ->
    p = C.tileSize /2 - 20
    buildBase = new MovingEntity(H.pt.setXY(p,p),0,H.origin,0)
    buildBase.setImg A.img.ship.basebuild
    buildBase.setR buildBase.r_img
    buildBase.setM C.baseMass
    return buildBase

E.RandRock = ->
    p = C.tileSize /2
    rock = new MovingEntity(H.pt1.randomInBox(-p,p,-p,p),0,
                            H.pt2.randomInCircle(C.rockVel),0)
    rock.setImg A.img.space.r0
    rock.setR rock.r_img
    rock.setM C.rockMass
    # console.log rock
    return rock

E.spawnRock = (dt) ->
    Math.random() < C.rockSpawnChance * dt

