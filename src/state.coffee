"""
State

Various game states/modes/screens/views/etc.
eg: Preloader Screen, Splash Screen, Play Screen, etc.
"""

# offering
S = {}
_first.offer('state',S)

# requesting
A = _first.request('assets')
C = _first.request('config')
H = _first.request('helper')
M = _first.request('model')
Q = _first.request('quest')
U = _first.request('hud')

eng = null
S.initStates = (engine) ->
    eng = engine
    eng.changeState(S.preload)

changeState = (state) ->
    eng.changeState(state)

getPlayer = -> eng.player
getModel = -> eng.model
getState = -> eng.state
getCtx = -> eng.ctx

class State
    constructor : -> return
    enter : ->
        console.log "enter"
    draw : (ctx) ->
        console.log "draw #{ctx}"
    update : (dt) ->
        return false
    input : (type,data) ->
        console.log "input: #{type} #{data}"
    exit : ->
        console.log "exit"


currentState = null

S.setState = (state) ->
    if currentState
        currentState.exit()
    state.enter()
    currentState = state

S.updateState = (dt) ->
    if currentState
        currentState.update(dt)

# this is the preloading screen that runs while assets are loading
S.preload = {
    enter : ->
        console.log "enter preload"
        A.loadAllImgs()
    draw : (ctx) ->
        ctx.fillStyle = "#000000"
        ctx.fillRect(0,0,ctx.canvas.width,ctx.canvas.height)
        H.drawText(ctx,"Loading",ctx.canvas.width/2,ctx.canvas.height/2,30)
    update : (dt) ->
        if A.loadingFinished()
            A.afterLoad()
            changeState S.splash
    input : (type,data) ->
        return
    exit : ->
        console.log "exit preload"
}


# this is the splash screen
S.splash = {
    y : 0
    enter : ->
        console.log "enter splash"
    draw : (ctx) ->
        ctx.fillStyle = "#000000"
        ctx.fillRect(0,0,ctx.canvas.width,ctx.canvas.height)
        H.drawImg ctx, A.img.bg.tile,
                ctx.canvas.width/2, ctx.canvas.height/2 + @y
        H.drawImg ctx, A.img.bg.tile,
                ctx.canvas.width/2, ctx.canvas.height/2 + @y - C.tileSize
        # img = A.img.ship.dropciv
        img = A.img.ship.rayciv
        a = H.HALFPI
        H.drawImg ctx, img, ctx.canvas.width/2, ctx.canvas.height/2, a
        H.drawText ctx, "Press [Enter] to start.",
                 ctx.canvas.width/2, ctx.canvas.height/2+150, 15
        H.drawText ctx, "Game controls:",
                 ctx.canvas.width/2, ctx.canvas.height/2+200, 12
        H.drawText ctx, "Arrow Keys to move.",
                 ctx.canvas.width/2, ctx.canvas.height/2+212, 10
        H.drawText ctx, "Press [Space] to fire.",
                 ctx.canvas.width/2, ctx.canvas.height/2+224, 10
        H.drawText ctx, "Hold [Enter] to dock.",
                 ctx.canvas.width/2, ctx.canvas.height/2+236, 10
    update : (dt) ->
        @y = @y + dt/1.5
        @y = @y % C.tileSize
    input : (type,data) ->
        if type == "keydown"
            console.log data.code
            if data.code == "Enter"
                S.play.init()
                changeState S.play
    exit : ->
        console.log "exit splash"
}


# this is the main play mode
S.play = {

    model : null

    enter : ->
        console.log "enter play"
    init : ->
        @model = new M.Model()
    draw : (ctx) ->
        ctx.fillStyle = "#000000"
        ctx.fillRect(0,0,ctx.canvas.width,ctx.canvas.height)
        if @model
            @model.draw ctx
    update : (dt) ->
        # update the model
        if @model
            @model.update dt
            @maybeChangeMode()
    input : (type,data) ->
        if type == "keydown"
            if data.code == "ArrowLeft"
                @model.command 1
            else if data.code == "ArrowRight"
                @model.command 2
            else if data.code == "ArrowUp"
                @model.command 3
            else if data.code == "ArrowDown"
                @model.command 4
            else if data.code == "Space"
                @model.command 6
            else if data.code == "Enter"
                @model.command 7
            # debugging commands
            # else if data.code == "KeyR"
            #     @model.command 97
            else if data.code == "KeyL"
                @model.command 98
            else if data.code == "KeyK"
                @model.command 99
        else if type == "keyup"
            if data.code == "ArrowLeft"
                @model.command 11
            else if data.code == "ArrowRight"
                @model.command 11
            else if data.code == "ArrowUp"
                @model.command 13
            else if data.code == "ArrowDown"
                @model.command 13
            else if data.code == "Space"
                @model.command 5
            else if data.code == "Enter"
                @model.command 17
    exit : ->
        console.log "exit play"
    maybeChangeMode : ->
        if @model.changeMode
            newMode = @model.changeMode
            @model.changeMode = 0
            if newMode == 1
                changeState S.gameOver
            else if newMode == 2
                changeState S.dockMode
                S.dockMode.setQuest @model.quest
}


# this is the end of game state from the play state
S.gameOver = {
    enter : ->
        console.log "enter gameOver"
    draw : (ctx) ->
        S.play.draw(ctx)
        H.drawText ctx, "You have died. So it goes.",
                 ctx.canvas.width/2, ctx.canvas.height/2-200, 30
        H.drawText ctx, "Press [Escape] to go to the intro.",
                 ctx.canvas.width/2, ctx.canvas.height/2+250, 15
    update : (dt) ->
        S.play.model.update(dt)
    input : (type,data) ->
        if type == "keydown"
            if data.code == "Escape"
                changeState S.splash
    exit : ->
        console.log "exit gameOver"
}




S.dockMode = {
    enter : ->
        console.log "enter dockMode"
        @msg = U.dockMessageWindow
    setQuest : (quest) ->
        @msg.setQuest(quest)
    draw : (ctx) ->
        S.play.draw(ctx)
        @msg.draw(ctx)
        H.drawText ctx, "Your ship is docked and refueled.",
                 ctx.canvas.width/2, ctx.canvas.height/2-200, 20
        H.drawText ctx, "Press [Escape] to launch.",
                 ctx.canvas.width/2, ctx.canvas.height/2+250, 20
    update : (dt) ->
        return

    input : (type,data) ->
        if type == "keydown"
            if data.code == "Escape"
                changeState S.play

    exit : ->
        console.log "exit dockMode"

}













