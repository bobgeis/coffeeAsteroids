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
B = _first.request('beam')
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
        @clones =  (H.newPt() for i in [0...9])
        @setClones()

    setImg : (@img) ->
        @r_img = @img.canvas.width/2

    getImg : ->
        @img

    update : (dt) -> @alive

    draw : (ctx) ->
        for pt in @setClones()
            if H.onScreenEntity pt, @r_img
                H.drawEntity ctx, @getImg(), pt

    isAlive : -> @alive
    kill : -> @alive = false

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

    findNearest : (obj) ->
        # find the clone nearest to obj
        # assumes setClones was called already
        nearest = null
        dmin = C.tileSize
        pos = obj.pos
        for clone in @clones
            d = clone.distance pos
            if d < dmin
                dmin = d
                nearest = clone
        return nearest

E.Entity = Entity





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
        # set @pos after bouncing
        # will move this to be just outside obj
        a = pt.getFaceAngle @pos
        r = obj.r + @r
        H.pt.setPos pt
        @pos.setPos H.pt.transPolar r,a

    bounceVel : (obj,pt) ->
        # set the @vel after bouncing
        # this does not change obj.vel!
        # returns the change in veloctiy along the perpendicular component
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
        # set velocity
        @vel.setXY vxf, vyf
        return vuf - vu


E.MovingEntity = MovingEntity


class EphemeralEntity extends MovingEntity

    constructor : (@imgList,pos,a,vel,va) ->
        super(pos,a,vel,va)
        @age = 0
        @maxAge = 1
        @setImg @imgList[0]

    setMaxAge : (@maxAge) ->

    update : (dt) ->
        if @age >= @maxAge
            @alive = false
            return
        @updateImg()
        @age += dt
        super(dt)


    updateImg : ->
        @setImg @imgList[Math.floor(@age / @maxAge * @imgList.length)]



class DestructibleEntity extends MovingEntity

    constructor : (pos,a,vel,va) ->
        super(pos, a, vel, va)
        @damage = 0
        @maxDamage = 0
        @regen = 0

    update : (dt) ->
        if @damage >= @maxDamage
            @alive = false
            return
        if @damage
            @damage = Math.max 0, @damage - @regen
        super dt

    setRegen : (reg) -> @regen = reg
    setMaxDmg : (maxDmg) -> @maxDamage = maxDmg


    applyDamage : (dmg) ->
        @damage += dmg
        return @isDestroyed()

    isDestroyed : -> @damage >= @maxDamage

E.DestructibleEntity = DestructibleEntity


class RockEntity extends DestructibleEntity

    constructor : (@type,@size,pos,a,vel,va) ->
        super pos,a,vel,va
        @imgList = A.img.rock[@type][@size]
        @img = @imgList[0]
        @setR C.rockRadii[@size]
        @setM C.rockMass
        @setMaxDmg C.rockMaxDamage[@type][@size]
        @setRegen C.rockRegen

    getImg : ->
        if @damage
            index = Math.floor(@damage / @maxDamage * @imgList.length)
            @imgList[index]
        else
            @imgList[0]


E.BgTile = ->
    bgTile = new Entity(H.origin)
    bgTile.setImg A.img.bg.tile
    return bgTile


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


E.PlayerShip = ->
    playerShip = new DestructibleEntity(H.origin,H.HALFPI,H.pt.setXY(0,0.5),0)
    playerShip.setImg A.img.ship.rayciv
    playerShip.setR playerShip.r_img
    playerShip.setM C.shipMass
    playerShip.drag = C.shipDrag
    playerShip.setMaxDmg C.shipShields
    playerShip.setRegen C.shipRegen
    return playerShip


E.newRock = (type,size,pos,a,vel,va) ->
    rock = new RockEntity(A.img.rock[type][size],pos,a,vel,va)
    rock.setR C.rockRadii[size]
    rock.setM C.rockMass
    rock.setMaxDmg C.rockMaxDamage[type][size]
    rock.setRegen C.rockRegen
    return rock

E.RandRock2 = ->
    p = C.tileSize /2
    # rock = new DestructibleEntity(H.pt1.randomInBox(-p,p,-p,p),0,
    #                         H.pt2.randomInCircle(C.rockVel),0)
    # rock.setImg A.img.space.r0
    rock = new RockEntity(A.img.rock["S"][4],
        H.pt1.randomInBox(-p,p,-p,p),0,
        H.pt2.randomInCircle(C.rockVel),0)
    rock.setR C.rockRadii[4]
    rock.setM C.rockMass
    rock.setMaxDmg C.rockArmor
    rock.setRegen C.rockRegen
    return rock

E.RandRock = ->
    p = C.tileSize /2
    H.pt1.randomInBox(-p,p,-p,p)
    H.pt2.randomInCircle(C.rockVel)
    size = 4
    type = H.getRandomListValue ["C","S","M"]
    return new RockEntity( type, size, H.pt1, 0, H.pt2, 0)

E.spawnRock = (dt) ->
    Math.random() < C.rockSpawnChance * dt

E.calveRock = (oldRock) ->
    if oldRock.size < 1
        return false
    size = -1 + oldRock.size
    type = oldRock.type
    pos = oldRock.pos
    dvel = H.pt1.randomInCircle(C.rockVel)
    calves = [
        new RockEntity(type,size,pos,0,H.pt2.sum(dvel,oldRock.vel),0)
        new RockEntity(type,size,pos,0,H.pt2.diff(dvel,oldRock.vel),0)
    ]
    for calf in calves
        calf.damage = calf.maxDamage /2
    return calves

E.newExplosionOnObj = (obj) ->
    boom = new EphemeralEntity(A.img.boom,obj.pos,0,obj.vel,0)
    boom.setMaxAge C.boomMaxAge
    return boom

E.newFlashOnObj = (obj) ->
    flash = new EphemeralEntity(A.img.flash,obj.pos,0,obj.vel,0)
    flash.setMaxAge C.flashMaxAge
    return flash