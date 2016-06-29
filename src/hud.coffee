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
H = _first.request('helper')


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
    # safeColor =     [100,120,255,1.0]
    # dangerColor =   [255,120,100,1.0]
    safeColor =     [100,160,255,1.0]
    dangerColor =   [255,100,150,1.0]
    bar = new BarGraph("Shields",ship,"damage","maxDamage",
            dangerColor,safeColor,10,10)
    return bar

U.shipBeamEnergyBar = (ship) ->
    fullColor =     [ 50,250,250,1.0]
    emptyColor =    [255,128,  0,1.0]
    bar = new BarGraph("Charge",ship,"beamEnergy","beamEnergyMax",
            emptyColor,fullColor,10,40)
    return bar

U.shipFuelBar = (ship) ->
    # fullColor =     [100,255,255,1.0]
    # emptyColor =    [128,128,  0,1.0]
    fullColor =     [100,255,100,1.0]
    emptyColor =    [255,175,  0,1.0]
    bar = new BarGraph("Reactant",ship,"fuel","fuelMax",
            emptyColor,fullColor,10,70)
    return bar



class PlayMessage

    constructor : (@message,@x,@y, @visible=true, @size=15, @color="#FFFFFF")->

    update : (dt) -> return
    draw : (ctx) ->
        if @visible
            drawText ctx, @message, @x, @y, @size, @color


class DockMessage extends PlayMessage

    constructor : (@player) ->
        super("Hold [Enter] to dock.",C.winWid/2, C.winHei/2+130)

    draw : (ctx) ->
        if @player.canDock
            drawText ctx, @message, @x, @y, @size, @color

U.dockMessage = (player) ->
    new DockMessage(player)


drawText = (ctx,text,x,y,size=15,color="#FFFFFF",font="Arial") ->
        ctx.fillStyle = color
        ctx.font = "#{Math.floor(size)}px #{font}"
        w = Math.floor((ctx.measureText text).width/2)
        ctx.fillText text, Math.floor(x)-w,Math.floor(y)-Math.floor(size)



class MessageWindow

    constructor : (@dx, @dy, @bgColor, @fgColor) ->
        @bodyText = ""
        @headerText = ""
        @footerText = ""

    update : (dt) -> return

    draw : (ctx) ->
        ctx.fillStyle = @bgColor
        cx = ctx.canvas.width/2
        cy = ctx.canvas.height/2
        ctx.fillRect(cx - @dx/2, cy - @dy/2, @dx, @dy)

    setBodyText : (@bodyText) ->
    setHeaderText : (@headerText) ->
    setFooterText : (@footerText) ->


U.dockMessageWindow = ->
    msg = new MessageWindow(400,400,'#000000','#FFFFFF')
    msg.setBodyText "text"
    msg