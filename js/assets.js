// Generated by CoffeeScript 1.10.0
(function() {
  "This loads images and sound assets.";
  var A, C, H, aM, loadImg, loadImgFolder, thingsLoaded, thingsToLoad;

  A = {};

  _first.offer('assets', A);

  aM = _first.request('assetMap');

  C = _first.request('config');

  H = _first.request('helper');

  A.img = {};

  A.snd = {};

  thingsToLoad = 0;

  thingsLoaded = 0;

  A.loadingFinished = function() {
    return thingsToLoad === thingsLoaded;
  };

  A.loadAllImgs = function() {
    var folder, j, len, ref, results;
    console.log("loading images");
    ref = aM.imgFolders;
    results = [];
    for (j = 0, len = ref.length; j < len; j++) {
      folder = ref[j];
      results.push(loadImgFolder(folder));
    }
    return results;
  };

  loadImgFolder = function(folder) {
    var name, ref, results, src;
    if (!aM[folder]) {
      console.log("Image folder: " + folder + " not found in assets.");
      return false;
    }
    A.img[folder] = {};
    ref = aM[folder];
    results = [];
    for (name in ref) {
      src = ref[name];
      results.push(loadImg(folder, name, src));
    }
    return results;
  };

  loadImg = function(folder, name, src) {
    var img;
    thingsToLoad++;
    img = new Image();
    img.src = src;
    return img.onload = function() {
      var ctx;
      ctx = H.createCanvas().getContext('2d');
      ctx.canvas.width = img.width;
      ctx.canvas.height = img.width;
      ctx.save();
      ctx.translate(img.width / 2, img.width / 2);
      ctx.rotate(H.HALFPI);
      ctx.drawImage(img, -img.width / 2, -img.width / 2);
      ctx.restore();
      thingsLoaded++;
      return A.img[folder][name] = ctx;
    };
  };

  A.createBgTiles = function() {
    "create a starfield background";
    var ctx, i, j, pos, ref, star;
    A.img.bg = {};
    ctx = H.createCanvas().getContext('2d');
    ctx.canvas.width = C.tileSize;
    ctx.canvas.height = C.tileSize;
    for (i = j = 0, ref = C.tileDensity; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      star = H.getRandomObjValue(A.img.star);
      pos = H.getRandomPos(C.tileSize, C.tileSize);
      H.drawImg(ctx, star, pos.x, pos.y, 0);
    }
    return A.img.bg.tile = ctx;
  };

}).call(this);
