"""
Config

Configuration values
"""

C = {}
_first.offer('config',C)

# time step & panic
C.timeStep = 1000/60.0 		# 60 fps
C.timePanic = 1000*60.0 	# panic -> dump time in excess of 60s

# size of game screen
C.winWid = 800
C.winHei = 650
C.halfWinWid = C.winWid/2
C.halfWinHei = C.winHei/2

# bg star field
C.tileSize = 2000
C.tileDensity = 15	# stars per 100px100px sq
C.tileCount = Math.floor(C.tileDensity*C.tileSize*C.tileSize/10000)
C.spectralTypes = [
        'A'
        'B'
        'F'
        'K'
        'M'
        'O'
    ]

# starbase attributes
C.baseMass = 10000

# player ship attributes
C.shipAcc = 5       /1000       # px/s/s
C.shipRetro = C.shipAcc/3
C.shipAngVel = 2    /1000       # rad/s
C.shipDrag = .1     /1000       #
C.shipMass = 10                 # mass in arbitrary units
C.shipShields = 10
C.shipRegen = 0.5    /1000
C.shipBeamCoolDown = 1 * 1000

# disruptor beam attributes
C.beamDamage = 1                #
C.beamRange = 500               # px
C.beamDuration = 180            # ms
C.beamColors = [
        "rgba(100, 255, 255, 1)"
        "rgba(  0, 225, 255, 1)"
        "rgba( 25, 175, 175, 1)"
        "rgba( 50, 125, 125, 1)"
        "rgba( 25,  50,  50, 1)"
        "rgba(  0,   0,   0, 0)"
    ]
C.beamWidths = [                # px
        4
        3
        2
        1
        1
        0
    ]

# rock attributes
C.rockAngVel = 2/1000           # rad/ms
C.rockVel = 100/1000            # px/ms
C.rockRad = 30                  # px
C.rockRadii = [10,15,19,29,40]    # radii in px from smallest to largest
C.rockSpawnChance = 3/1000      # spawn chance /ms
C.rockMass = 100                # mass
C.rockArmor = 5                 # dmg
C.rockRegen = 1/100             # dmg/ms
C.rockMaxDamage =
    {
        C : [1.0,1.0,1.5,1.5,2.0]
        S : [1.0,1.5,1.5,2.0,2.5]
        M : [1.5,1.5,2.0,2.5,3.0]
    }
C.rockBaseColors =
    {
        C:[[125,125,125],[100, 80, 70]]
        S:[[120, 120, 0],[130, 69, 19]]
        M:[[ 90, 90, 90],[115, 65, 14]]
    }
C.rockBoomColors =
    {
        C:[[255,100,100],[255,125,100]]
        S:[[240,150,100],[255,100,100]]
        M:[[240,100,100],[255,125,100]]
    }
C.rockColor = (ratio,type,side) ->
    base = C.rockBaseColors[type][side]
    boom = C.rockBoomColors[type][side]
    colors =[]
    for i in [0...3]
        colors.push Math.floor((boom[i] - base[i])*ratio + base[i])
    return "rgba(#{colors[0]},#{colors[1]},#{colors[2]},1"

# boom (explosion) attributes
C.boomMaxAge = 250              # ms
C.boomGrowthRate = 180/1000     # px/ms
C.boomInitialRadius = 25        # px

boomColors = {
    inner : [
        [235,255,255]
        [245,255,255]
        [255,255,255]
        [255,245,245]
        [255,225,225]
        [245,200,200]
        [235,160,160]
        [225,120,120]
        [200, 75, 75]
        [150, 25, 25]
    ]
    outer : [
        [235,255,255]
        [245,255,225]
        [255,255,200]
        [255,245,175]
        [255,225,150]
        [245,200,125]
        [235,150, 75]
        [225,100, 50]
        [200, 25, 25]
        [150,  0,  0]
    ]
}

C.boomInnerColor = (ratio) ->
    list = boomColors.inner
    colors = list[Math.floor(ratio * list.length)]
    return "rgba(#{colors[0]},#{colors[1]},#{colors[2]},#{1-ratio/2}"

C.boomOuterColor = (ratio) ->
    list = boomColors.outer
    colors = list[Math.floor(ratio * list.length)]
    return "rgba(#{colors[0]},#{colors[1]},#{colors[2]},#{1-ratio/2}"


# flash (FTL jump ghosts) attributes
C.flashMaxAge = 300             # ms
C.flashShrinkRate = 100/1000     # px/ms
C.flashInitialRadius = 40       # px

flashColors = {
    inner: [
        [255,255,255]
        [255,255,255]
        [225,255,255]
        [200,255,255]
        [150,255,255]
        [125,225,255]
        [100,200,225]
        [ 90,150,200]
        [ 75,100,150]
        [ 50, 75,125]
    ]
    outer: [
        [255,255,255]
        [255,255,255]
        [225,255,255]
        [200,255,255]
        [150,255,255]
        [125,225,255]
        [100,200,225]
        [ 90,150,200]
        [ 75,100,150]
        [ 50, 75,125]
    ]
}

C.flashInnerColor = (ratio) ->
    list = flashColors.inner
    colors = list[Math.floor(ratio * list.length)]
    return "rgba(#{colors[0]},#{colors[1]},#{colors[2]},#{1-ratio}"

C.flashOuterColor = (ratio) ->
    list = flashColors.outer
    colors = list[Math.floor(ratio * list.length)]
    return "rgba(#{colors[0]},#{colors[1]},#{colors[2]},#{1-ratio}"
