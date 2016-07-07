"""
Model
"""


# offering
M = {}
_first.offer('model',M)

# requesting
A = _first.request('assets')
B = _first.request('beam')
C = _first.request('config')
E = _first.request('entity')
H = _first.request('helper')
Q = _first.request('quest')
U = _first.request('hud')



class Model


    constructor : ->
        "Build the initial state."

        @player = null
        @gameOver = false
        @spawnTimer = 0
        @changeMode = 0
        @quest = []

        @bg = []
        @bases = []
        @ships = []
        @boats = []
        @rocks = []
        @booms = []
        @flashes = []
        @shots = []
        @loot = []
        @hud = []
        @navPts = []
        @mousePts = []

        @player = E.PlayerShip()
        @ships.push @player
        @flash @player
        @rocks.push new E.RandRock()
        @bases.push new E.LuckyBase()
        @bases.push new E.BuildBase()
        @bg.push new E.BgTile()
        @hud.push new U.shipShieldBar @player
        @hud.push new U.shipBeamEnergyBar @player
        @hud.push new U.shipFuelBar @player
        @hud.push new U.dockMessage @player
        for name in C.navPtNames
            @navPts.push E.newNavPt(name)
        for name in C.mousePtNames
            @navPts.push E.newNavPt(name)
            @rocks.push E.RockFromNavName(name)
            @rocks.push E.RockFromNavName(name)
        @cargo =
            {
                ship : [0,0,0]
                crystal :   [0,0,0]
                lifepod :   [0,0,0]
                mousepod :  [0,0,0]
            }
        @hud.push new U.newCargoMonitor @cargo

    getEntityLists : ->
        # get a list of all the entity lists
        # in the order that they should be drawn
        [
            @bg
            @bases
            @navPts
            @mousePts
            @loot
            @boats
            @shots
            @rocks
            @ships
            @booms
            @flashes
            @hud
        ]

    clearEntityLists : ->
        for list in @getEntityLists
            list.length = 0

    update: (dt) ->
        "update by dt"
        # update
        for list in @getEntityLists()
            for item in list
                item.update(dt)
        # collisions
        # ships with loot
        # ships with rocks
        # ships with bases
        for ship in @ships
            if ship.beamTriggered and ship.canFire()
                @fireDisruptor ship
                ship.setJustFired()
            if ship.tracBeamOn
                for loot in @loot
                    if ship.canTractor()
                        pt = ship.tractorRange loot
                        if pt
                            @tracBeam ship.pos, pt
                            loot.kill()
                            ship.setJustTractored loot
                            @pickupLoot loot
            for rock in @rocks
                if ship.collide rock
                    dmg = Math.abs(ship.bounce rock)
                    if ship.applyDamage(dmg * C.rockCollisionDamage)
                        @explode ship
                        ship.kill()
                        @createLifepods ship
            if ship.warped
                @shipWarped ship
            for nav in @navPts
                if ship.collide nav
                    ship.canWarp = true
                    if ship.warped
                        if ship.isPlayer
                            @playerWarped nav
                        else
                            @shipWarped ship, nav
            ship.canDock = false
            for base in @bases
                if ship.collide base
                    ship.canDock = true
                    if ship.docked
                        if ship.isPlayer
                            @playerDocked base
                        else
                            @shipDocked ship, base
        # rocks with bases
        for base in @bases
            for rock in @rocks
                if base.collide rock
                    rock.bounce base
        # rocks with shots
        for shot in @shots
            if shot.damaging
                for rock in @rocks
                    if shot.hit rock
                        if rock.applyDamage shot.getDamage()
                            rock.kill()
                            @explode rock
                            @calveRock rock
                            @createCrystal rock
        # maybe spawn at nav points
        @maybeTimerSpawn()
        # cull
        @shots = _.filter @shots, isAlive
        @rocks = _.filter @rocks, isAlive
        @ships = _.filter @ships, isAlive
        @booms = _.filter @booms, isAlive
        @loot = _.filter @loot, isAlive
        @flashes = _.filter @flashes, isAlive
        @cargo.ship[0] = @ships.length - 1
        # maybe end game
        if not @player.alive
            @gameOver = true
            @changeMode = 1

    draw : (ctx) ->
        "Draw the model."
        # update camera
        @player.centerCamera()
        # draw entities in order
        for list in @getEntityLists()
            for entity in list
                if not entity.draw
                    console.log entity
                entity.draw(ctx)
        # draw hud

    command : (cmd) ->
        if cmd == 1
            @player.va = C.shipAngVel
        else if cmd == 2
            @player.va = -C.shipAngVel
        else if cmd == 3
            @player.setAcc C.shipAcc
        else if cmd == 4
            @player.setAcc -C.shipRetro
        else if cmd == 5
            @player.activateBeam()
            @player.tarBeamOn = false
        else if cmd == 6
            @player.activateTarBeam()
        else if cmd == 7
            @player.beginDocking()
        else if cmd == 11
            @player.va = 0
        else if cmd == 13
            @player.setAcc 0
        else if cmd == 17
            @player.stopDocking()
        # commands intended for debugging
        else if cmd == 97
            @player.restoreFull()
        else if cmd == 98
            @log()
        else if cmd == 99
            @player.kill()
            @explode @player
            @createLifepods @player

    fireDisruptor : (ship) ->
        @shots.push B.newDisruptor ship

    calveRock : (rock) ->
        # attempt to calve a rock
        calves = E.calveRock rock
        if calves
            for calf in calves
                @rocks.push calf

    createCrystal : (rock) ->
        if E.spawnCrystalCheck rock
            @loot.push E.newCrystalOnObj rock

    createLifepods : (ship) ->
        for pod in E.newLifepodsOnObj ship
            @loot.push pod

    explode : (obj) ->
        # create an explosion w obj's pos & vel
        @booms.push E.newExplosionOnObj obj

    flash : (obj) =>
        # create a flash w obj's pos & vel
        @flashes.push E.newFlashOnObj obj

    tracPulse : (obj) =>
        @flashes.push E.newTracPulseOnObj obj

    tracBeam : (pos1,pos2) ->
        @flashes.push B.newTractorBeam pos1, pos2


    maybeTimerSpawn : ->
        for name in C.mousePtNames
            if Math.random() < C.navPtSpawnRates[name]
                rock = E.RockFromNavName name
                @rocks.push rock
                @flash rock
        # if @ships.length < 6 and Math.random() < 0.1
        @spawnShips(true)
        @spawnShips(false)



    spawnShips : (inbound) ->
        if inbound
            ephemera = @flash
        else
            ephemera = @tracPulse
        if Math.random() < 0.003
            ship = E.newRandomTransport("civ",inbound)
            ephemera ship
            @ships.push ship
        if Math.random() < 0.003
            ship = E.newRandomTransport("build",inbound)
            ephemera ship
            @ships.push ship
        if Math.random() < 0.003
            ship = E.newRandomTransport("mine",inbound)
            ephemera ship
            @ships.push ship
        if Math.random() < 0.003
            ship = E.newRandomTransport("med",inbound)
            ephemera ship
            @ships.push ship



    pickupLoot : (loot) ->
        type = loot.type
        @cargo[type][0] += 1

    playerDocked : (base) ->
        @player.docked = false
        @player.docking = 0
        @player.refuel()
        @changeMode = 2
        if base.name == "lucky"
            @cargo.lifepod[1] += @cargo.lifepod[0]
            @cargo.lifepod[0] = 0
        else
            @cargo.crystal[1] += @cargo.crystal[0]
            @cargo.crystal[0] = 0
        @quest = Q.getNextQuest(base.name)
        @cargo.mousepod[1] += @cargo.mousepod[0]
        @cargo.mousepod[0] = 0
        @flashes.push E.newTracPulseOnObj @player

    shipDocked : (ship, base) ->
        @flashes.push E.newTracPulseOnObj ship
        ship.kill()
        @cargo.ship[1] += 1
        return

    shipWarped : (ship, nav) ->
        @flash ship
        ship.kill()
        @cargo.ship[1] += 1
        return

    # for debugging
    log : ->
        @player.log()
        console.log @cargo


M.Model = Model

# this is a function because i don't know how to make predicates from method calls
isAlive = (obj) -> obj.alive








