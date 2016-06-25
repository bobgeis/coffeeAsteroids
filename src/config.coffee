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
C.tileCount = Math.floor(C.tileDensity/10000*C.tileSize*C.tileSize)

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
C.beamDamage = 1
C.beamRange = 500
C.beamDuration = 150
C.beamColors = [
        "rgba(100, 255, 255, 1)"
        "rgba(  0, 225, 255, 1)"
        "rgba( 25, 175, 175, 1)"
        "rgba( 50, 125, 125, 1)"
        "rgba( 25,  50,  50, 1)"
        "rgba(  0,   0,   0, 0)"
    ]
C.beamWidths = [
        4
        3
        2
        1
        1
        0
    ]

# rock attributes
C.rockAngVel = 2    /1000   # rad/s
C.rockVel = 100       /1000      # px/s
C.rockRad = 30          # px
C.rockSpawnChance = 3          /1000       # spawn chance /s
C.rockMass = 100
C.rockArmor = 1
C.rockRegen = 0