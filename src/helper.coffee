

"""
Some useful functions and constants
"""

# expose properties for other modules by adding them to H
H = {}
_first.offer('helper',H)

# request any modules here
# none

# some values
H.PI = Math.PI
H.TWOPI = H.PI * 2
H.HALFPI = H.PI / 2



# geometry functions
# find the distance between two 2D positions: pos = {x:num,y:num}
H.distance = (pos1,pos2) ->
	dx = pos2.x - pos1.x
	dy = pos2.y - pos1.y
	return sqrt(dx*dx + dy*dy)

# determine if two circles are intersecting: cir = {x:num,y:num,r:num}
H.collide = (cir1,cir2) ->
	dx = cir2.x - cir1.x
	dy = cir2.y - cir1.y
	dr = cir2.r + cir1.r
	return dx*dx + dy*dy <= dr*dr

# get unit vector pointing along the angle: ang = radians
H.getVec = (ang) ->
	{x: Math.cos ang, y: Math.sin ang}

# get the angle (radians) bt x-axis and a vector: vec = {x:num,y:num}
H.getAng = (vec) ->
	Math.atan vec.y, vec.x     

# get the angle (radians) obj1 should turn to to face obj2: obj = {x:num,y:num}
H.faceAng = (obj1,obj2) ->
	Math.atan (obj2.y - obj1.y), (obj2.x - obj1.x)	



# some array functions
# remove an item from an array
H.remove = (list,item) ->
	i = list.indexOf item
	if i != -1 
		list.splice(i,1)

# return a reversed array (no side effects)
H.flipList = (list) ->
	l = []
	for item in list
		l.push item
	return l.reverse()


# some dom functions
H.createCanvas = ->
	document.createElement("canvas")



