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


E.BgTile = ->
    bgTile = new Entity(H.origin)
    bgTile.setImg A.img.bg.tile
    return bgTile












class MovingEntity extends Entity

    constructor : (pos,@a,vel,@va) ->
        super pos
        @vel = vel.copyPos()
        @r = 0       # radius
        @m = 0       # mass

    update : (dt) ->
        @pos.transXY @vel.x*dt, -@vel.y*dt
        @a += @va * dt
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
        @pos.wrap()

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


E.LuckyBase = ->
    p = -900
    luckyBase = new MovingEntity(H.pt.setXY(C.luckyBaseLocation[0],
                C.luckyBaseLocation[1]),
            0,H.origin,-C.baseAngVel)
    luckyBase.setImg A.img.ship.baselucky
    luckyBase.setR luckyBase.r_img
    luckyBase.setM C.baseMass
    luckyBase.name = "lucky"
    return luckyBase

E.BuildBase = ->
    p = C.tileSize /2 - 20
    buildBase = new MovingEntity(H.pt.setXY(C.buildBaseLocation[0],
                C.buildBaseLocation[1]),
            0,H.origin,C.baseAngVel)
    buildBase.setImg A.img.ship.basebuild
    buildBase.setR buildBase.r_img
    buildBase.setM C.baseMass
    buildBase.name = "build"
    return buildBase





class NavPointEntity extends MovingEntity

    constructor : (@name) ->
        H.pt1.setList C.navPtLocations[@name]
        super H.pt1, 0, H.origin, 0
        @friendly = C.navPtDefaults[@name][0]
        @active = C.navPtDefaults[@name][1]
        # @visible = false
        @visible = true
        @setImg A.img.navPts[@name][@getIndex()]
        @timer = 0
        @spawnCheck = false
        if @friendly
            @spawnType = "ship"
        else
            @spawnType = "rock"
        @spawn = null
        @spawnRates = C.navPtSpawnRates[name]

    getIndex : ->
        if @friendly and @active
            0
        else if @friendly
            1
        else if not @active
            2
        else
            3

    update : (dt) ->
        if @active
            @timer += dt
        super dt


    draw : (ctx) ->
        if @visible
            super ctx

    setActive : (@active) ->
        @setImg A.img.navPts[@name][@getIndex()]

    getSpawn : ->
        false

E.newNavPt = (name) ->
    new NavPointEntity(name)





class EphemeralEntity extends MovingEntity

    constructor : (@imgList,pos,a,vel,va) ->
        super(pos,a,vel,va)
        @age = 0
        @maxAge = 1
        @setImg @imgList[0]
        @type = null

    setMaxAge : (@maxAge) ->
    setType : (@type) ->

    update : (dt) ->
        if @age >= @maxAge
            @alive = false
            return
        @updateImg()
        @age += dt
        super(dt)

    draw : (ctx) ->
        super ctx

    updateImg : ->
        @setImg @imgList[Math.floor(@age / @maxAge * @imgList.length)]


E.newExplosionOnObj = (obj) ->
    boom = new EphemeralEntity(A.img.boom,obj.pos,0,obj.vel,0)
    boom.setMaxAge C.boomMaxAge
    return boom

E.newFlashOnObj = (obj) ->
    flash = new EphemeralEntity(A.img.flash,obj.pos,0,obj.vel,0)
    flash.setMaxAge C.flashMaxAge
    return flash

E.newTracPulseOnObj = (obj) ->
    pulse = new EphemeralEntity(A.img.tracPulse,obj.pos,0,H.origin,0)
    pulse.setMaxAge C.tracBeamDuration
    return pulse

E.spawnCrystalCheck = (rock) ->
    Math.random() < C.crystalChance[rock.type]

E.newCrystalOnObj = (obj) ->
    dvel = H.pt1.randomInCircle(C.rockVel)
    vel = H.pt2.sum(dvel,obj.vel)
    angvel = H.randPlusMinus C.crystalSpin
    crys = new EphemeralEntity(A.img.crystal,obj.pos,0,vel,angvel)
    crys.setMaxAge C.crystalMaxAge
    crys.setType "crystal"
    return crys

E.newLifepodsOnObj = (obj) ->
    # make 4 lifepods on the object
    dvel1 = H.pt1.randomOnCircle(C.lifepodVel)
    dvel2 = H.pt2.randomOnCircle(C.lifepodVel)
    list = []
    if Math.random() < C.lifepodChance[0]
        list.push new EphemeralEntity(A.img.lifepod,obj.pos,0,
            H.pt3.sum(dvel1,obj.vel),
            H.randPlusMinus C.lifepodSpin)
    if Math.random() < C.lifepodChance[1]
        list.push new EphemeralEntity(A.img.lifepod,obj.pos,Math.PI,
            H.pt4.diff(dvel1,obj.vel),
            H.randPlusMinus C.lifepodSpin)
    if Math.random() < C.lifepodChance[2]
        list.push new EphemeralEntity(A.img.lifepod,obj.pos,0,
            H.pt5.sum(dvel2,obj.vel),
            H.randPlusMinus C.lifepodSpin)
    if Math.random() < C.lifepodChance[3]
        list.push new EphemeralEntity(A.img.lifepod,obj.pos,Math.PI,
            H.pt6.diff(dvel2,obj.vel),
            H.randPlusMinus C.lifepodSpin)
    for pod in list
        pod.setMaxAge C.lifepodMaxAge
        pod.setType "lifepod"
    return list




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
        @heal dt
        super dt

    heal : (dt) ->
        if @damage
            @damage = Math.max 0, @damage - @regen

    setRegen : (reg) -> @regen = reg
    setMaxDmg : (maxDmg) -> @maxDamage = maxDmg


    applyDamage : (dmg) ->
        @damage += Math.max(0.5, Math.min(2,dmg))
        return @isDestroyed()

    isDestroyed : -> @damage >= @maxDamage

