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
		text = "Loading"
		ctx.fillStyle = "#FFFFFF"
		ctx.font = '30px Arial'
		w = (ctx.measureText text).width/2
		ctx.fillText text, Math.floor(ctx.canvas.width/2)-w,
									Math.floor(ctx.canvas.height/2)-15
	update : (dt) ->
		if A.loadingFinished()
			A.createBgTiles()
			changeState S.splash
	input : (type,data) ->
		console.log "input: #{type} #{data}"
		console.log type
		console.log data
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
		H.drawImg ctx, A.img.bg.tile, ctx.canvas.width/2, ctx.canvas.height/2 + @y
		H.drawImg ctx, A.img.bg.tile, ctx.canvas.width/2, ctx.canvas.height/2 + @y - C.tileSize
		img = A.img.ship.dropciv
		a = H.HALFPI
		H.drawImg ctx, img, ctx.canvas.width/2, ctx.canvas.height/2, a
	update : (dt) ->
		@y = @y + dt/1.5
		@y = @y % C.tileSize
	input : (type,data) ->
		if type == "keydown"
			console.log data.code
			if data.code == "Space"
				changeState S.play
	exit : ->
		console.log "exit splash"
}


# this is the main play mode
S.play = {

	player : null
	model : null

	enter : ->
		console.log "enter play"
	draw : (ctx) ->
		ctx.fillStyle = "#000000"
		ctx.fillRect(0,0,ctx.canvas.width,ctx.canvas.height)
	update : (dt) ->
		# update the camera
		if @player
			H.updateCamera @player.pos
		# update the model
		if @model
			@model.upate dt
		return false
	input : (type,data) ->
		console.log "input: #{type} #{data}"
	exit : ->
		console.log "exit play"
}


# this is the end of game state
S.gameOver = {
	enter : ->
		console.log "enter gameOver"
	draw : (ctx) ->
		console.log "draw #{ctx}"
	update : (model) ->
		console.log "update #{model}"
	input : (type,data) ->
		console.log "input: #{type} #{data}"
	exit : ->
		console.log "exit gameOver"
}
















