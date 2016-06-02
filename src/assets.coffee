"""
This loads images and sound assets.
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
		# console.log "#{name} loaded"
		# console.log "Things loaded = #{thingsLoaded}"
		A.img[folder][name] = ctx

A.createBgTiles = ->
	"create a starfield background"
	A.img.bg = {}
	ctx = H.createCanvas().getContext '2d'
	ctx.canvas.width = C.tileSize
	ctx.canvas.height = C.tileSize
	for i in [0...C.tileDensity]
		star = H.getRandomObjValue(A.img.star)
		pos = H.getRandomPos(C.tileSize,C.tileSize)
		H.drawImg ctx, star, pos.x, pos.y, 0
		# ctx.drawImage star, pos.x, pos.y
	# console.log pos
	A.img.bg.tile = ctx




