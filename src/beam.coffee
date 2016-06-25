"""
Beam


"""


# offering
B = {}
_first.offer('beam',B)

# requesting
A = _first.request('assets')
C = _first.request('config')
H = _first.request('helper')


# beams are game objects that are line segments, eg: disruptor beams, targeting beams
class Beam

    constructor : (@line) ->
        @alive = true
        @clones = (H.newLine() for i in [0...9])
        @setClones()
        @wid = 0
        @color = "rgba(0, 0, 0, 1)"

    getWidth : ->
        @wid

    getColor : ->
        @color

    isAlive : -> @alive
    kill : -> @alive = false

    update : (dt) ->
        return @alive

    draw : (ctx) ->
        if not @alive then return
        for clone in @clones
            if H.onScreenBeam clone
                H.drawLineEntity ctx, clone, @wid, @color

    setClones : ->
        s = C.tileSize
        start = @line.start
        stop = @line.stop
        @clones[0].setLineOffset start,stop,-s,-s
        @clones[1].setLineOffset start,stop,-s,0
        @clones[2].setLineOffset start,stop,-s,s
        @clones[3].setLineOffset start,stop,0,-s
        @clones[4].setLineOffset start,stop,0,0
        @clones[5].setLineOffset start,stop,0,s
        @clones[6].setLineOffset start,stop,s,-s
        @clones[7].setLineOffset start,stop,s,0
        @clones[8].setLineOffset start,stop,s,s
        return @clones

    hit : (pos,r) ->
        for clone in @clones
            if clone.hit(pos, r)
                return true
        return false

B.Beam = Beam


class DisruptorBeam extends Beam

    constructor : (pos,r,a) ->
        super H.newLineRA pos,r,a
        @phases = C.beamColors.length
        @damaging = true
        @age = 0
        @damage = 0
        @wid = C.beamWidths[0]
        @color = C.beamColors[0]

    getDamage : -> @damage
    setDamage : (dmg) -> @damage = dmg
    isDamaging : -> @damaging

    update : (dt) ->
        phase = Math.floor @age / C.beamDuration * @phases
        @wid = C.beamWidths[phase]
        @color = C.beamColors[phase]
        if @age > 0
            @damaging = false
        if @age > C.beamDuration
            return @alive = false
        @age += dt
        super dt

    hit : (obj) ->
        if not @damaging
            return false
        else
            return super obj.pos, obj.r+@wid




B.DisruptorBeam = DisruptorBeam

B.newDisruptor = (obj) ->
    pew = new DisruptorBeam(obj.pos, C.beamRange, -obj.a)
    pew.setDamage C.beamDamage
    return pew