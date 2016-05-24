"""
This loads images and sound assets.
"""



L = {}
_first.offer('loader',L)
H = _first.request('helper')
A = _first.request('assets')


L.img = {}
L.snd = {}


thingsToLoad = 0
thingsLoaded = 0

L.loadingFinished = ->
	return thingsToLoad == thingsLoaded

L.loadAllImgs = ->
	# get image files and put them in canvases
	for folder in A.imgFolders
		loadImgFolder folder
	# console.log "things to load = #{thingsToLoad}"

loadImgFolder = (folder) ->
	if !A[folder]  
		console.log "Image folder: #{folder} not found in assets."
		return false
	console.log "Loading #{folder}"
	L.img[folder] = {}
	# console.log L
	for name, src of A[folder]
		loadImg folder, name, src

loadImg = (folder,name,src) ->
	thingsToLoad++
	img = new Image()
	img.src = src
	img.onload = ->
		ctx = H.createCanvas().getContext '2d'
		ctx.save()
		# you need to translate the origin before you rotate 
		ctx.translate img.width, img.height  
		ctx.rotate H.HALFPI
		ctx.drawImage img, 0, 0
		ctx.restore()
		thingsLoaded++
		# console.log "Things loaded = #{thingsLoaded}"
		L.img[folder][name] = ctx.canvas

L.createBgImg = ->
	"create a starfield"
	L.img.bg = {}




