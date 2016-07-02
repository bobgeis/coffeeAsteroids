// Generated by CoffeeScript 1.10.0
(function() {
  "Model";
  var A, B, C, E, H, M, Model, Q, U, isAlive;

  M = {};

  _first.offer('model', M);

  A = _first.request('assets');

  B = _first.request('beam');

  C = _first.request('config');

  E = _first.request('entity');

  H = _first.request('helper');

  Q = _first.request('quest');

  U = _first.request('hud');

  Model = (function() {
    function Model() {
      "Build the initial state.";
      var i, j, len, len1, name, ref, ref1;
      this.player = null;
      this.gameOver = false;
      this.spawnTimer = 0;
      this.changeMode = 0;
      this.quest = [];
      this.bg = [];
      this.bases = [];
      this.ships = [];
      this.boats = [];
      this.rocks = [];
      this.booms = [];
      this.flashes = [];
      this.shots = [];
      this.loot = [];
      this.hud = [];
      this.navPts = [];
      this.mousePts = [];
      this.player = E.PlayerShip();
      this.ships.push(this.player);
      this.flash(this.player);
      this.rocks.push(new E.RandRock());
      this.bases.push(new E.LuckyBase());
      this.bases.push(new E.BuildBase());
      this.bg.push(new E.BgTile());
      this.hud.push(new U.shipShieldBar(this.player));
      this.hud.push(new U.shipBeamEnergyBar(this.player));
      this.hud.push(new U.shipFuelBar(this.player));
      this.hud.push(new U.dockMessage(this.player));
      ref = C.navPtNames;
      for (i = 0, len = ref.length; i < len; i++) {
        name = ref[i];
        this.navPts.push(E.newNavPt(name));
      }
      ref1 = C.mousePtNames;
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        name = ref1[j];
        this.navPts.push(E.newNavPt(name));
      }
      this.cargo = {
        crystal: [0, 0, 0],
        lifepod: [0, 0, 0],
        mousepod: [0, 0, 0]
      };
      this.hud.push(new U.newCargoMonitor(this.cargo));
    }

    Model.prototype.getEntityLists = function() {
      return [this.bg, this.bases, this.navPts, this.mousePts, this.loot, this.boats, this.shots, this.rocks, this.ships, this.booms, this.flashes, this.hud];
    };

    Model.prototype.clearEntityLists = function() {
      var i, len, list, ref, results;
      ref = this.getEntityLists;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        list = ref[i];
        results.push(list.length = 0);
      }
      return results;
    };

    Model.prototype.update = function(dt) {
      "update by dt";
      var base, dmg, i, item, j, k, l, len, len1, len2, len3, len4, len5, len6, len7, len8, len9, list, loot, m, n, o, p, pt, q, r, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, ref8, rock, ship, shot;
      ref = this.getEntityLists();
      for (i = 0, len = ref.length; i < len; i++) {
        list = ref[i];
        for (j = 0, len1 = list.length; j < len1; j++) {
          item = list[j];
          item.update(dt);
        }
      }
      ref1 = this.ships;
      for (k = 0, len2 = ref1.length; k < len2; k++) {
        ship = ref1[k];
        if (ship.beamTriggered && ship.canFire()) {
          this.fireDisruptor(ship);
          ship.setJustFired();
        }
        if (ship.tracBeamOn) {
          ref2 = this.loot;
          for (l = 0, len3 = ref2.length; l < len3; l++) {
            loot = ref2[l];
            if (ship.canTractor()) {
              pt = ship.tractorRange(loot);
              if (pt) {
                this.tracBeam(ship.pos, pt);
                loot.kill();
                ship.setJustTractored(loot);
                this.pickupLoot(loot);
              }
            }
          }
        }
        ref3 = this.rocks;
        for (m = 0, len4 = ref3.length; m < len4; m++) {
          rock = ref3[m];
          if (ship.collide(rock)) {
            dmg = Math.abs(ship.bounce(rock));
            if (ship.applyDamage(dmg * C.rockCollisionDamage)) {
              this.explode(ship);
              ship.kill();
              this.createLifepods(ship);
            }
          }
        }
        if (ship.warped) {
          this.shipWarped(ship);
        }
        ship.canDock = false;
        ref4 = this.bases;
        for (n = 0, len5 = ref4.length; n < len5; n++) {
          base = ref4[n];
          if (ship.collide(base)) {
            ship.canDock = true;
            if (ship.docked) {
              if (ship.isPlayer) {
                this.playerDocked(base);
              } else {
                this.shipDocked(ship, base);
              }
            }
          }
        }
      }
      ref5 = this.bases;
      for (o = 0, len6 = ref5.length; o < len6; o++) {
        base = ref5[o];
        ref6 = this.rocks;
        for (p = 0, len7 = ref6.length; p < len7; p++) {
          rock = ref6[p];
          if (base.collide(rock)) {
            rock.bounce(base);
          }
        }
      }
      ref7 = this.shots;
      for (q = 0, len8 = ref7.length; q < len8; q++) {
        shot = ref7[q];
        if (shot.damaging) {
          ref8 = this.rocks;
          for (r = 0, len9 = ref8.length; r < len9; r++) {
            rock = ref8[r];
            if (shot.hit(rock)) {
              if (rock.applyDamage(shot.getDamage())) {
                rock.kill();
                this.explode(rock);
                this.calveRock(rock);
                this.createCrystal(rock);
              }
            }
          }
        }
      }
      this.maybeTimerSpawn();
      this.shots = _.filter(this.shots, isAlive);
      this.rocks = _.filter(this.rocks, isAlive);
      this.ships = _.filter(this.ships, isAlive);
      this.booms = _.filter(this.booms, isAlive);
      this.loot = _.filter(this.loot, isAlive);
      this.flashes = _.filter(this.flashes, isAlive);
      if (!this.player.alive) {
        this.gameOver = true;
        return this.changeMode = 1;
      }
    };

    Model.prototype.draw = function(ctx) {
      "Draw the model.";
      var entity, i, len, list, ref, results;
      this.player.centerCamera();
      ref = this.getEntityLists();
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        list = ref[i];
        results.push((function() {
          var j, len1, results1;
          results1 = [];
          for (j = 0, len1 = list.length; j < len1; j++) {
            entity = list[j];
            if (!entity.draw) {
              console.log(entity);
            }
            results1.push(entity.draw(ctx));
          }
          return results1;
        })());
      }
      return results;
    };

    Model.prototype.command = function(cmd) {
      if (cmd === 1) {
        return this.player.va = C.shipAngVel;
      } else if (cmd === 2) {
        return this.player.va = -C.shipAngVel;
      } else if (cmd === 3) {
        return this.player.setAcc(C.shipAcc);
      } else if (cmd === 4) {
        return this.player.setAcc(-C.shipRetro);
      } else if (cmd === 5) {
        this.player.activateBeam();
        return this.player.tarBeamOn = false;
      } else if (cmd === 6) {
        return this.player.activateTarBeam();
      } else if (cmd === 7) {
        return this.player.beginDocking();
      } else if (cmd === 11) {
        return this.player.va = 0;
      } else if (cmd === 13) {
        return this.player.setAcc(0);
      } else if (cmd === 17) {
        return this.player.stopDocking();
      } else if (cmd === 97) {
        return this.player.restoreFull();
      } else if (cmd === 98) {
        return this.log();
      } else if (cmd === 99) {
        this.player.kill();
        this.explode(this.player);
        return this.createLifepods(this.player);
      }
    };

    Model.prototype.fireDisruptor = function(ship) {
      return this.shots.push(B.newDisruptor(ship));
    };

    Model.prototype.calveRock = function(rock) {
      var calf, calves, i, len, results;
      calves = E.calveRock(rock);
      if (calves) {
        results = [];
        for (i = 0, len = calves.length; i < len; i++) {
          calf = calves[i];
          results.push(this.rocks.push(calf));
        }
        return results;
      }
    };

    Model.prototype.createCrystal = function(rock) {
      if (E.spawnCrystalCheck(rock)) {
        return this.loot.push(E.newCrystalOnObj(rock));
      }
    };

    Model.prototype.createLifepods = function(ship) {
      var i, len, pod, ref, results;
      ref = E.newLifepodsOnObj(ship);
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        pod = ref[i];
        results.push(this.loot.push(pod));
      }
      return results;
    };

    Model.prototype.explode = function(obj) {
      return this.booms.push(E.newExplosionOnObj(obj));
    };

    Model.prototype.flash = function(obj) {
      return this.flashes.push(E.newFlashOnObj(obj));
    };

    Model.prototype.tracBeam = function(pos1, pos2) {
      return this.flashes.push(B.newTractorBeam(pos1, pos2));
    };

    Model.prototype.maybeTimerSpawn = function() {
      var i, len, name, ref, results, rock;
      ref = C.mousePtNames;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        name = ref[i];
        if (Math.random() < C.navPtSpawnRates[name]) {
          rock = E.RockFromNavName(name);
          this.rocks.push(rock);
          results.push(this.flash(rock));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    Model.prototype.pickupLoot = function(loot) {
      var type;
      type = loot.type;
      return this.cargo[type][0] += 1;
    };

    Model.prototype.playerDocked = function(base) {
      this.player.docked = false;
      this.player.docking = 0;
      this.player.refuel();
      this.changeMode = 2;
      if (base.name === "lucky") {
        this.cargo.lifepod[1] += this.cargo.lifepod[0];
        this.cargo.lifepod[0] = 0;
      } else {
        this.cargo.crystal[1] += this.cargo.crystal[0];
        this.cargo.crystal[0] = 0;
      }
      this.quest = Q.getNextQuest(base.name);
      this.cargo.mousepod[1] += this.cargo.mousepod[0];
      this.cargo.mousepod[0] = 0;
      return this.flashes.push(E.newTracPulseOnObj(this.player));
    };

    Model.prototype.shipDocked = function(ship, base) {
      this.flashes.push(E.newTracPulseOnObj(ship));
    };

    Model.prototype.shipWarped = function(ship) {};

    Model.prototype.log = function() {
      this.player.log();
      return console.log(this.cargo);
    };

    return Model;

  })();

  M.Model = Model;

  isAlive = function(obj) {
    return obj.alive;
  };

}).call(this);
