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
        @clones = [
            H.newPt()
            H.newPt()
            H.newPt()
            H.newPt()
            H.newPt()
            H.newPt()
            H.newPt()
            H.newPt()
            H.newPt()
        ]
        @setClones()

    setImg : (@img) ->
        @r_img = @img.canvas.width/2

    getImg : ->
        @img
    update : (dt) ->
        if not @alive
            return false
        return true
    draw : (ctx) ->
        for pt in @setClones()
            if H.onScreenEntity pt, @r_img
                H.drawEntity ctx, @getImg(), pt
    centerCamera : ->
        H.updateCamera @pos

    setClones : ->
        s = C.tileSize
        x = @pos.x
        y = @pos.y
        @clones[0].setXY x-s,y-s
        @clones[1].setXY x-s,y
        @clones[2].setXY x-s,y+s
        @clones[3].setXY x,y-s
        @clones[4].setXY x,y
        @clones[5].setXY x,y+s
        @clones[6].setXY x+s,y-s
        @clones[7].setXY x+s,y
        @clones[8].setXY x+s,y+s
        return @clones

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
        @setClones()
        super dt


    setAcc : (@acc) ->
        if @acc and @acc != 0
            @thrust = true
        else
            @thrust = false

    # set radius
    setR : (@r) ->

    # set mass
    setM : (@m) ->

    # draw the entity
    draw : (ctx) ->
        for pt in @clones
            if H.onScreenEntity pt, @r_img
                H.drawEntity ctx, @getImg(), pt, @a
                return

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
        for pt in obj.clones
            if @pos.collide pt, @r+obj.r
                return pt
        return false

    # bounce this of off obj (both need .r as radius .m as mass)
    bounce : (obj) ->
        pt = @collide obj
        if pt
            @bouncePos obj, pt
            @bounceVel obj, pt

    bouncePos : (obj,pt) ->
        a = pt.getFaceAngle @pos
        r = obj.r + @r
        H.pt.setPos pt
        @pos.setPos H.pt.transPolar r,a

    bounceVel : (obj,pt) ->
        # get mass coeffs
        ma = (@m - obj.m) / (@m + obj.m)
        mb = obj.m * 2 / (@m + obj.m)
        # angle from this to obj
        a = @pos.getFaceAngle(pt)
        # vu = component perpendicular to collision, vw is parallel
        vu = @vel.x * Math.cos(a) - @vel.y * Math.sin(a)
        vw = @vel.x * Math.sin(a) + @vel.y * Math.cos(a)
        # ovu & ovw are for obj's vel components
        ovu = obj.vel.x * Math.cos(a) - obj.vel.y * Math.sin(a)
        # ovw = obj.vel.x * Math.sin(a) + obj.vel.y * Math.cos(a)
        # bounce the perpendicular component
        vuf = ma * vu + mb * ovu
        # not calculated -> neglected:
        #   effects of elasticity on perpendicular component
        #   effects of friction on parallel component
        # rotate back to cartesian frame
        vxf = vuf * Math.cos(a) + vw * Math.sin(a)
        vyf = -vuf * Math.sin(a) + vw * Math.cos(a)
        # set veloctity
        @vel.setXY vxf, vyf



E.MovingEntity = MovingEntity


E.BgTile = ->
    bgTile = new Entity(H.origin)
    bgTile.setImg A.img.bg.tile
    return bgTile


E.PlayerShip = ->
    playerShip = new MovingEntity(H.origin,H.HALFPI,H.pt.setXY(0,0.5),0)
    playerShip.setImg A.img.ship.rayciv
    playerShip.setR playerShip.r_img
    playerShip.setM C.shipMass
    playerShip.drag = C.shipDrag
    return playerShip


E.LuckyBase = ->
    p = -900
    luckyBase = new MovingEntity(H.pt.setXY(0,p),0,H.origin,0)
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
    return rock

E.spawnRock = (dt) ->
    Math.random() < C.rockSpawnChance * dt

