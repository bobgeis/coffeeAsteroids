

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

H.randInt = (max) ->
	return Math.floor(Math.random()*max)

# get a random position bt x:0-max and y:0-max
H.getRandomPos = (xMax,yMax) ->
	pos = {}
	pos.x = Math.floor(Math.random() * xMax) 
	pos.y = Math.floor(Math.random() * yMax) 
	return pos



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

# get a random value from a list
H.getRandomListValue = (list) ->
	return list[Math.floor(Math.random()*list.length)]

# some object functions
# get a random value from an object
H.getRandomObjValue = (obj) ->
	return obj[H.getRandomListValue(Object.keys(obj))]


# some canvas functions
# get a new canvas
H.createCanvas = ->
	document.createElement("canvas")

# draw one ctx.canvas onto another at some pos and angle
H.drawImg = (bot,top,x,y,a) ->
	bot.save()
	img = top.canvas
	bot.translate x,y
	# bot.translate img.width/2,img.height/2
	bot.rotate -a
	# bot.drawImage img, 0, 0
	bot.drawImage img, -Math.floor(img.width/2), -Math.floor(img.height/2)
	bot.restore()

	








