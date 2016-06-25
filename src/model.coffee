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



class Model
    player : null
    gameOver : false
    bg : []
    bases : []
    ships : []
    boats : []
    rocks : []
    booms : []
    flashes : []
    shots : []
    loot : []
    constructor : ->
        "Build the initial state."
        @player = E.PlayerShip()
        @ships.push @player
        @flash @player
        @rocks.push new E.RandRock()
        @bases.push new E.LuckyBase()
        @bases.push new E.BuildBase()
        @bg.push new E.BgTile()

    getEntityLists : ->
        # get a list of all the entity lists
        # in the order that they should be drawn
        [
            @bg
            @bases
            @loot
            @boats
            @shots
            @rocks
            @ships
            @booms
            @flashes
        ]

    update: (dt) ->
        "update by dt"
        # update
        for list in @getEntityLists()
            for item in list
                item.update(dt)
        # collisions
        # ships with rocks
        for ship in @ships
            for rock in @rocks
                if ship.collide rock
                    ship.bounce rock
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
        # maybe spawn rock
        if E.spawnRock(dt)
            rock = new E.RandRock()
            @rocks.push rock
            @flash rock
        # cull
        @shots = _.filter @shots, isAlive
        @rocks = _.filter @rocks, isAlive
        @ships = _.filter @ships, isAlive
        @booms = _.filter @booms, isAlive
        @flashes = _.filter @flashes, isAlive
        if not @player.alive
            @gameOver = true

    draw : (ctx) ->
        "Draw the model."
        # update camera
        @player.centerCamera()
        # draw entities in order
        for list in @getEntityLists()
            for entity in list
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
            @fireDisruptor @player
        else if cmd == 11
            @player.va = 0
        else if cmd == 13
            @player.setAcc 0
        else if cmd == 99
            @player.kill()
            @explode @player

    fireDisruptor : (ship) ->
        # attempt to fire disruptor
        # if ship.canFire()
        if true
            @shots.push B.newDisruptor ship

    calveRock : (rock) ->
        # attempt to calve a rock
        calves = E.calveRock rock
        if calves
            for calf in calves
                @rocks.push calf

    explode : (obj) ->
        # create an explosion w obj's pos & vel
        @booms.push E.newExplosionOnObj obj

    flash : (obj) ->
        # create a flash w obj's pos & vel
        @flashes.push E.newFlashOnObj obj

M.Model = Model

# this is a function because i don't know how to make predicates from method calls
isAlive = (obj) -> obj.alive








