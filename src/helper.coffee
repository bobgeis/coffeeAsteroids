
"""
Helper

Some useful functions and constants

class Point
    This is a point class, {x,y}, with lots of methods.
    Many of the methods modify the point they are called on,
    this was intended as an exercise in avoiding the creation
    of new objects.  In principle this would reduce the frequency
    of frame rate hits caused by garbage collection, but it
    is unlikely to have a major impact on a game as simple as
    this one, so it's mostly just an exercise.

class Line
    This is a class for line segments.

"""

# expose properties for other modules by adding them to H
H = {}
_first.offer('helper',H)

# request any modules here
C = _first.request('config')

# some values
H.PI = PI = Math.PI
H.TWOPI = TWOPI = H.PI * 2
H.TAU = TAU = H.TWOPI
H.HALFPI = HALFPI = H.PI / 2


# random functions

# get a random int bt 0 and max
H.randInt = (max) ->
    Math.floor(Math.random()*max)

# random int in a range
H.randIntRange = (min,max) ->
    min + Math.floor(Math.random()*(max - min))

# get a randm angle bt 0 and 2pi
H.randAng = (a = TAU) ->
    Math.random() * a

# get a random number within +/- x
H.randPlusMinus = (x) ->
    Math.random()*2*x - x


# some array functions

# clear an array without creating garbage
H.clear = (list) ->
    list.length = 0

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
    return list[H.randInt(list.length)]


# some object functions

# get a random value from an object
H.getRandomObjValue = (obj) ->
    return obj[H.getRandomListValue(Object.keys(obj))]




# 2D vector, point, or position class
class Point
    # we only have x and y fields
    constructor : (@x,@y) -> this

    # copy the vector
    copyPos : ->
        new Point(@x,@y)

    # set the vector
    # use this instead of assignment to avoid garbage
    setPos : (pos) ->
        @x = pos.x
        @y = pos.y
        this

    setPosOffset : (pos,x,y) ->
        @x = pos.x + x
        @y = pos.y + y
        this

    # list setPos but assumes a list arg: [x,y]
    setList : (list) ->
        @x = list[0]
        @y = list[1]
        this

    # add
    add : (pos) ->
        @x += pos.x
        @y += pos.y
        this

    # subtract
    sub : (pos) ->
        @x -= pos.x
        @y -= pos.y
        this

    # scale
    scale : (scalar) ->
        @x *= scalar
        @y *= scalar
        this

    # flip +/- signs
    flip : ->
        @x = -@x
        @y = -@y
        this

    # dot product
    dot : (pos) ->
        @x * pos.x + @y * pos.y

    # cross product (magnitude of)
    cross : (pos) ->
        @x * pos.y - @y * pos.x

    # set to the sum bt 2 vectors
    sum : (pos1,pos2) ->
        @x = pos2.x + pos1.x
        @y = pos2.y + pos1.y
        this

    # set to the difference bt 2 vectors
    diff : (pos1,pos2) ->
        @x = pos2.x - pos1.x
        @y = pos2.y - pos1.y
        this

    # set x,y by arguments
    setXY : (x,y) ->
        @x = x
        @y = y
        this

    # translate by x & y
    transXY : (x,y) ->
        @x += x
        @y += y
        this

    # set via polar coords
    setPolar : (r,a) ->
        @x = r * Math.cos a
        @y = r * Math.sin a
        this

    # translate by polar coords
    transPolar : (r,a) ->
        @x += r * Math.cos a
        @y += r * Math.sin a
        this

    # get magnitude (r)
    r : ->
        Math.hypot @x,@y

    # get angle
    a : ->
        Math.atan2 @y,@x

    # set the magnitude (r)
    setR : (r) ->
        @setPolar r,@a()

    # set the angle
    setA : (a) ->
        @setPolar @r(),a

    # set to unit vector along an angle
    unitVector : (a) ->
        @setPolar 1,a

    # rotate by an angle
    rotate : (a) ->
        @setA(a + @a())

    # calc distance
    distance : (pos) ->
        Math.hypot pos.x - @x, pos.y - @y

    # T/F: is the point w/in r of this?
    collide : (pos,r) ->
        dx = pos.x - @x
        dy = pos.y - @y
        dx*dx + dy*dy <= r*r

    # get angle to face pos
    getFaceAngle : (pos) ->
        Math.atan2 (pos.y - @y), (pos.x - @x)

    # T/F: is the point w/in the box? m = min, M = MAX
    inBox : (xm,xM,ym,yM) ->
        # console.log "x: #{xm} #{xM}"
        # console.log "y: #{ym} #{yM}"
        @x < xM and @x > xm and @y < yM and @y > ym

    # move to a random position bt (0,0) and (xMax,yMax)
    random : (xMax,yMax) ->
        @x = H.randInt xMax
        @y = H.randInt yMax
        this

    # move to a random position w/in a box
    randomInBox : (xm,xM,ym,yM) ->
        @x = H.randIntRange xm,xM
        @y = H.randIntRange ym,yM
        this

    # move to a random pos w/in rM distance
    randomInCircle : (rM) ->
        @setPolar(Math.random()*rM,H.randAng(TAU))

    # move to a random point *on* the circle
    randomOnCircle : (r) ->
        @setPolar r, H.randAng(TAU)

