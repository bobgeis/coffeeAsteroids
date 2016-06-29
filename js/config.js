// Generated by CoffeeScript 1.10.0
(function() {
  "Config\n\nConfiguration values";
  var C, boomColors, flashColors;

  C = {};

  _first.offer('config', C);

  C.timeStep = 1000 / 60.0;

  C.timePanic = 1000 * 60.0;

  C.winWid = 800;

  C.winHei = 650;

  C.halfWinWid = C.winWid / 2;

  C.halfWinHei = C.winHei / 2;

  C.tileSize = 2500;

  C.tileDensity = 15;

  C.tileCount = Math.floor(C.tileDensity * C.tileSize * C.tileSize / 10000);

  C.spectralTypes = ['A', 'B', 'F', 'K', 'M', 'O'];

  C.baseMass = 10000;

  C.baseAngVel = 0.1 / 1000;

  C.shipAcc = 5 / 1000;

  C.shipRetro = C.shipAcc / 3;

  C.shipAngVel = 2 / 1000;

  C.shipDrag = 0.4 / 1000;

  C.shipDockingDrag = 5 / 1000;

  C.shipDockingTime = 1000;

  C.shipMass = 10;

  C.shipShields = 5;

  C.shipRegen = 1 / 2500;

  C.shipBeamCoolDown = 1 * 1000;

  C.shipInvincibleDuration = 300;

  C.shipInitialVeloctiy = 0.5;

  C.shipFuelMax = 180 * 1000;

  C.shipDockRadius = 50;

  C.shipWarpRadius = 120;

  C.beamDamage = 1;

  C.beamRange = 500;

  C.beamDuration = 110;

  C.beamScatter = 8 / 100;

  C.beamCoolDown = 110;

  C.beamBurstCount = 5;

  C.beamEnergyMax = 15;

  C.beamEnergyRegen = 2.5 / 1000;

  C.beamColors = ["rgba(100, 255, 255, 1)", "rgba(  0, 225, 255, 1)", "rgba( 25, 175, 200, 1)", "rgba( 25, 125, 175, 1)", "rgba( 25, 100, 100, 1)", "rgba(  0,  50,  50, 1)"];

  C.beamWidths = [4, 3, 2, 1, 1, 1];

  C.tarBeamWidth = 2;

  C.tarBeamRange = 500;

  C.tarBeamColor = "rgba(250,100,100,0.5)";

  C.tracBeamRange = 100;

  C.tracBeamCoolDown = 500;

  C.tracBeamDuration = 300;

  C.tracBeamWidths = [3, 4, 3, 2, 2, 1];

  C.tracBeamColors = ["rgba(255, 255, 255, 1.0)", "rgba(225, 225, 100, 1.0)", "rgba(175, 175,  50, 0.8)", "rgba(125, 125,  25, 0.6)", "rgba( 75,  75,  10, 0.4)", "rgba( 25,  25,   0, 0.3)"];

  C.tracPulseInitialRadius = 10;

  C.tracPulseGrowthRate = 5;

  C.rockCollisionDamage = 5;

  C.rockAngVel = 2 / 1000;

  C.rockVel = 200 / 1000;

  C.rockRad = 30;

  C.rockRadii = [12, 15, 20, 26, 36];

  C.rockMasses = [5, 10, 20, 40, 100];

  C.rockSpawnChance = 0.3;

  C.rockMass = 25;

  C.rockArmor = 5;

  C.rockRegen = 1 / 100;

  C.rockMaxDamage = {
    C: [1.0, 1.0, 1.0, 1.5, 2.0],
    S: [1.0, 1.5, 2.0, 2.5, 3.0],
    M: [2.0, 2.5, 3.0, 3.5, 4.0]
  };

  C.rockBaseColors = {
    C: [[125, 125, 125], [100, 80, 70]],
    S: [[120, 120, 0], [130, 69, 19]],
    M: [[90, 90, 90], [115, 65, 14]]
  };

  C.rockBoomColors = {
    C: [[255, 100, 100], [255, 125, 100]],
    S: [[240, 150, 100], [255, 100, 100]],
    M: [[240, 100, 100], [255, 125, 100]]
  };

  C.rockColor = function(ratio, type, side) {
    var base, boom, colors, i, j;
    base = C.rockBaseColors[type][side];
    boom = C.rockBoomColors[type][side];
    colors = [];
    for (i = j = 0; j < 3; i = ++j) {
      colors.push(Math.floor((boom[i] - base[i]) * ratio + base[i]));
    }
    return "rgba(" + colors[0] + "," + colors[1] + "," + colors[2] + ",1";
  };

  C.boomMaxAge = 250;

  C.boomGrowthRate = 180 / 1000;

  C.boomInitialRadius = 25;

  boomColors = {
    inner: [[235, 255, 255], [245, 255, 255], [255, 255, 255], [255, 245, 245], [255, 225, 225], [245, 200, 200], [235, 160, 160], [225, 120, 120], [200, 75, 75], [150, 25, 25]],
    outer: [[235, 255, 255], [245, 255, 225], [255, 255, 200], [255, 245, 175], [255, 225, 150], [245, 200, 125], [235, 150, 75], [225, 100, 50], [200, 25, 25], [150, 0, 0]]
  };

  C.boomInnerColor = function(ratio) {
    var colors, list;
    list = boomColors.inner;
    colors = list[Math.floor(ratio * list.length)];
    return "rgba(" + colors[0] + "," + colors[1] + "," + colors[2] + "," + (1 - ratio / 2);
  };

  C.boomOuterColor = function(ratio) {
    var colors, list;
    list = boomColors.outer;
    colors = list[Math.floor(ratio * list.length)];
    return "rgba(" + colors[0] + "," + colors[1] + "," + colors[2] + "," + (1 - ratio / 2);
  };

  C.flashMaxAge = 300;

  C.flashShrinkRate = 100 / 1000;

  C.flashInitialRadius = 40;

  flashColors = {
    inner: [[255, 255, 255], [255, 255, 255], [225, 255, 255], [200, 255, 255], [150, 255, 255], [125, 225, 255], [100, 200, 225], [90, 150, 200], [75, 100, 150], [50, 75, 125]],
    outer: [[255, 255, 255], [255, 255, 255], [225, 255, 255], [200, 255, 255], [150, 255, 255], [125, 225, 255], [100, 200, 225], [90, 150, 200], [75, 100, 150], [50, 75, 125]]
  };

  C.flashInnerColor = function(ratio) {
    var colors, list;
    list = flashColors.inner;
    colors = list[Math.floor(ratio * list.length)];
    return "rgba(" + colors[0] + "," + colors[1] + "," + colors[2] + "," + (1 - ratio);
  };

  C.flashOuterColor = function(ratio) {
    var colors, list;
    list = flashColors.outer;
    colors = list[Math.floor(ratio * list.length)];
    return "rgba(" + colors[0] + "," + colors[1] + "," + colors[2] + "," + (1 - ratio);
  };

  C.crystalChance = {
    C: 0.1,
    S: 0.3,
    M: 0.5
  };

  C.crystalMaxAge = 60 * 1000;

  C.crystalSpin = 4 / 1000;

  C.lifepodMaxAge = 60 * 1000;

  C.lifepodVel = 100 / 1000;

  C.lifepodSpin = 4 / 1000;

  C.luckyBaseLocation = [-C.tileSize / 4 + 50, -C.tileSize / 4 + 50];

  C.buildBaseLocation = [C.tileSize / 4 - 30, C.tileSize / 4 - 70];

  C.navPtNames = ["Alpha Octolindis", "New Dilgan"];

  C.mousePtNames = ["Locus 3250", "Rust Belt", "Grim Orchard"];

  C.navPtLocations = {
    "Alpha Octolindis": [-C.tileSize / 4 + 100, C.tileSize / 4 - 50],
    "New Dilgan": [C.tileSize / 4 - 70, -C.tileSize / 4 + 30],
    "Locus 3250": [-50, -50],
    "Rust Belt": [C.tileSize / 2 - 52, 150],
    "Grim Orchard": [120, C.tileSize / 2 - 137]
  };

  C.navPtDefaults = {
    "Alpha Octolindis": [true, true],
    "New Dilgan": [true, false],
    "Locus 3250": [false, true],
    "Grim Orchard": [false, false],
    "Rust Belt": [false, false]
  };

  C.navPtSpawnRates = {
    "Alpha Octolindis": [true, true],
    "New Dilgan": [true, false],
    "Locus 3250": [false, true],
    "Rust Belt": [false, false],
    "Grim Orchard": [false, false]
  };

  C.navPtRadius = 120;

  C.navPtThickness = 2;

  C.navPtFontSize = 14;

  C.navPtColors = ["rgba(100, 255, 255, 0.8)", "rgba(100, 100, 255, 0.8)", "rgba(255, 200,   0, 0.8)", "rgba(255, 100, 100, 0.8)"];

}).call(this);
