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
		drawText(ctx,"Loading",30,ctx.canvas.width/2,ctx.canvas.height/2)
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
		drawText ctx, "Press [Enter] to start.",15,
				 ctx.canvas.width/2, ctx.canvas.height/2+130
	update : (dt) ->
		@y = @y + dt/1.5
		@y = @y % C.tileSize
	input : (type,data) ->
		if type == "keydown"
			console.log data.code
			if data.code == "Enter"
				changeState S.play
	exit : ->
		console.log "exit splash"
}


# this is the main play mode
S.play = {

	model : null

	enter : ->
		console.log "enter play"
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
			if @model.gameOver
				changeState S.gameOver
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
	exit : ->
		console.log "exit play"
}


# this is the end of game state from the play state
S.gameOver = {
	enter : ->
		console.log "enter gameOver"
	draw : (ctx) ->
		S.play.draw(ctx)
		drawText ctx, "You have died. So it goes.", 30,
				 ctx.canvas.width/2, ctx.canvas.height/2-200
		drawText ctx, "Press [Enter] to restart.", 15,
				 ctx.canvas.width/2, ctx.canvas.height/2+200
	update : (dt) ->
		S.play.model.update(dt)
	input : (type,data) ->
		if type == "keydown"
			if data.code == "Enter"
				changeState S.splash
	exit : ->
		console.log "exit gameOver"
}






drawText = (ctx,text,size,x,y) ->
		ctx.fillStyle = "#FFFFFF"
		ctx.font = "#{Math.floor(size)}px Arial"
		w = Math.floor((ctx.measureText text).width/2)
		ctx.fillText text, Math.floor(x)-w,Math.floor(y)-Math.floor(size)










