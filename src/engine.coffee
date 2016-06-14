"""
The "Engine"

This should dispatch game input, update, and view
"""


# offering
E = {}
_first.offer('engine',E)

# requesting
C = _first.request('config')
H = _first.request('helper')
M = _first.request('model')
S = _first.request('state')


class Engine

	player : null
	model : null

	state : null
	lastState : null

	constructor : (@ctx) ->
		@ctx.canvas.width = C.winWid
		@ctx.canvas.height = C.winHei
		S.initStates this
		@timeStep = C.timeStep
		@timePanic = C.timePanic
		@bindEvent 'keydown'
		@bindEvent 'keyup'

	draw : ->
		"Draw the game state to the canvas"
		@state.draw(@ctx)

	update : (dt) ->
		"Update the game state by dt"
		while dt > @timeStep
			@state.update(@timeStep)
			dt = dt - @timeStep
			if dt > @timePanic
				# dump time and start over
				dt = 0
		@state.update(dt)

	input : (type,data) ->
		"Handle user input"
		@state.input(type,data)

	changeState : (newState) ->
		"Change between game states"
		if @state
			@state.exit()
			@lastState = @state
		@state = newState
		@state.enter()

	# pushState : (newState) ->
	# 	return

	popState : ->
		if @lastState and @state
			@state.exit()
			@state = @lastState
			@state.enter()

	bindEvent : (eventType) =>
		window.addEventListener(eventType, (eventData)=>
			if @state
				@state.input eventType, eventData
				)

E.Engine = Engine














