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
A = _first.request('assets')
C = _first.request('config')
H = _first.request('helper')


# drawText = (ctx,text,x,y,size=15,color="#FFFFFF",font="Arial") ->
#         ctx.fillStyle = color
#         ctx.font = "#{Math.floor(size)}px #{font}"
#         w = Math.floor((ctx.measureText text).width/2)
#         ctx.fillText text, Math.floor(x)-w,Math.floor(y)-Math.floor(size)

class BarGraph

    constructor : (@name,@obj,@field,@fieldMax,@colorEmpty,@colorFull,@x,@y) ->

    draw : (ctx) ->
        ratio = @getRatio()
        color = @getColor(ratio)
        ctx.fillStyle = color
        ctx.font = "10px Arial"
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
            colors.push Math.floor((@colorFull[i]-@colorEmpty[i])*ratio+@colorEmpty[i])
        return "rgba(#{colors[0]},#{colors[1]},#{colors[2]},#{colors[3]})"


U.shipShieldBar = (ship) ->
    safeColor =     [100,150,255,1.0]
    dangerColor =   [255,100,200,1.0]
    bar = new BarGraph("Shields",ship,"damage","maxDamage",
            dangerColor,safeColor,10,10)
    return bar

U.shipBeamEnergyBar = (ship) ->
    fullColor =     [ 50,250,250,1.0]
    emptyColor =    [255,100, 50,1.0]
    bar = new BarGraph("Charge",ship,"beamEnergy","beamEnergyMax",
            emptyColor,fullColor,10,40)
    return bar

U.shipFuelBar = (ship) ->
    fullColor =     [100,255,100,1.0]
    emptyColor =    [255,200,  0,1.0]
    bar = new BarGraph("Core",ship,"fuel","fuelMax",
            emptyColor,fullColor,10,70)
    return bar



class PlayMessage

    constructor : (@message,@x,@y, @visible=true, @size=15, @color="#FFFFFF")->

    update : (dt) -> return
    draw : (ctx) ->
        if @visible
            H.drawText ctx, @message, @x, @y, @size, @color


class DockMessage extends PlayMessage

    constructor : (@player) ->
        super("Hold [Enter] to dock.",C.winWid/2, C.winHei/2+130)

    draw : (ctx) ->
        if @player.canDock and @player.alive
            H.drawText ctx, @message, @x, @y, @size, @color

U.dockMessage = (player) ->
    new DockMessage(player)





class MessageWindow

    constructor : (@dx, @dy, @bgColor, @fgColor) ->
        @bodyText = ""
        @headerText = ""
        @footerText = ""
        @quest = []

    update : (dt) -> return

    draw : (ctx) ->
        ctx.fillStyle = @bgColor
        cx = ctx.canvas.width/2
        cy = ctx.canvas.height/2
        ctx.fillRect(cx - @dx/2, cy - @dy/2, @dx, @dy)
        ctx.strokeStyle = @fgColor
        ctx.lineWidth = 1
        ctx.strokeRect(cx - @dx/2, cy - @dy/2, @dx, @dy)
        # now for text
        ctx.fillStyle = @fgColor
        ctx.font = "16px Arial"
        x = cx - @dx/2
        y = cy - @dy/2
        dx = 20
        dy = 30
        for line in @quest
            ctx.fillText line, x+dx, y+dy
            dy += 20

    setBodyText : (@bodyText) ->
    setHeaderText : (@headerText) ->
    setFooterText : (@footerText) ->
    setQuest : (@quest) ->


U.dockMessageWindow = new MessageWindow(600,400,'#000030','#FFFFFF')








class CargoMonitor

    constructor : (@cargo,@x,@y) ->
        @types = ["crystal","lifepod","mousepod"]
        # @show is used to hide things the player hasn't done
        @show =
            {
                crystal : [false,false,false]
                lifepod : [false,false,false]
                mousepod : [false,false,false]
            }
        @imgs =
            {
                crystal : A.img.crystal[0]
                lifepod : A.img.lifepod[0]
                mousepod : A.img.mousepod[0]
            }

    update : (dt) ->
        for type in @types
            if @cargo[type][0] > 0
                @show[type][0] = true

    draw : (ctx) ->
        dx = 10
        dy = 0
        for type in @types
            if @show[type][0]
                H.drawImgStill ctx,@imgs[type],@x,@y+dy-4
                string = "#{@cargo[type][0]}  /  #{@cargo[type][1]}"
                ctx.fillStyle = "rgba(100,255,255,1)"
                ctx.font = "10px Arial"
                ctx.fillText string, @x+dx, @y+dy
                dy += 12
        return

U.newCargoMonitor = (cargo) ->
    x = 10
    y = 100
    new CargoMonitor(cargo,x,y)