# export Point
H.Point = Point

# alternate Point constructors
# construct a point from polar coordinates
H.newPointPolar = (r,a) ->
    new Point( r * Math.cos a, r * Math.sin a )

# used to get a point which will be set later
H.newPt = -> new Point(0,0)

# these helper points should be used wherever generic Points are needed
H.pt = pt = new Point(0,0)
H.pt0 = pt0 = new Point(0,0)
H.pt1 = pt1 = new Point(0,0)
H.pt2 = pt2 = new Point(0,0)
H.pt3 = pt3 = new Point(0,0)
H.pt4 = pt4 = new Point(0,0)
H.pt5 = pt5 = new Point(0,0)
H.pt6 = pt6 = new Point(0,0)
H.pt7 = pt7 = new Point(0,0)
H.pt8 = pt8 = new Point(0,0)
H.pt9 = pt9 = new Point(0,0)
H.origin = new Point(0,0)
# they represent a sort of knockoff object pool

# move a Point randomly within r of its current position
H.blink = (pos,r) ->
    pt1.randomOnCircle r
    pos.add pt1



# a class that represents a line segment
class Line

    constructor : (start,stop) ->
        @start = start.copyPos()
        @stop = stop.copyPos()

        @updateLA()

    # update length and angle from the start and stop
    updateLA : ->
        @updateL()
        @updateA()

    updateL : -> @l = @start.distance @stop
    updateA : -> @a = @start.getFaceAngle @stop

    setLine : (start,stop) ->
        @start.setPos start
        @stop.setPos stop
        @updateLA()
        this

    setLineRA : (start,r,a) ->
        @start.setPos start
        @stop.setPolar(r,a).add(start)
        this

    setLineOffset : (start,stop,x,y) ->
        @start.setPosOffset start, x, y
        @stop.setPosOffset stop, x, y
        @updateLA()
        this

    setLineFromLine : (line) ->
        @start.setPos line.start
        @stop.setPos line.stop
        @updateLA()
        this

    setLineFromLineOffset : (line,x,y) ->
        @start.setPosOffset line.start, x, y
        @stop.setPosOffset line.stop, x, y
        @updateLA()
        this

    # get length of altitude bt line and pt
    distance : (pos) ->
        pt1.diff @start, @stop
        pt2.diff @start, pos
        Math.abs ((pt1.cross pt2)/@l)

    # T/F: does an altitude bt line and pt fall in the segment?
    inSegment : (pos) ->
        pt1.diff @start, @stop
        pt2.diff @start, pos
        proj = (pt1.dot pt2) / @l
        # if the projection is negative, then the altitude falls before @start
        if proj < 0
            return false
        # if the projection is greater than @l, then the altitude falls after @stop
        if proj > @l
            return false
        # else the altitude falls w/in the segment
        else
            return true

    # T/F: is the pos w/in r of the line? remember to check endpoints too
    hit : (pos,r) ->
        if @inSegment pos
            d = @distance pos
            # console.log "#{d} <? #{r}"
            return d < r
        else if @start.collide pos,r
            return true
        else if @stop.collide pos,r
            return true
        else
            return false

    # draw the line onto a canvas using stroke
    draw : (ctx,width,color,offset) ->
        ctx.lineWidth = width
        ctx.strokeStyle = color
        ctx.beginPath()
        if offset
            dx = offset.x
            dy = offset.y
        else
            dx = 0
            dy = 0
        ctx.moveTo @start.x-dx, @start.y-dy
        ctx.lineTo @stop.x-dx, @stop.y-dy
        ctx.stroke()
        ctx.closePath()


