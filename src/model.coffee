"""
Model
"""


# offering
M = {}
_first.offer('model',M)

# requesting
A = _first.request('assets')
C = _first.request('config')
E = _first.request('entity')
H = _first.request('helper')



class Model
    player : null
    bg : []
    bases : []
    ships : []
    boats : []
    rocks : []
    booms : []
    shots : []
    loot : []
    constructor : ->
        "Build the initial state."
        # they will be drawn in this order
        @entitiesSuperList = [
            @bg
            @bases
            @loot
            @boats
            @shots
            @rocks
            @ships
            @booms
            ]
        @player = E.PlayerShip()
        @ships.push @player
        @rocks.push new E.RandRock()
        @bases.push new E.LuckyBase()
        @bases.push new E.BuildBase()
        @bg.push new E.BgTile()

    update: (dt) ->
        "update by dt"
        # update
        for list in @entitiesSuperList
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
        # maybe spawn rock
        if E.spawnRock(dt)
            @rocks.push new E.RandRock()
            # console.log "#{@rocks.length}"
        # cull

    draw : (ctx) ->
        "Draw the model."
        # update camera
        @player.centerCamera()
        # draw entities in order
        for list in @entitiesSuperList
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
        else if cmd == 11
            @player.va = 0
        else if cmd == 13
            @player.setAcc 0

M.Model = Model











