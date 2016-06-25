"""
Hud

These are parts of the "Heads Up Display".
They represent things shown on the screen to the player that aren't directly
part of the game world.  For example a readout of the player's shields.

"""



# expose properties for other modules by adding them to H
U = {}
_first.offer('hud',U)

# request any modules here
C = _first.request('config')


class BarGraph

    constructor : (@name,@obj,@field,@fieldMax,@colorEmpty,@colorFull,@x,@y) ->

    draw : (ctx) ->
        ratio = @getRatio()
        color = @getColor(ratio)
        ctx.fillStyle = color
        ctx.font = "10px Arial"
        # draw text
        ctx.fillText @name, @x, @y
        # draw bar
        percent = Math.floor 100 * ratio
        ctx.lineWidth = 5
        ctx.strokeStyle = color
        ctx.beginPath()
        ctx.moveTo @x, @y + 10
        ctx.lineTo @x + percent, @y + 10
        ctx.stroke()
        ctx.closePath()
        # draw %
        ctx.fillText "#{percent}%", @x + 75, @y

    getRatio : ->
        return 1 - Math.min 1, @obj[@field] / @obj[@fieldMax]

    update : (dt) -> return

    getColor : (ratio) ->
        colors = []
        for i in [0...4]
            colors.push Math.floor((@colorFull[i] - @colorEmpty[i]) * ratio + @colorEmpty[i])
        return "rgba(#{colors[0]},#{colors[1]},#{colors[2]},#{colors[3]})"


U.shipShieldBar = (ship) ->
    safeColor =     [100,120,255,1.0]
    dangerColor =   [255,120,100,1.0]
    bar = new BarGraph("Shields",ship,"damage","maxDamage",
            dangerColor,safeColor,10,10)
    return bar

U.shipBeamEnergyBar = (ship) ->
    fullColor =     [100,255,100,1.0]
    emptyColor =    [255,200,  0,1.0]
    bar = new BarGraph("Energy",ship,"beamEnergy","beamEnergyMax",
            emptyColor,fullColor,10,40)
    return bar



drawText = (ctx,text,size,x,y) ->
        ctx.fillStyle = "#FFFFFF"
        ctx.font = "#{Math.floor(size)}px Arial"
        w = Math.floor((ctx.measureText text).width/2)
        ctx.fillText text, Math.floor(x)-w,Math.floor(y)-Math.floor(size)




