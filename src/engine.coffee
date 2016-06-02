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
S = _first.request('state')


class Engine 

	state : null
	constructor : (@ctx) ->
		@ctx.canvas.width = C.winSize.wid
		@ctx.canvas.height = C.winSize.hei
		S.initStates this
		@bindEvent 'keydown'
		# @bindEvent 'keypress'

	draw : ->
		"Draw the game state to the canvas"
		@state.draw(@ctx)

	update : (dt) ->
		"Update the game state by dt"
		step = C.timeStep * 1.5
		while dt > step
			@state.update(step)
			dt = dt - step
		@state.update(dt)

	input : (type,data) ->
		"Handle user input"
		@state.input(type,data)

	changeState : (newState) ->
		"Change between game states"
		if @state then @state.exit()
		@state = newState
		@state.enter()

	bindEvent : (eventType) =>
		window.addEventListener(eventType, (eventData)=>
			if @state
				@state.input eventType, eventData
				)

E.Engine = Engine














