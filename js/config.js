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

  C.tileSize = 2000;

  C.tileDensity = 15;

  C.tileCount = Math.floor(C.tileDensity / 10000 * C.tileSize * C.tileSize);

  C.baseMass = 10000;

  C.shipAcc = 5 / 1000;

  C.shipRetro = C.shipAcc / 3;

  C.shipAngVel = 2 / 1000;

  C.shipDrag = .1 / 1000;

  C.shipMass = 10;

  C.shipShields = 10;

  C.shipRegen = 0.5 / 1000;

  C.shipBeamCoolDown = 1 * 1000;

  C.beamDamage = 1;

  C.beamRange = 500;

  C.beamDuration = 150;

  C.beamColors = ["rgba(100, 255, 255, 1)", "rgba(  0, 225, 255, 1)", "rgba( 25, 175, 175, 1)", "rgba( 50, 125, 125, 1)", "rgba( 25,  50,  50, 1)", "rgba(  0,   0,   0, 0)"];

  C.beamWidths = [4, 3, 2, 1, 1, 0];

  C.rockAngVel = 2 / 1000;

  C.rockVel = 100 / 1000;

  C.rockRad = 30;

  C.rockSpawnChance = 3 / 1000;

  C.rockMass = 100;

  C.rockArmor = 1;

  C.rockRegen = 0;

}).call(this);
