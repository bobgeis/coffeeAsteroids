"""
Assets

This loads images and sound assets and puts them in objects for use.
"""



A = {}
_first.offer('assets',A)
aM = _first.request('assetMap')
C = _first.request('config')
H = _first.request('helper')


A.img = {}
A.snd = {}


thingsToLoad = 0
thingsLoaded = 0

A.loadingFinished = ->
	return thingsToLoad == thingsLoaded

A.loadAllImgs = ->
	# get image files and put them in canvases
	console.log "loading images"
	for folder in aM.imgFolders
		loadImgFolder folder
	# console.log "things to load = #{thingsToLoad}"

loadImgFolder = (folder) ->
	if !aM[folder]
		console.log "Image folder: #{folder} not found in assets."
		return false
	A.img[folder] = {}
	# console.log L
	for name, src of aM[folder]
		loadImg folder, name, src

loadImg = (folder,name,src) ->
	thingsToLoad++
	img = new Image()
	img.src = src
	img.onload = ->
		ctx = H.createCanvas().getContext '2d'
		ctx.canvas.width = img.width
		ctx.canvas.height = img.width
		ctx.save()
		# you need to translate the origin before you rotate
		ctx.translate img.width/2, img.width/2
		ctx.rotate H.HALFPI
		ctx.drawImage img, -img.width/2, -img.width/2
		ctx.restore()
		thingsLoaded++
		A.img[folder][name] = ctx

A.afterLoad = ->
	A.createBgTiles()
	A.createRocks()
	A.createBooms()
	A.createFlashes()
	A.createTracPulse()
	A.createCrystalList()
	A.createLifepodList()
	A.createNavPoints()

A.createBgTiles = ->
	"create a starfield background"
	A.img.bg = {}
	ctx = H.createCanvas().getContext '2d'
	ctx.canvas.width = C.tileSize
	ctx.canvas.height = C.tileSize
	for i in [0...C.tileCount*10]
		# star = H.getRandomObjValue(A.img.star)
		star = A.img.star["d#{H.getRandomListValue(C.spectralTypes)}"]
		pos = H.pt.random(C.tileSize,C.tileSize)
		H.drawImgStill ctx, star, pos.x, pos.y
	for i in [0...Math.floor(C.tileCount)]
		# star = H.getRandomObjValue(A.img.star)
		star = A.img.star["m#{H.getRandomListValue(C.spectralTypes)}"]
		pos = H.pt.random(C.tileSize,C.tileSize)
		H.drawImgStill ctx, star, pos.x, pos.y
	for i in [0...Math.floor(C.tileCount/10)]
		# star = H.getRandomObjValue(A.img.star)
		star = A.img.star["g#{H.getRandomListValue(C.spectralTypes)}"]
		pos = H.pt.random(C.tileSize,C.tileSize)
		H.drawImgStill ctx, star, pos.x, pos.y
	for i in [0...Math.floor(C.tileCount/100)]
		# star = H.getRandomObjValue(A.img.star)
		star = A.img.star["sg#{H.getRandomListValue(C.spectralTypes)}"]
		pos = H.pt.random(C.tileSize,C.tileSize)
		H.drawImgStill ctx, star, pos.x, pos.y
	# console.log pos
	A.img.bg.tile = ctx


A.createRocks = ->
	rock = {
		C : A.createRockType "C"
		S : A.createRockType "S"
		M : A.createRockType "M"
	}
	A.img.rock = rock

A.createRockType = (type) ->
	sizes = C.rockRadii
	rockType = []
	ratios = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]
	for r in sizes
		rockSize = []
		for ratio in ratios
			ctx = H.createCanvas().getContext '2d'
			ctx.canvas.width = r * 2
			ctx.canvas.height = r * 2
			grad = ctx.createRadialGradient r/2,r/2, 1, r,r, r
			grad.addColorStop 0, C.rockColor(ratio,type,0)
			grad.addColorStop 1, C.rockColor(ratio,type,1)
			ctx.fillStyle = grad
			# draw arc
			ctx.beginPath()
			ctx.arc(r,r,r,0,H.TAU)
			ctx.fill()
			ctx.closePath()
			rockSize.push ctx
		rockType.push rockSize
	return rockType


