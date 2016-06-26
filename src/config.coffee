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
C.baseAngVel = 0.1/1000           # rad/ms

# player ship attributes
C.shipAcc = 5/1000              # px/ms/ms
C.shipRetro = C.shipAcc/3       # px/ms/ms
C.shipAngVel = 2/1000           # rad/ms
C.shipDrag = 0.4/1000           # fraction reduced /ms
C.shipMass = 10                 # arbitrary mass units
C.shipShields = 15              # arbitrary damage units
C.shipRegen = 3/1000            # dmg/ms
C.shipBeamCoolDown = 1 * 1000
C.shipInvincibleDuration = 300 # ms  minimum time bt taking damage for ships

# disruptor beam attributes
C.beamDamage = 1                #
C.beamRange = 500               # px
C.beamDuration = 110            # ms
C.beamScatter = 8/100           # radians
C.beamCoolDown = 110            # ms
C.beamBurstCount = 5            # number of times to fire in a row
C.beamEnergyMax = 15            # shots
C.beamEnergyRegen = 2.5/1000    # shots/ms
C.beamColors = [
        "rgba(100, 255, 255, 1)"
        "rgba(  0, 225, 255, 1)"
        "rgba( 25, 175, 200, 1)"
        "rgba( 25, 125, 175, 1)"
        "rgba( 25, 100, 100, 1)"
        "rgba(  0,  50,  50, 1)"
    ]
C.beamWidths = [                # px
        4
        3
        2
        1
        1
        1
    ]

# targeting beam attributes
C.tarBeamWidth = 2
C.tarBeamRange = 500
C.tarBeamColor = "rgba(250,100,100,0.5)"

# tractor beam attributes
C.tracBeamRange = 150
C.tracBeamCoolDown = 500
C.tracBeamDuration = 300
C.tracBeamWidths = [3,4,3,2,2,1]
C.tracBeamColors =
    [
        "rgba(255, 255, 255, 1.0)"
        "rgba(225, 225, 100, 1.0)"
        "rgba(175, 175,  50, 0.8)"
        "rgba(125, 125,  25, 0.6)"
        "rgba( 75,  75,  10, 0.4)"
        "rgba( 25,  25,   0, 0.3)"
    ]
C.tracPulseInitialRadius = 10   # px
C.tracPulseGrowthRate = 5      # px/frame

# rock attributes
C.rockCollisionDamage = 5       # dmg per velocity
C.rockAngVel = 2/1000           # rad/ms
C.rockVel = 200/1000            # px/ms
C.rockRad = 30                  # px
C.rockRadii = [12,15,20,26,36]    # radii in px from smallest to largest
C.rockMasses = [5,10,20,40,100]
C.rockSpawnChance = 3/1000      # spawn chance /ms
C.rockMass = 25                # mass
C.rockArmor = 5                 # dmg
C.rockRegen = 1/100             # dmg/ms
C.rockMaxDamage =
    {
        C : [1.0, 1.0, 1.0, 1.5, 2.0]
        S : [1.0, 1.5, 2.0, 2.5, 3.0]
        M : [2.0, 2.5, 3.0, 3.5, 4.0]
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



C.crystalChance =           # probability that a booming rock leaves a crystal
    {
        C: 0.1
        S: 0.3
        M: 0.5
    }
C.crystalMaxAge = 60*1000   # ms
C.crystalSpin = 4/1000      # rad/ms

C.lifepodMaxAge = 60*1000   # ms
C.lifepodVel = 100/1000      # px/ms
C.lifepodSpin = 4/1000      # rad/ms

