// Generated by CoffeeScript 1.10.0
(function() {
  "Entity\n\nAn entity is a thing in the game world.\nThe player ship, rocks, shots, etc are all entities.\n";
  var A, B, C, DestructibleEntity, E, Entity, EphemeralEntity, H, MovingEntity, NavPointEntity, PlayerShipEntity, RockEntity, ShipEntity, TransportShipEntity,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  E = {};

  _first.offer('entity', E);

  A = _first.request('assets');

  B = _first.request('beam');

  C = _first.request('config');

  H = _first.request('helper');

  Entity = (function() {
    Entity.prototype.img = null;

    Entity.prototype.r_img = 0;

    function Entity(pos) {
      var i;
      this.pos = pos.copyPos();
      this.alive = true;
      this.clones = (function() {
        var j, results;
        results = [];
        for (i = j = 0; j < 9; i = ++j) {
          results.push(H.newPt());
        }
        return results;
      })();
      this.setClones();
    }

    Entity.prototype.setImg = function(img) {
      this.img = img;
      return this.r_img = this.img.canvas.width / 2;
    };

    Entity.prototype.getImg = function() {
      return this.img;
    };

    Entity.prototype.update = function(dt) {
      return this.alive;
    };

    Entity.prototype.draw = function(ctx) {
      var j, len, pt, ref, results;
      ref = this.setClones();
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        pt = ref[j];
        if (H.onScreenEntity(pt, this.r_img)) {
          results.push(H.drawEntity(ctx, this.getImg(), pt));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    Entity.prototype.isAlive = function() {
      return this.alive;
    };

    Entity.prototype.kill = function() {
      return this.alive = false;
    };

    Entity.prototype.centerCamera = function() {
      return H.updateCamera(this.pos);
    };

    Entity.prototype.setClones = function() {
      var s, x, y;
      s = C.tileSize;
      x = this.pos.x;
      y = this.pos.y;
      this.clones[0].setXY(x - s, y - s);
      this.clones[1].setXY(x - s, y);
      this.clones[2].setXY(x - s, y + s);
      this.clones[3].setXY(x, y - s);
      this.clones[4].setXY(x, y);
      this.clones[5].setXY(x, y + s);
      this.clones[6].setXY(x + s, y - s);
      this.clones[7].setXY(x + s, y);
      this.clones[8].setXY(x + s, y + s);
      return this.clones;
    };

    Entity.prototype.findNearest = function(obj) {
      var clone, d, dmin, j, len, nearest, pos, ref;
      nearest = null;
      dmin = C.tileSize;
      pos = obj.pos;
      ref = this.clones;
      for (j = 0, len = ref.length; j < len; j++) {
        clone = ref[j];
        d = clone.distance(pos);
        if (d < dmin) {
          dmin = d;
          nearest = clone;
        }
      }
      return nearest;
    };

    return Entity;

  })();

  E.Entity = Entity;

  E.BgTile = function() {
    var bgTile;
    bgTile = new Entity(H.origin);
    bgTile.setImg(A.img.bg.tile);
    return bgTile;
  };

  MovingEntity = (function(superClass) {
    extend(MovingEntity, superClass);

    function MovingEntity(pos, a1, vel, va1) {
      this.a = a1;
      this.va = va1;
      MovingEntity.__super__.constructor.call(this, pos);
      this.vel = vel.copyPos();
      this.r = 0;
      this.m = 0;
    }

    MovingEntity.prototype.update = function(dt) {
      this.pos.transXY(this.vel.x * dt, -this.vel.y * dt);
      this.a += this.va * dt;
      this.wrap();
      this.setClones();
      return MovingEntity.__super__.update.call(this, dt);
    };

    MovingEntity.prototype.setAcc = function(acc) {
      this.acc = acc;
      if (this.acc && this.acc !== 0) {
        return this.thrust = true;
      } else {
        return this.thrust = false;
      }
    };

    MovingEntity.prototype.setR = function(r1) {
      this.r = r1;
    };

    MovingEntity.prototype.setM = function(m) {
      this.m = m;
    };

    MovingEntity.prototype.draw = function(ctx) {
      var j, len, pt, ref;
      ref = this.clones;
      for (j = 0, len = ref.length; j < len; j++) {
        pt = ref[j];
        if (H.onScreenEntity(pt, this.r_img)) {
          H.drawEntity(ctx, this.getImg(), pt, this.a);
          return;
        }
      }
    };

    MovingEntity.prototype.wrap = function() {
      return this.pos.wrap();
    };

    MovingEntity.prototype.collide = function(obj) {
      var j, len, pt, ref;
      ref = obj.clones;
      for (j = 0, len = ref.length; j < len; j++) {
        pt = ref[j];
        if (this.pos.collide(pt, this.r + obj.r)) {
          return pt;
        }
      }
      return false;
    };

    MovingEntity.prototype.bounce = function(obj) {
      var pt;
      pt = this.collide(obj);
      if (pt) {
        this.bouncePos(obj, pt);
        return this.bounceVel(obj, pt);
      }
    };

    MovingEntity.prototype.bouncePos = function(obj, pt) {
      var a, r;
      a = pt.getFaceAngle(this.pos);
      r = obj.r + this.r;
      H.pt.setPos(pt);
      return this.pos.setPos(H.pt.transPolar(r, a));
    };

    MovingEntity.prototype.bounceVel = function(obj, pt) {
      var a, ma, mb, ovu, vu, vuf, vw, vxf, vyf;
      ma = (this.m - obj.m) / (this.m + obj.m);
      mb = obj.m * 2 / (this.m + obj.m);
      a = this.pos.getFaceAngle(pt);
      vu = this.vel.x * Math.cos(a) - this.vel.y * Math.sin(a);
      vw = this.vel.x * Math.sin(a) + this.vel.y * Math.cos(a);
      ovu = obj.vel.x * Math.cos(a) - obj.vel.y * Math.sin(a);
      vuf = ma * vu + mb * ovu;
      vxf = vuf * Math.cos(a) + vw * Math.sin(a);
      vyf = -vuf * Math.sin(a) + vw * Math.cos(a);
      this.vel.setXY(vxf, vyf);
      return vuf - vu;
    };

    return MovingEntity;

  })(Entity);

  E.MovingEntity = MovingEntity;

  E.LuckyBase = function() {
    var luckyBase, p;
    p = -900;
    luckyBase = new MovingEntity(H.pt.setXY(C.luckyBaseLocation[0], C.luckyBaseLocation[1]), 0, H.origin, -C.baseAngVel);
    luckyBase.setImg(A.img.ship.baselucky);
    luckyBase.setR(luckyBase.r_img);
    luckyBase.setM(C.baseMass);
    luckyBase.name = "lucky";
    return luckyBase;
  };

  E.BuildBase = function() {
    var buildBase, p;
    p = C.tileSize / 2 - 20;
    buildBase = new MovingEntity(H.pt.setXY(C.buildBaseLocation[0], C.buildBaseLocation[1]), 0, H.origin, C.baseAngVel);
    buildBase.setImg(A.img.ship.basebuild);
    buildBase.setR(buildBase.r_img);
    buildBase.setM(C.baseMass);
    buildBase.name = "build";
    return buildBase;
  };

  NavPointEntity = (function(superClass) {
    extend(NavPointEntity, superClass);

    function NavPointEntity(name3) {
      this.name = name3;
      H.pt1.setList(C.navPtLocations[this.name]);
      NavPointEntity.__super__.constructor.call(this, H.pt1, 0, H.origin, 0);
      this.friendly = C.navPtDefaults[this.name][0];
      this.active = C.navPtDefaults[this.name][1];
      this.visible = true;
      this.setImg(A.img.navPts[this.name][this.getIndex()]);
      this.timer = 0;
      this.spawnCheck = false;
      if (this.friendly) {
        this.spawnType = "ship";
      } else {
        this.spawnType = "rock";
      }
      this.spawn = null;
      this.spawnRates = C.navPtSpawnRates[name];
    }

    NavPointEntity.prototype.getIndex = function() {
      if (this.friendly && this.active) {
        return 0;
      } else if (this.friendly) {
        return 1;
      } else if (!this.active) {
        return 2;
      } else {
        return 3;
      }
    };

    NavPointEntity.prototype.update = function(dt) {
      if (this.active) {
        this.timer += dt;
      }
      return NavPointEntity.__super__.update.call(this, dt);
    };

    NavPointEntity.prototype.draw = function(ctx) {
      if (this.visible) {
        return NavPointEntity.__super__.draw.call(this, ctx);
      }
    };

    NavPointEntity.prototype.setActive = function(active) {
      this.active = active;
      return this.setImg(A.img.navPts[this.name][this.getIndex()]);
    };

    NavPointEntity.prototype.getSpawn = function() {
      return false;
    };

    return NavPointEntity;

  })(MovingEntity);

  E.newNavPt = function(name) {
    return new NavPointEntity(name);
  };

  EphemeralEntity = (function(superClass) {
    extend(EphemeralEntity, superClass);

    function EphemeralEntity(imgList, pos, a, vel, va) {
      this.imgList = imgList;
      EphemeralEntity.__super__.constructor.call(this, pos, a, vel, va);
      this.age = 0;
      this.maxAge = 1;
      this.setImg(this.imgList[0]);
      this.type = null;
    }

    EphemeralEntity.prototype.setMaxAge = function(maxAge) {
      this.maxAge = maxAge;
    };

    EphemeralEntity.prototype.setType = function(type1) {
      this.type = type1;
    };

    EphemeralEntity.prototype.update = function(dt) {
      if (this.age >= this.maxAge) {
        this.alive = false;
        return;
      }
      this.updateImg();
      this.age += dt;
      return EphemeralEntity.__super__.update.call(this, dt);
    };

    EphemeralEntity.prototype.draw = function(ctx) {
      return EphemeralEntity.__super__.draw.call(this, ctx);
    };

    EphemeralEntity.prototype.updateImg = function() {
      return this.setImg(this.imgList[Math.floor(this.age / this.maxAge * this.imgList.length)]);
    };

    return EphemeralEntity;

  })(MovingEntity);

  E.newExplosionOnObj = function(obj) {
    var boom;
    boom = new EphemeralEntity(A.img.boom, obj.pos, 0, obj.vel, 0);
    boom.setMaxAge(C.boomMaxAge);
    return boom;
  };

  E.newFlashOnObj = function(obj) {
    var flash;
    flash = new EphemeralEntity(A.img.flash, obj.pos, 0, obj.vel, 0);
    flash.setMaxAge(C.flashMaxAge);
    return flash;
  };

  E.newTracPulseOnObj = function(obj) {
    var pulse;
    pulse = new EphemeralEntity(A.img.tracPulse, obj.pos, 0, H.origin, 0);
    pulse.setMaxAge(C.tracBeamDuration);
    return pulse;
  };

  E.spawnCrystalCheck = function(rock) {
    return Math.random() < C.crystalChance[rock.type];
  };

  E.newCrystalOnObj = function(obj) {
    var angvel, crys, dvel, vel;
    dvel = H.pt1.randomInCircle(C.rockVel);
    vel = H.pt2.sum(dvel, obj.vel);
    angvel = H.randPlusMinus(C.crystalSpin);
    crys = new EphemeralEntity(A.img.crystal, obj.pos, 0, vel, angvel);
    crys.setMaxAge(C.crystalMaxAge);
    crys.setType("crystal");
    return crys;
  };

  E.newLifepodsOnObj = function(obj) {
    var dvel1, dvel2, j, len, list, pod;
    dvel1 = H.pt1.randomOnCircle(C.lifepodVel);
    dvel2 = H.pt2.randomOnCircle(C.lifepodVel);
    list = [];
    if (Math.random() < C.lifepodChance[0]) {
      list.push(new EphemeralEntity(A.img.lifepod, obj.pos, 0, H.pt3.sum(dvel1, obj.vel), H.randPlusMinus(C.lifepodSpin)));
    }
    if (Math.random() < C.lifepodChance[1]) {
      list.push(new EphemeralEntity(A.img.lifepod, obj.pos, Math.PI, H.pt4.diff(dvel1, obj.vel), H.randPlusMinus(C.lifepodSpin)));
    }
    if (Math.random() < C.lifepodChance[2]) {
      list.push(new EphemeralEntity(A.img.lifepod, obj.pos, 0, H.pt5.sum(dvel2, obj.vel), H.randPlusMinus(C.lifepodSpin)));
    }
    if (Math.random() < C.lifepodChance[3]) {
      list.push(new EphemeralEntity(A.img.lifepod, obj.pos, Math.PI, H.pt6.diff(dvel2, obj.vel), H.randPlusMinus(C.lifepodSpin)));
    }
    for (j = 0, len = list.length; j < len; j++) {
      pod = list[j];
      pod.setMaxAge(C.lifepodMaxAge);
      pod.setType("lifepod");
    }
    return list;
  };

  DestructibleEntity = (function(superClass) {
    extend(DestructibleEntity, superClass);

    function DestructibleEntity(pos, a, vel, va) {
      DestructibleEntity.__super__.constructor.call(this, pos, a, vel, va);
      this.damage = 0;
      this.maxDamage = 0;
      this.regen = 0;
    }

    DestructibleEntity.prototype.update = function(dt) {
      if (this.damage >= this.maxDamage) {
        this.alive = false;
        return;
      }
      this.heal(dt);
      return DestructibleEntity.__super__.update.call(this, dt);
    };

    DestructibleEntity.prototype.heal = function(dt) {
      if (this.damage) {
        return this.damage = Math.max(0, this.damage - this.regen);
      }
    };

    DestructibleEntity.prototype.setRegen = function(reg) {
      return this.regen = reg;
    };

    DestructibleEntity.prototype.setMaxDmg = function(maxDmg) {
      return this.maxDamage = maxDmg;
    };

    DestructibleEntity.prototype.applyDamage = function(dmg) {
      this.damage += Math.max(0.5, Math.min(2, dmg));
      return this.isDestroyed();
    };

    DestructibleEntity.prototype.isDestroyed = function() {
      return this.damage >= this.maxDamage;
    };

    return DestructibleEntity;

  })(MovingEntity);

  E.DestructibleEntity = DestructibleEntity;

  RockEntity = (function(superClass) {
    extend(RockEntity, superClass);

    function RockEntity(type1, size1, pos, a, vel, va) {
      this.type = type1;
      this.size = size1;
      RockEntity.__super__.constructor.call(this, pos, a, vel, va);
      this.imgList = A.img.rock[this.type][this.size];
      this.setImg(this.imgList[0]);
      this.setR(C.rockRadii[this.size]);
      this.setM(C.rockMasses[this.size]);
      this.setMaxDmg(C.rockMaxDamage[this.type][this.size]);
      this.setRegen(C.rockRegen);
    }

    RockEntity.prototype.getImg = function() {
      var index;
      if (this.damage) {
        index = Math.floor(this.damage / this.maxDamage * this.imgList.length);
        return this.imgList[index];
      } else {
        return this.imgList[0];
      }
    };

    return RockEntity;

  })(DestructibleEntity);

  E.newRock = function(type, size, pos, a, vel, va) {
    var rock;
    rock = new RockEntity(A.img.rock[type][size], pos, a, vel, va);
    rock.setR(C.rockRadii[size]);
    rock.setM(C.rockMass);
    rock.setMaxDmg(C.rockMaxDamage[type][size]);
    rock.setRegen(C.rockRegen);
    return rock;
  };

  E.RandRock = function() {
    var p, size, type;
    p = C.tileSize / 2;
    H.pt1.randomInBox(-p, p, -p, p);
    H.pt2.randomInCircle(C.rockVel);
    size = H.getRandomListValue([0, 1, 2, 3, 4]);
    type = H.getRandomListValue(["C", "S", "M"]);
    return new RockEntity(type, size, H.pt1, 0, H.pt2, 0);
  };

  E.RockFromNavName = function(name) {
    var a, size, type, v;
    H.pt1.randomInCircle(C.navPtRadius);
    H.pt1.transXY(C.navPtLocations[name][0], C.navPtLocations[name][1]);
    a = H.randAng();
    v = C.rockVel + H.randPlusMinus(C.rockVel / 2);
    H.pt2.setPolar(v, a);
    size = H.getRandomListValue([1, 2, 3, 4]);
    type = C.navPtRockTypes[name];
    return new RockEntity(type, size, H.pt1, 0, H.pt2, 0);
  };

  E.spawnRock = function() {
    return Math.random() < C.rockSpawnChance;
  };

  E.calveRock = function(oldRock) {
    var calf, calves, chance, dvel, dvel2, j, len, pos, size, type;
    if (oldRock.size < 1) {
      return false;
    }
    size = -1 + oldRock.size;
    type = oldRock.type;
    pos = oldRock.pos;
    dvel = H.pt1.randomInCircle(C.rockVel);
    dvel2 = H.pt2.randomOnCircle(C.rockVel);
    chance = C.rockCalveChance[type];
    calves = [];
    if (0 < chance[0]) {
      calves.push(new RockEntity(type, size, pos, 0, H.pt3.sum(dvel, oldRock.vel), 0));
    }
    if (Math.random() < chance[1]) {
      calves.push(new RockEntity(type, size, pos, 0, H.pt3.diff(dvel, oldRock.vel), 0));
    }
    if (Math.random() < chance[2]) {
      calves.push(new RockEntity(type, size, pos, 0, H.pt3.sum(dvel2, oldRock.vel), 0));
    }
    if (Math.random() < chance[3]) {
      calves.push(new RockEntity(type, size, pos, 0, H.pt3.diff(dvel2, oldRock.vel), 0));
    }
    for (j = 0, len = calves.length; j < len; j++) {
      calf = calves[j];
      calf.damage = calf.maxDamage / 2;
    }
    return calves;
  };

  ShipEntity = (function(superClass) {
    extend(ShipEntity, superClass);

    function ShipEntity(type1, faction1, pos, a, vel, va) {
      this.type = type1;
      this.faction = faction1;
      ShipEntity.__super__.constructor.call(this, pos, a, vel, va);
      this.setImg(A.img.ship["" + this.type + this.faction]);
      this.r = this.r_img;
      this.m = C.shipMass;
      this.maxDamage = C.shipShields;
      this.regen = C.shipRegen;
      this.invincible = 0;
      this.invincibleMax = C.shipInvincibleDuration;
      this.drag = C.shipDrag;
      this.acc = 0;
      this.thrust = false;
      this.canDock = false;
      this.docking = 0;
      this.docked = false;
    }

    ShipEntity.prototype.update = function(dt) {
      if (this.invincible) {
        this.invincible = Math.max(0, this.invincible - dt);
      }
      if (this.thrust) {
        this.vel.transPolar(this.acc, this.a);
      }
      if (this.drag) {
        this.vel.scale(1 - this.drag * dt);
      }
      if (this.docking) {
        this.docking += dt;
        this.vel.scale(1 - C.shipDockingDrag * dt);
        if (this.docking > C.shipDockingTime) {
          this.docked = true;
        }
      }
      return ShipEntity.__super__.update.call(this, dt);
    };

    ShipEntity.prototype.applyDamage = function(dmg) {
      if (this.invincible > 0) {

      } else {
        this.invincible = this.invincibleMax;
        return ShipEntity.__super__.applyDamage.call(this, dmg);
      }
    };

    ShipEntity.prototype.beginDocking = function() {
      if (this.canDock) {
        return this.docking += 1;
      } else {
        return this.docking = 0;
      }
    };

    ShipEntity.prototype.stopDocking = function() {
      return this.docking = 0;
    };

    ShipEntity.prototype.turnTowards = function(pos) {
      if (H.wrapAngle(this.pos.getFaceAngle(pos) + this.a) > 0) {
        return -1;
      } else {
        return 1;
      }
    };

    return ShipEntity;

  })(DestructibleEntity);

  TransportShipEntity = (function(superClass) {
    extend(TransportShipEntity, superClass);

    function TransportShipEntity(type, faction, pos, a, vel, va, des) {
      TransportShipEntity.__super__.constructor.call(this, type, faction, pos, a, vel, va);
      this.drag = C.transportDrag;
      this.maxDamage = C.transportShields[faction];
      this.regen = C.transportRegen;
      this.invincibleMax = C.transportInvincibleDuration;
      this.dockTimer = C.transportDockTime;
      this.canWarp = false;
      this.warping = 0;
      this.warped = false;
      this.des = des.copyPos();
    }

    TransportShipEntity.prototype.update = function(dt) {
      this.va = this.turnTowards(this.des) * C.transportAngVel;
      this.beginDocking();
      return TransportShipEntity.__super__.update.call(this, dt);
    };

    return TransportShipEntity;

  })(ShipEntity);

  E.newRandomCivTransport = function() {
    var a, name1, name2, names, transport, v;
    names = ["Alpha Octolindis", "New Dilgan"];
    name1 = H.getRandomListValue(names);
    H.pt1.randomInCircle(C.navPtRadius);
    H.pt1.transXY(C.navPtLocations[name1][0], C.navPtLocations[name1][1]);
    a = H.randAng();
    v = C.transportInitialVelocity + H.randPlusMinus(C.transportInitialVelocity / 2);
    H.pt2.setPolar(v, a);
    H.pt3.setXY(C.luckyBaseLocation[0], C.luckyBaseLocation[1]);
    name2 = H.getRandomListValue(names);
    H.pt4.randomInCircle(C.navPtRadius);
    H.pt4.transXY(C.navPtLocations[name2][0], C.navPtLocations[name2][1]).wrap();
    transport = new TransportShipEntity("drop", "civ", H.pt1, a, H.pt2, 0, H.pt3);
    transport.setAcc(C.transportAcc);
    return transport;
  };

  PlayerShipEntity = (function(superClass) {
    extend(PlayerShipEntity, superClass);

    function PlayerShipEntity(type, faction, pos, a, vel, va) {
      PlayerShipEntity.__super__.constructor.call(this, type, faction, pos, a, vel, va);
      this.isPlayer = true;
      this.beamTriggered = 0;
      this.beamCoolDown = 0;
      this.beamCoolDownMax = C.beamCoolDown;
      this.beamEnergy = 0;
      this.beamEnergyMax = C.beamEnergyMax;
      this.beamEnergyRegen = C.beamEnergyRegen;
      this.tarBeam = B.newTargetingBeam(this);
      this.tarBeamOn = false;
      this.tracBeamOn = true;
      this.tracBeamCoolDown = 0;
      this.fuel = C.shipFuelMax / 2;
      this.fuelMax = C.shipFuelMax;
    }

    PlayerShipEntity.prototype.update = function(dt) {
      if (this.fuel < C.shipFuelMax) {
        if (this.beamEnergy) {
          this.beamEnergy = Math.max(0, this.beamEnergy - dt * this.beamEnergyRegen);
          this.fuel += dt / 2;
        }
      }
      if (this.beamCoolDown) {
        this.beamCoolDown = Math.max(0, this.beamCoolDown - dt);
      }
      if (this.tracBeamCoolDown) {
        this.tracBeamCoolDown = Math.max(0, this.tracBeamCoolDown - dt);
      }
      return PlayerShipEntity.__super__.update.call(this, dt);
    };

    PlayerShipEntity.prototype.heal = function(dt) {
      if (this.damage && this.fuel < C.shipFuelMax) {
        this.damage = Math.max(0, this.damage - this.regen * dt);
        return this.fuel += dt * 2;
      }
    };

    PlayerShipEntity.prototype.draw = function(ctx) {
      if (this.tarBeamOn) {
        this.tarBeam.update(this);
        this.tarBeam.draw(ctx);
      }
      return PlayerShipEntity.__super__.draw.call(this, ctx);
    };

    PlayerShipEntity.prototype.kill = function() {
      this.beamEnergy = this.beamEnergyMax;
      this.damage = this.maxDamage;
      this.fuel = this.fuelMax;
      this.beamCoolDown = C.beamCoolDown;
      this.tracBeamCoolDown = C.tracBeamCoolDown;
      return PlayerShipEntity.__super__.kill.call(this);
    };

    PlayerShipEntity.prototype.canTractor = function() {
      return !this.tracBeamCoolDown && this.beamEnergy < this.beamEnergyMax;
    };

    PlayerShipEntity.prototype.tractorRange = function(obj) {
      var j, len, pt, ref;
      ref = obj.clones;
      for (j = 0, len = ref.length; j < len; j++) {
        pt = ref[j];
        if (this.pos.collide(pt, C.tracBeamRange)) {
          return pt;
        }
      }
      return false;
    };

    PlayerShipEntity.prototype.setJustTractored = function(obj) {
      this.tracBeamCoolDown = C.tracBeamCoolDown;
      return this.beamEnergy += 1;
    };

    PlayerShipEntity.prototype.activateTarBeam = function() {
      this.tarBeam.update(this);
      return this.tarBeamOn = true;
    };

    PlayerShipEntity.prototype.activateBeam = function() {
      if (this.beamTriggered) {
        return this.beamTriggered = 0;
      } else {
        return this.beamTriggered = C.beamBurstCount;
      }
    };

    PlayerShipEntity.prototype.canFire = function() {
      return !this.beamCoolDown && this.beamEnergy < this.beamEnergyMax;
    };

    PlayerShipEntity.prototype.setJustFired = function() {
      this.beamCoolDown = this.beamCoolDownMax;
      this.beamEnergy += 1;
      if (this.beamTriggered) {
        return this.beamTriggered -= 1;
      }
    };

    PlayerShipEntity.prototype.refuel = function(amount) {
      if (amount == null) {
        amount = 0;
      }
      if (amount) {
        return this.fuel = Math.max(0, this.fuel - amount);
      } else {
        return this.fuel = 0;
      }
    };

    PlayerShipEntity.prototype.recharge = function(amount) {
      if (amount == null) {
        amount = 0;
      }
      if (amount) {
        return this.beamEnergy = Math.max(0, this.beamEnergy - amount);
      } else {
        return this.beamEnergy = 0;
      }
    };

    PlayerShipEntity.prototype.repair = function(amount) {
      if (amount == null) {
        amount = 0;
      }
      if (amount) {
        return this.damage = Math.max(0, this.damage - amount);
      } else {
        return this.damage = 0;
      }
    };

    PlayerShipEntity.prototype.restoreFull = function() {
      this.refuel();
      this.recharge();
      return this.repair();
    };

    PlayerShipEntity.prototype.log = function() {
      return console.log(this.pos);
    };

    return PlayerShipEntity;

  })(ShipEntity);

  E.PlayerShip = function() {
    var playerShip;
    playerShip = new PlayerShipEntity("ray", "civ", H.pt1.setXY(-C.tileSize / 4 + 50, C.tileSize / 4 + 50), H.HALFPI, H.pt2.setXY(0, C.shipInitialVeloctity), 0);
    return playerShip;
  };

}).call(this);
