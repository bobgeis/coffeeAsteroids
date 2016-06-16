// Generated by CoffeeScript 1.10.0
(function() {
  "Model";
  var A, C, E, H, M, Model;

  M = {};

  _first.offer('model', M);

  A = _first.request('assets');

  C = _first.request('config');

  E = _first.request('entity');

  H = _first.request('helper');

  Model = (function() {
    Model.prototype.player = null;

    Model.prototype.bg = [];

    Model.prototype.bases = [];

    Model.prototype.ships = [];

    Model.prototype.rocks = [];

    Model.prototype.booms = [];

    Model.prototype.shots = [];

    Model.prototype.loot = [];

    function Model() {
      "Build the initial state.";
      this.entitiesSuperList = [this.bg, this.bases, this.loot, this.shots, this.rocks, this.ships, this.booms];
      this.player = E.PlayerShip();
      this.ships.push(this.player);
      this.rocks.push(new E.RandRock());
      this.bases.push(new E.LuckyBase());
      this.bases.push(new E.BuildBase());
      this.bg.push(new E.BgTile());
    }

    Model.prototype.update = function(dt) {
      "update by dt";
      var i, item, j, len, len1, list, ref;
      ref = this.entitiesSuperList;
      for (i = 0, len = ref.length; i < len; i++) {
        list = ref[i];
        for (j = 0, len1 = list.length; j < len1; j++) {
          item = list[j];
          item.update(dt);
        }
      }
      if (E.spawnRock(dt)) {
        this.rocks.push(new E.RandRock());
        return console.log("" + this.rocks.length);
      }
    };

    Model.prototype.draw = function(ctx) {
      "Draw the model.";
      var i, item, len, list, ref, results;
      this.player.centerCamera();
      ref = this.entitiesSuperList;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        list = ref[i];
        results.push((function() {
          var j, len1, results1;
          results1 = [];
          for (j = 0, len1 = list.length; j < len1; j++) {
            item = list[j];
            results1.push(item.draw(ctx));
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
      } else if (cmd === 11) {
        return this.player.va = 0;
      } else if (cmd === 13) {
        return this.player.setAcc(0);
      }
    };

    return Model;

  })();

  M.Model = Model;

}).call(this);