A.createBooms = ->
	# booms are short lived explosions
	frames = C.boomMaxAge / C.timeStep		# num frames boom is likely to last
	r = C.boomInitialRadius
	vr = C.boomGrowthRate * C.timeStep 		# growth in px/frame
	boom = []
	for i in [0...frames]
		ctx = H.createCanvas().getContext '2d'
		ctx.canvas.width = r * 2
		ctx.canvas.height = r * 2
		grad = ctx.createRadialGradient r,r, 1, r,r, r
		grad.addColorStop 0, C.boomInnerColor(i/frames)
		grad.addColorStop 1, C.boomOuterColor(i/frames)
		ctx.fillStyle = grad
		ctx.beginPath()
		ctx.arc(r,r,r,0,H.TAU)
		ctx.fill()
		ctx.closePath()
		boom.push ctx
		r += vr
	A.img.boom = boom
	return

A.createFlashes = ->
	# flashes are short lived FTL jump flashes
	frames = C.flashMaxAge / C.timeStep		# num frames flash is likely to last
	r = C.flashInitialRadius
	dr = C.flashShrinkRate * C.timeStep 		# shrinkage in px/frame
	flash = []
	for i in [0...frames]
		ctx = H.createCanvas().getContext '2d'
		ctx.canvas.width = r * 2
		ctx.canvas.height = r * 2
		grad = ctx.createRadialGradient r,r, 1, r,r, r
		grad.addColorStop 0, C.flashInnerColor(i/frames)
		grad.addColorStop 1, C.flashOuterColor(i/frames)
		ctx.fillStyle = grad
		ctx.beginPath()
		ctx.arc(r,r,r,0,H.TAU)
		ctx.fill()
		ctx.closePath()
		flash.push ctx
		r += dr
	A.img.flash = flash
	return

A.createTracPulse = ->
	frames = C.tracBeamColors.length
	r = C.tracPulseInitialRadius
	dr = C.tracPulseGrowthRate
	pulse = []
	for i in [0...frames]
		ctx = H.createCanvas().getContext '2d'
		ctx.canvas.width = r * 2
		ctx.canvas.height = r * 2
		# grad = ctx.createRadialGradient r,r, 1, r,r, r
		# grad.addColorStop 0, C.flashInnerColor(i/frames)
		# grad.addColorStop 1, C.flashOuterColor(i/frames)
		ctx.fillStyle = C.tracBeamColors[i]
		ctx.beginPath()
		ctx.arc(r,r,r,0,H.TAU)
		ctx.fill()
		ctx.closePath()
		pulse.push ctx
		r += dr
	A.img.tracPulse = pulse
	return


A.createCrystalList = ->
	crystal = []
	crystal.push A.img.space.cr3
	crystal.push A.img.space.cr2
	crystal.push A.img.space.cr1
	crystal.push A.img.space.cr0
	A.img.crystal = crystal

A.createLifepodList = ->
	lifepod = []
	lifepod.push A.img.space.lb3
	lifepod.push A.img.space.lb2
	lifepod.push A.img.space.lb1
	lifepod.push A.img.space.lb0
	A.img.lifepod = lifepod

A.createNavPoints = ->
	navPts = {}
	for name in C.navPtNames
		navPts[name] = makeNavPtImgs name
	for name in C.mousePtNames
		navPts[name] = makeNavPtImgs name
	A.img.navPts = navPts

makeNavPtImgs = (name) ->
	imgs = []
	t = C.navPtThickness
	h = C.navPtFontSize
	r = C.navPtRadius
	for color in C.navPtColors
		ctx = H.createCanvas().getContext '2d'
		ctx.canvas.width = r * 2 + t*2
		ctx.canvas.height = r * 2 + t*2
		if name == "Alpha Octolindis"
			star = A.img.star.sgO
			H.drawImgStill ctx, star, r+t, r+t
		# draw text
		ctx.fillStyle = color
		ctx.font = "#{h}px Arial"
		w = Math.floor((ctx.measureText name).width/2)
		ctx.fillText name, r-w, r+h+h
		# draw circle
		ctx.lineWidth = t
		ctx.strokeStyle = color
		ctx.beginPath()
		ctx.arc(r+t,r+t,r,0,H.TAU)
		ctx.stroke()
		ctx.closePath()
		imgs.push ctx
	return imgs
