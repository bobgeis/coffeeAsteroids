// Generated by CoffeeScript 1.10.0
(function() {
  "Entity\n\nAn entity is a thing in the game world.\nThe player ship, rocks, shots, etc are all entities.";
  var A, B, C, DestructibleEntity, E, Entity, H, MovingEntity,
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

  MovingEntity = (function(superClass) {
    extend(MovingEntity, superClass);

    MovingEntity.prototype.acc = 0;

    MovingEntity.prototype.r = 0;

    MovingEntity.prototype.m = 0;

    MovingEntity.prototype.thrust = false;

    MovingEntity.prototype.drag = false;

    function MovingEntity(pos, a1, vel, va1) {
      this.a = a1;
      this.va = va1;
      MovingEntity.__super__.constructor.call(this, pos);
      this.vel = vel.copyPos();
    }

    MovingEntity.prototype.update = function(dt) {
      this.pos.transXY(this.vel.x * dt, -this.vel.y * dt);
      this.a += this.va * dt;
      if (this.thrust) {
        this.vel.transPolar(this.acc, this.a);
      }
      if (this.drag) {
        this.vel.scale(1 - this.drag * dt);
      }
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
      if (this.pos.x < -C.tileSize / 2) {
        this.pos.x += C.tileSize;
      }
      if (this.pos.x > C.tileSize / 2) {
        this.pos.x -= C.tileSize;
      }
      if (this.pos.y < -C.tileSize / 2) {
        this.pos.y += C.tileSize;
      }
      if (this.pos.y > C.tileSize / 2) {
        return this.pos.y -= C.tileSize;
      }
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
      if (this.damage) {
        this.damage = Math.max(0, this.damage - this.regen);
      }
      return DestructibleEntity.__super__.update.call(this, dt);
    };

    DestructibleEntity.prototype.setRegen = function(reg) {
      return this.regen = reg;
    };

    DestructibleEntity.prototype.setMaxDmg = function(maxDmg) {
      return this.maxDamage = maxDmg;
    };

    DestructibleEntity.prototype.applyDamage = function(dmg) {
      this.damage += dmg;
      return this.isDestroyed();
    };

    DestructibleEntity.prototype.isDestroyed = function() {
      return this.damage > this.maxDamage;
    };

    return DestructibleEntity;

  })(MovingEntity);

  E.DestructibleEntity = DestructibleEntity;

  E.BgTile = function() {
    var bgTile;
    bgTile = new Entity(H.origin);
    bgTile.setImg(A.img.bg.tile);
    return bgTile;
  };

  E.LuckyBase = function() {
    var luckyBase, p;
    p = -900;
    luckyBase = new MovingEntity(H.pt.setXY(0, p), 0, H.origin, 0);
    luckyBase.setImg(A.img.ship.baselucky);
    luckyBase.setR(luckyBase.r_img);
    luckyBase.setM(C.baseMass);
    return luckyBase;
  };

  E.BuildBase = function() {
    var buildBase, p;
    p = C.tileSize / 2 - 20;
    buildBase = new MovingEntity(H.pt.setXY(p, p), 0, H.origin, 0);
    buildBase.setImg(A.img.ship.basebuild);
    buildBase.setR(buildBase.r_img);
    buildBase.setM(C.baseMass);
    return buildBase;
  };

  E.PlayerShip = function() {
    var playerShip;
    playerShip = new DestructibleEntity(H.origin, H.HALFPI, H.pt.setXY(0, 0.5), 0);
    playerShip.setImg(A.img.ship.rayciv);
    playerShip.setR(playerShip.r_img);
    playerShip.setM(C.shipMass);
    playerShip.drag = C.shipDrag;
    playerShip.setMaxDmg(C.shipShields);
    playerShip.setRegen(C.shipRegen);
    return playerShip;
  };

  E.RandRock = function() {
    var p, rock;
    p = C.tileSize / 2;
    rock = new DestructibleEntity(H.pt1.randomInBox(-p, p, -p, p), 0, H.pt2.randomInCircle(C.rockVel), 0);
    rock.setImg(A.img.space.r0);
    rock.setR(rock.r_img);
    rock.setM(C.rockMass);
    rock.setMaxDmg(C.rockArmor);
    rock.setRegen(C.rockRegen);
    return rock;
  };

  E.spawnRock = function(dt) {
    return Math.random() < C.rockSpawnChance * dt;
  };

}).call(this);
