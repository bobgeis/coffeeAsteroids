// Generated by CoffeeScript 1.10.0
(function() {
  "Config\n\nConfiguration values";
  var C;

  C = {};

  _first.offer('config', C);

  C.timeStep = 1000 / 60.0;

  C.timePanic = 1000 * 60.0;

  C.winWid = 800;

  C.winHei = 650;

  C.halfWinWid = C.winWid / 2;

  C.halfWinHei = C.winHei / 2;

  C.tileSize = 10000;

  C.tileDensity = 15;

  C.tileCount = Math.floor(C.tileDensity / 10000 * C.tileSize * C.tileSize);

  C.shipAcc = 5 / 1000;

  C.shipAngVel = 2 / 1000;

}).call(this);
