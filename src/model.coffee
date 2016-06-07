"""
Model
"""


# offering
M = {}
_first.offer('model',M)

# requesting
A = _first.request('assets')
C = _first.request('config')
E = _first.request('entity')
Es = _first.request('entities')
H = _first.request('helper')



class Model
	player : null
	bases : []
	ships : []
	rocks : []
	booms : []
	shots : []
	loot : []
	constructor : ->

    init : ->
        "Build the initial state."

	draw : (ctx) ->
        "Draw the model."