E.DestructibleEntity = DestructibleEntity





class RockEntity extends DestructibleEntity

    constructor : (@type,@size,pos,a,vel,va) ->
        super pos,a,vel,va
        @imgList = A.img.rock[@type][@size]
        @setImg @imgList[0]
        @setR C.rockRadii[@size]
        @setM C.rockMasses[@size]
        @setMaxDmg C.rockMaxDamage[@type][@size]
        @setRegen C.rockRegen

    getImg : ->
        if @damage
            index = Math.floor(@damage / @maxDamage * @imgList.length)
            @imgList[index]
        else
            @imgList[0]


E.newRock = (type,size,pos,a,vel,va) ->
    rock = new RockEntity(A.img.rock[type][size],pos,a,vel,va)
    rock.setR C.rockRadii[size]
    rock.setM C.rockMass
    rock.setMaxDmg C.rockMaxDamage[type][size]
    rock.setRegen C.rockRegen
    return rock

E.RandRock = ->
    p = C.tileSize /2
    H.pt1.randomInBox(-p,p,-p,p)
    H.pt2.randomInCircle(C.rockVel)
    size = H.getRandomListValue [0...5]
    type = H.getRandomListValue ["C","S","M"]
    return new RockEntity( type, size, H.pt1, 0, H.pt2, 0)

E.RockFromNavName = (name) ->
    H.pt1.randomInCircle(C.navPtRadius)
    H.pt1.transXY(C.navPtLocations[name][0],C.navPtLocations[name][1])
    a = H.randAng()
    v = C.rockVel + H.randPlusMinus(C.rockVel/2)
    # H.pt2.randomInCircle(C.rockVel)
    H.pt2.setPolar(v,a)
    size = H.getRandomListValue [1...5]
    type = C.navPtRockTypes[name]
    return new RockEntity( type, size, H.pt1, 0, H.pt2, 0)

E.spawnRock = ->
    Math.random() < C.rockSpawnChance

E.calveRock = (oldRock) ->
    if oldRock.size < 1
        return false
    size = -1 + oldRock.size
    type = oldRock.type
    pos = oldRock.pos
    dvel = H.pt1.randomInCircle(C.rockVel)
    dvel2 = H.pt2.randomOnCircle(C.rockVel)
    chance = C.rockCalveChance[type]
    calves = []
    if 0 < chance[0]
        calves.push new RockEntity(type,size,pos,0,H.pt3.sum(dvel,oldRock.vel),0)
    if Math.random() < chance[1]
        calves.push new RockEntity(type,size,pos,0,H.pt3.diff(dvel,oldRock.vel),0)
    if Math.random() < chance[2]
        calves.push new RockEntity(type,size,pos,0,H.pt3.sum(dvel2,oldRock.vel),0)
    if Math.random() < chance[3]
        calves.push new RockEntity(type,size,pos,0,H.pt3.diff(dvel2,oldRock.vel),0)
    for calf in calves
        calf.damage = calf.maxDamage /2
    return calves






class ShipEntity extends DestructibleEntity

    constructor : (@type,@faction,pos,a,vel,va) ->
        super pos,a,vel,va

        @setImg A.img.ship["#{@type}#{@faction}"]
        @r = @r_img
        @m = C.shipMass

        @maxDamage = C.shipShields
        @regen = C.shipRegen
        @invincible = 0
        @invincibleMax = C.shipInvincibleDuration

        @drag = C.shipDrag
        @acc = 0                # acceleration
        @thrust = false         # thrusting?

        @canDock = false
        @docking = 0
        @docked = false

    update : (dt) ->
        if @invincible
            @invincible = Math.max 0, @invincible - dt
        if @thrust
            @vel.transPolar @acc,@a
        if @drag
            @vel.scale (1-@drag*dt)
        if @docking
            @docking += dt
            @vel.scale (1-C.shipDockingDrag*dt)
            if @docking > C.shipDockingTime
                @docked = true
        super dt

    applyDamage : (dmg) ->
        if @invincible > 0
            return
        else
            @invincible = @invincibleMax
            super dmg

    beginDocking : ->
        if @canDock
            @docking += 1
        else
            @docking = 0

    stopDocking : ->
        @docking = 0

    # get +1 or -1 * angvel to turn towards pos
    turnTowards : (pos) ->
        if H.wrapAngle(@pos.getFaceAngle(pos) + @a) > 0
            return -1
        else
            return 1