#  Line constructors
# from start and stop directly
H.newLineSS = (start,stop) ->
    new Line(start,stop)
# construct a line from a start point, and a length and angle
H.newLineRA = (start,r,a) ->
    new Line(start,pt.setPolar(r,a).add(start))

# just get a new line where we don't care about the initial positions
H.newLine = -> new Line(H.origin,H.origin)

# make a line facing out from an object
H.updateLineFromPos = (line,pos,r,a) ->
    line.start.setPos pos
    line.start.setPolar(r,a).add(line.start)
    line.l = r
    line.a = a

# this is a helper line, similar to pt,pt1,pt2,pt3 above
H.line = line = new Line(pt1,pt2)

# the cam Point represents the camera in the game world
H.cam = cam = new Point(0,0)
H.camTL = camTL = new Point(0,0)
H.camBR = camBR = new Point(0,0)


# update the camera position
H.updateCamera = (pos) ->
    cam.setPos pos
    camTL.setXY (pos.x - C.halfWinWid),(pos.y - C.halfWinHei)
    camBR.setXY (pos.x + C.halfWinWid),(pos.y + C.halfWinHei)

# T/F: is this Point on screen? (assuming the camera point is updated)
H.onScreen = (pos) ->
    pos.inBox camTL.x, camBR.x, camTL.y, camBR.y

H.onScreenEntity = (pos,r) ->
    pos.inBox camTL.x-r, camBR.x+r, camTL.y-r, camBR.y+r

H.onScreenBeam = (line) ->
    H.onScreen line.start or H.onScreen line.stop

# some canvas functions

# get a new canvas
H.createCanvas = ->
    document.createElement("canvas")


# drawing functions

# draw one ctx.canvas onto another at some pos and angle
H.drawImg = (ctx,top,x,y,a) ->
    img = top.canvas
    if a
        ctx.save()
        ctx.translate x,y
        ctx.rotate -a
        ctx.drawImage img, -Math.floor(img.width/2), -Math.floor(img.height/2)
        ctx.restore()
    else
        ctx.drawImage img, x-Math.floor(img.width/2), y-Math.floor(img.height/2)

# draw one ctx.canvas onto another at some pos and angle
H.drawImgRot = (ctx,top,x,y,a) ->
    ctx.save()
    img = top.canvas
    ctx.translate x,y
    ctx.rotate -a
    ctx.drawImage img, -Math.floor(img.width/2), -Math.floor(img.height/2)
    ctx.restore()

# draw image without rotation
H.drawImgStill = (ctx,top,x,y) ->
    img = top.canvas
    ctx.drawImage img, x-Math.floor(img.width/2), y-Math.floor(img.height/2)

# draw an entity onto the game screen, this requires calculating offset from the camera
H.drawEntity = (ctx,top,pos,a) ->
    dx = pos.x - camTL.x
    dy = pos.y - camTL.y
    H.drawImg ctx, top, dx, dy, a

H.drawLineEntity = (ctx,line,wid,color) ->
    line.draw ctx, wid, color, camTL



# clone points are used to create the 9 tiles

makeClones = ->
    row = -> [
                new Point(0,0)
                new Point(0,0)
                new Point(0,0)
            ]
    return [row(),row(),row()]

H.clones = makeClones()

H.setClones = (pos) ->
    s = C.tileSize
    x = pos.x
    y = pos.y
    d = (i) ->
        if i == 0
            -s
        else if i == 1
            0
        else
            s
    for row,i in H.clones
        for pt,j in row
            pt.setXY x+d(i),y+d(j)
    return H.clones

H.cloneCollide = (pos1, pos2, r) ->
    for row in H.setClones pos1
        for clone in row
            if clone.collide pos2,r
                return clone
    return false

testHelperOn = false
if testHelperOn
    # test of new Points vs object "pool"
    t1 = Date.now()
    testCount = 0
    while testCount < 100000000
        testCount++
        new Point(0,0)
    t2 = Date.now()
    testCount = 0
    while testCount < 100000000
        testCount++
        H.pt.setXY 0,0
    t3 = Date.now()
    console.log "new objs: #{t2-t1}"
    console.log "reuse objs: #{t3-t2}"
    # chrome
    # 1804ms for 100000000 new objs
    # 149ms for 100000000 reused objs
