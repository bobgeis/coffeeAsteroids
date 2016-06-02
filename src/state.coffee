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

eng = null
S.initStates = (engine) ->
	eng = engine
	eng.changeState(S.preload)

changeState = (state) ->
	eng.changeState(state)

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
		# H.drawImg ctx, A.img.bg.tile, 0, Math.floor(@y)
		# H.drawImg ctx, A.img.bg.tile, 0, Math.floor(@y - 1000)
		H.drawImg ctx, A.img.bg.tile, ctx.canvas.width/2, ctx.canvas.height/2 + @y
		H.drawImg ctx, A.img.bg.tile, ctx.canvas.width/2, ctx.canvas.height/2 + @y - 1000
		# ctx.save()
		# ctx.rotate H.HALFPI
		img = A.img.ship.dropciv
		a = H.HALFPI 
		H.drawImg ctx, img, ctx.canvas.width/2, ctx.canvas.height/2, a
		# ctx.drawImage img, ctx.canvas.width/2, ctx.canvas.height/2
		# ctx.restore()
		# ctx.fillStyle = "#FF0000"
		# ctx.arc ctx.canvas.width/2, ctx.canvas.height/2,2,0,H.TWOPI
		# ctx.fill()
	update : (dt) ->
		@y = @y + dt/2
		@y = @y % 1000
	input : (type,data) ->
		console.log "input: #{type} #{data}"
	exit : ->
		console.log "exit splash"
}


# this is the main play mode
S.play = {
	enter : ->
		console.log "enter play"
	draw : (ctx) ->
		console.log "draw #{ctx}"
	update : (dt) ->
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
