class TransportShipEntity extends ShipEntity

    constructor : (type,faction,pos,a,vel,va,des) ->
        super type,faction,pos,a,vel,va
        @drag = C.transportDrag

        @maxDamage = C.transportShields[faction]
        @regen = C.transportRegen
        @invincibleMax = C.transportInvincibleDuration

        @dockTimer = C.transportDockTime

        @canWarp = false
        @warping = 0
        @warped = false

        @des = des.copyPos()

    update : (dt) ->
        @va = @turnTowards(@des) * C.transportAngVel
        @beginDocking()
        super dt



E.newRandomCivTransport = ->
    names = ["Alpha Octolindis","New Dilgan"]
    name1 = H.getRandomListValue names
    H.pt1.randomInCircle(C.navPtRadius)
    H.pt1.transXY(C.navPtLocations[name1][0],
                  C.navPtLocations[name1][1])

    a = H.randAng()
    v = (C.transportInitialVelocity +
            H.randPlusMinus(C.transportInitialVelocity/2))
    H.pt2.setPolar(v,a)

    # civs always go to the lucky base
    H.pt3.setXY(C.luckyBaseLocation[0],
                C.luckyBaseLocation[1])
    name2 = H.getRandomListValue names
    H.pt4.randomInCircle(C.navPtRadius)
    H.pt4.transXY(C.navPtLocations[name2][0],
                  C.navPtLocations[name2][1]).wrap()

    transport = new TransportShipEntity("drop","civ",H.pt1,a,H.pt2,0,H.pt3)

    transport.setAcc C.transportAcc
    return transport




class PlayerShipEntity extends ShipEntity

    constructor : (type,faction,pos,a,vel,va) ->
        super type,faction,pos,a,vel,va

        @isPlayer = true

        @beamTriggered = 0
        @beamCoolDown = 0
        @beamCoolDownMax = C.beamCoolDown
        @beamEnergy = 0
        @beamEnergyMax = C.beamEnergyMax
        @beamEnergyRegen = C.beamEnergyRegen

        @tarBeam = B.newTargetingBeam(this)
        @tarBeamOn = false

        @tracBeamOn = true
        @tracBeamCoolDown = 0

        @fuel = C.shipFuelMax / 2
        @fuelMax = C.shipFuelMax

    update : (dt) ->
        if @fuel < C.shipFuelMax
            if @beamEnergy
                @beamEnergy = Math.max 0, @beamEnergy - dt * @beamEnergyRegen
                @fuel += dt / 2
        if @beamCoolDown
            @beamCoolDown = Math.max 0, @beamCoolDown - dt
        if @tracBeamCoolDown
            @tracBeamCoolDown = Math.max 0, @tracBeamCoolDown - dt
        super dt

    heal : (dt) ->
        if @damage and @fuel < C.shipFuelMax
            @damage = Math.max 0, @damage - @regen * dt
            @fuel += dt * 2

    draw : (ctx) ->
        if @tarBeamOn
            @tarBeam.update(this)
            @tarBeam.draw ctx
        super ctx

    kill : ->
        @beamEnergy = @beamEnergyMax
        @damage = @maxDamage
        @fuel = @fuelMax
        @beamCoolDown = C.beamCoolDown
        @tracBeamCoolDown = C.tracBeamCoolDown
        super()

    canTractor :  ->
        not @tracBeamCoolDown and @beamEnergy < @beamEnergyMax

    tractorRange : (obj) ->
        for pt in obj.clones
            if @pos.collide pt, C.tracBeamRange
                return pt
        return false

    setJustTractored : (obj) ->
        @tracBeamCoolDown = C.tracBeamCoolDown
        @beamEnergy += 1

    activateTarBeam : ->
        @tarBeam.update(this)
        @tarBeamOn = true

    activateBeam : ->
        if @beamTriggered
            @beamTriggered = 0
        else
            @beamTriggered = C.beamBurstCount

    canFire : ->
        not @beamCoolDown and @beamEnergy < @beamEnergyMax

    setJustFired : ->
        @beamCoolDown = @beamCoolDownMax
        @beamEnergy += 1
        if @beamTriggered
            @beamTriggered -= 1

    refuel : (amount = 0) ->
        if amount
            @fuel = Math.max 0, @fuel - amount
        else
            @fuel = 0

    recharge : (amount = 0) ->
        if amount
            @beamEnergy = Math.max 0, @beamEnergy - amount
        else
            @beamEnergy = 0

    repair : (amount = 0) ->
        if amount
            @damage = Math.max 0, @damage - amount
        else
            @damage = 0

    restoreFull : ->
        @refuel()
        @recharge()
        @repair()

    log : ->
        console.log @pos

E.PlayerShip = ->
    playerShip = new PlayerShipEntity("ray","civ",
            H.pt1.setXY( -C.tileSize/4+50 ,  C.tileSize/4+50), H.HALFPI,
            H.pt2.setXY(0,C.shipInitialVeloctity), 0)
    return playerShip
