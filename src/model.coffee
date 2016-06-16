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
    rocks : []
    booms : []
    shots : []
    loot : []
    constructor : ->
        "Build the initial state."
        @entitiesSuperList = [
            @bg
            @bases
            @loot
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
        # collisions etc
        # maybe spawn rock
        if E.spawnRock(dt)
            @rocks.push new E.RandRock()
            console.log "#{@rocks.length}"
        # cull

    draw : (ctx) ->
        "Draw the model."
        # update camera
        @player.centerCamera()
        # draw entities in order
        for list in @entitiesSuperList
            for item in list
                item.draw(ctx)
        # draw hud

    command : (cmd) ->
        if cmd == 1
            @player.va = C.shipAngVel
        else if cmd == 2
            @player.va = -C.shipAngVel
        else if cmd == 3
            @player.setAcc C.shipAcc
        else if cmd == 11
            @player.va = 0
        else if cmd == 13
            @player.setAcc 0

M.Model = Model











