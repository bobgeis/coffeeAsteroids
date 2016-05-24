

"""
Used to pass modules to one another without add lots to window
"""


# expose an object 
F = _first = {}
root = (exports ? window)
root._first = _first



offeredModules = {}		# this is what comes in
requestedModules = {}	# this is what goes out
appliedModules = {} 	# T/F: [key] was applied?

# request an object representing a module
F.request = (name) ->
	if !requestedModules[name]
		requestedModules[name] = {}
		appliedModules[name] = false
	return requestedModules[name]

# offer an object representing a module
F.offer = (name,module) ->
	if offeredModules[name]
		console.log "namespace collision: #{name}"
	else
		offeredModules[name] = module


# copy an offered object to the requested one
F.applyModule = (name) ->
	console.log "Applying #{name}"
	if !offeredModules[name] 
		console.log "module never offered: #{name}"
		return false
	if !requestedModules[name]
		console.log "module never requested: #{name}"
		return false
	if appliedModules[name]
		console.log "module already applied: #{name}"
		return false
	for key, value of offeredModules[name]
		requestedModules[name][key] = value
	appliedModules[name] = true
	# console.log requestedModules[name]
	return true

# apply all offered objects to their requested ones
F.applyAllModules = ->
	for name, module of offeredModules
		F.applyModule name
	F.checkAllModulesApplied()

# check that all requested objects were applied
F.checkAllModulesApplied = ->
	allApplied = true
	for name, applied of appliedModules
		if !applied
			console.log "module not applied: #{name}"
			allApplied = false
	return allApplied





console.log "_first!"

