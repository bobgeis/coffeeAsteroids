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
C.tileSize = 10000
C.tileDensity = 15	# stars per 100px100px sq
C.tileCount = Math.floor(C.tileDensity/10000*C.tileSize*C.tileSize)

# player ship attributes?
