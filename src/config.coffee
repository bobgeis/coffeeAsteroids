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
C.tileSize = 1600
C.tileDensity = 15	# stars per 100px100px sq
C.tileCount = Math.floor(C.tileDensity/10000*C.tileSize*C.tileSize)

# starbase attributes
C.baseMass = 10000

# player ship attributes
C.shipAcc = 5       /1000       # px/s/s
C.shipAngVel = 2    /1000       # rad/s
C.shipDrag = .1     /1000       #
C.shipMass = 10                 # mass in arbitrary units

# rock attributes
C.rockAngVel = 2    /1000   # rad/s
C.rockVel = 100       /1000      # px/s
C.rockRad = 30          # px
C.rockSpawnChance = 3          /1000       # spawn chance /s
C.rockMass = 100