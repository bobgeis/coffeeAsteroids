// Generated by CoffeeScript 1.10.0
(function() {
  "Beam\n\n";
  var A, B, Beam, C, DisruptorBeam, H,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  B = {};

  _first.offer('beam', B);

  A = _first.request('assets');

  C = _first.request('config');

  H = _first.request('helper');

  Beam = (function() {
    function Beam(line) {
      var i;
      this.line = line;
      this.alive = true;
      this.clones = (function() {
        var j, results;
        results = [];
        for (i = j = 0; j < 9; i = ++j) {
          results.push(H.newLine());
        }
        return results;
      })();
      this.setClones();
      this.wid = 0;
      this.color = "rgba(0, 0, 0, 1)";
    }

    Beam.prototype.getWidth = function() {
      return this.wid;
    };

    Beam.prototype.getColor = function() {
      return this.color;
    };

    Beam.prototype.isAlive = function() {
      return this.alive;
    };

    Beam.prototype.kill = function() {
      return this.alive = false;
    };

    Beam.prototype.update = function(dt) {
      return this.alive;
    };

    Beam.prototype.draw = function(ctx) {
      var clone, j, len, ref, results;
      if (!this.alive) {
        return;
      }
      ref = this.clones;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        clone = ref[j];
        if (H.onScreenBeam(clone)) {
          results.push(H.drawLineEntity(ctx, clone, this.wid, this.color));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    Beam.prototype.setClones = function() {
      var s, start, stop;
      s = C.tileSize;
      start = this.line.start;
      stop = this.line.stop;
      this.clones[0].setLineOffset(start, stop, -s, -s);
      this.clones[1].setLineOffset(start, stop, -s, 0);
      this.clones[2].setLineOffset(start, stop, -s, s);
      this.clones[3].setLineOffset(start, stop, 0, -s);
      this.clones[4].setLineOffset(start, stop, 0, 0);
      this.clones[5].setLineOffset(start, stop, 0, s);
      this.clones[6].setLineOffset(start, stop, s, -s);
      this.clones[7].setLineOffset(start, stop, s, 0);
      this.clones[8].setLineOffset(start, stop, s, s);
      return this.clones;
    };

    Beam.prototype.hit = function(pos, r) {
      var clone, j, len, ref;
      ref = this.clones;
      for (j = 0, len = ref.length; j < len; j++) {
        clone = ref[j];
        if (clone.hit(pos, r)) {
          return true;
        }
      }
      return false;
    };

    return Beam;

  })();

  B.Beam = Beam;

  DisruptorBeam = (function(superClass) {
    extend(DisruptorBeam, superClass);

    function DisruptorBeam(pos, r, a) {
      DisruptorBeam.__super__.constructor.call(this, H.newLineRA(pos, r, a));
      this.phases = C.beamColors.length;
      this.damaging = true;
      this.age = 0;
      this.damage = 0;
      this.wid = C.beamWidths[0];
      this.color = C.beamColors[0];
    }

    DisruptorBeam.prototype.getDamage = function() {
      return this.damage;
    };

    DisruptorBeam.prototype.setDamage = function(dmg) {
      return this.damage = dmg;
    };

    DisruptorBeam.prototype.isDamaging = function() {
      return this.damaging;
    };

    DisruptorBeam.prototype.update = function(dt) {
      var phase;
      phase = Math.floor(this.age / C.beamDuration * this.phases);
      this.wid = C.beamWidths[phase];
      this.color = C.beamColors[phase];
      if (this.age > 0) {
        this.damaging = false;
      }
      if (this.age > C.beamDuration) {
        return this.alive = false;
      }
      this.age += dt;
      return DisruptorBeam.__super__.update.call(this, dt);
    };

    DisruptorBeam.prototype.hit = function(obj) {
      if (!this.damaging) {
        return false;
      } else {
        return DisruptorBeam.__super__.hit.call(this, obj.pos, obj.r + this.wid);
      }
    };

    return DisruptorBeam;

  })(Beam);

  B.DisruptorBeam = DisruptorBeam;

  B.newDisruptor = function(obj) {
    var pew;
    pew = new DisruptorBeam(obj.pos, C.beamRange, -obj.a);
    pew.setDamage(C.beamDamage);
    return pew;
  };

}).call(this);
