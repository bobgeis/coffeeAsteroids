// Generated by CoffeeScript 1.10.0
(function() {
  "Helper\n\nSome useful functions and constants\n\nclass Point\n	This is a point class, {x,y}, with lots of methods.\n	Many of the methods modify the point they are called on,\n	this was intended as an exercise in avoiding the creation\n	of new objects.  In principle this would reduce the frequency\n	of frame rate hits caused by garbage collection, but it\n	is unlikely to have a major impact on a game as simple as\n	this one, so it's mostly just an exercise.\n\nclass Line\n	This is a class for line segments.\n";
  var C, H, HALFPI, Line, PI, Point, TAU, TWOPI, cam, camBR, camTL, line, makeClones, pt, pt0, pt1, pt2, pt3, pt4, pt5, pt6, pt7, pt8, pt9, t1, t2, t3, testCount, testHelperOn;

  H = {};

  _first.offer('helper', H);

  C = _first.request('config');

  H.PI = PI = Math.PI;

  H.TWOPI = TWOPI = H.PI * 2;

  H.TAU = TAU = H.TWOPI;

  H.HALFPI = HALFPI = H.PI / 2;

  H.randInt = function(max) {
    return Math.floor(Math.random() * max);
  };

  H.randIntRange = function(min, max) {
    return min + Math.floor(Math.random() * (max - min));
  };

  H.randAng = function(a) {
    if (a == null) {
      a = TAU;
    }
    return Math.random() * a;
  };

  H.randPlusMinus = function(x) {
    return Math.random() * 2 * x - x;
  };

  H.clear = function(list) {
    return list.length = 0;
  };

  H.remove = function(list, item) {
    var i;
    i = list.indexOf(item);
    if (i !== -1) {
      return list.splice(i, 1);
    }
  };

  H.flipList = function(list) {
    var item, k, l, len;
    l = [];
    for (k = 0, len = list.length; k < len; k++) {
      item = list[k];
      l.push(item);
    }
    return l.reverse();
  };

  H.getRandomListValue = function(list) {
    return list[H.randInt(list.length)];
  };

  H.getRandomObjValue = function(obj) {
    return obj[H.getRandomListValue(Object.keys(obj))];
  };

  Point = (function() {
    function Point(x1, y1) {
      this.x = x1;
      this.y = y1;
      this;
    }

    Point.prototype.copyPos = function() {
      return new Point(this.x, this.y);
    };

    Point.prototype.setPos = function(pos) {
      this.x = pos.x;
      this.y = pos.y;
      return this;
    };

    Point.prototype.setPosOffset = function(pos, x, y) {
      this.x = pos.x + x;
      this.y = pos.y + y;
      return this;
    };

    Point.prototype.add = function(pos) {
      this.x += pos.x;
      this.y += pos.y;
      return this;
    };

    Point.prototype.sub = function(pos) {
      this.x -= pos.x;
      this.y -= pos.y;
      return this;
    };

    Point.prototype.scale = function(scalar) {
      this.x *= scalar;
      this.y *= scalar;
      return this;
    };

    Point.prototype.flip = function() {
      this.x = -this.x;
      this.y = -this.y;
      return this;
    };

    Point.prototype.dot = function(pos) {
      return this.x * pos.x + this.y * pos.y;
    };

    Point.prototype.cross = function(pos) {
      return this.x * pos.y - this.y * pos.x;
    };

    Point.prototype.sum = function(pos1, pos2) {
      this.x = pos2.x + pos1.x;
      this.y = pos2.y + pos1.y;
      return this;
    };

    Point.prototype.diff = function(pos1, pos2) {
      this.x = pos2.x - pos1.x;
      this.y = pos2.y - pos1.y;
      return this;
    };

    Point.prototype.setXY = function(x, y) {
      this.x = x;
      this.y = y;
      return this;
    };

    Point.prototype.transXY = function(x, y) {
      this.x += x;
      this.y += y;
      return this;
    };

    Point.prototype.setPolar = function(r, a) {
      this.x = r * Math.cos(a);
      this.y = r * Math.sin(a);
      return this;
    };

    Point.prototype.transPolar = function(r, a) {
      this.x += r * Math.cos(a);
      this.y += r * Math.sin(a);
      return this;
    };

    Point.prototype.r = function() {
      return Math.hypot(this.x, this.y);
    };

    Point.prototype.a = function() {
      return Math.atan2(this.y, this.x);
    };

    Point.prototype.setR = function(r) {
      return this.setPolar(r, this.a());
    };

    Point.prototype.setA = function(a) {
      return this.setPolar(this.r(), a);
    };

    Point.prototype.unitVector = function(a) {
      return this.setPolar(1, a);
    };

    Point.prototype.rotate = function(a) {
      return this.setA(a + this.a());
    };

    Point.prototype.distance = function(pos) {
      return Math.hypot(pos.x - this.x, pos.y - this.y);
    };

    Point.prototype.collide = function(pos, r) {
      var dx, dy;
      dx = pos.x - this.x;
      dy = pos.y - this.y;
      return dx * dx + dy * dy <= r * r;
    };

    Point.prototype.getFaceAngle = function(pos) {
      return Math.atan2(pos.y - this.y, pos.x - this.x);
    };

    Point.prototype.inBox = function(xm, xM, ym, yM) {
      return this.x < xM && this.x > xm && this.y < yM && this.y > ym;
    };

    Point.prototype.random = function(xMax, yMax) {
      this.x = H.randInt(xMax);
      this.y = H.randInt(yMax);
      return this;
    };

    Point.prototype.randomInBox = function(xm, xM, ym, yM) {
      this.x = H.randIntRange(xm, xM);
      this.y = H.randIntRange(ym, yM);
      return this;
    };

    Point.prototype.randomInCircle = function(rM) {
      return this.setPolar(Math.random() * rM, H.randAng(TAU));
    };

    Point.prototype.randomOnCircle = function(r) {
      return this.setPolar(r, H.randAng(TAU));
    };

    return Point;

  })();

  H.Point = Point;

  H.newPointPolar = function(r, a) {
    return new Point(r * Math.cos(a, r * Math.sin(a)));
  };

  H.newPt = function() {
    return new Point(0, 0);
  };

  H.pt = pt = new Point(0, 0);

  H.pt0 = pt0 = new Point(0, 0);

  H.pt1 = pt1 = new Point(0, 0);

  H.pt2 = pt2 = new Point(0, 0);

  H.pt3 = pt3 = new Point(0, 0);

  H.pt4 = pt4 = new Point(0, 0);

  H.pt5 = pt5 = new Point(0, 0);

  H.pt6 = pt6 = new Point(0, 0);

  H.pt7 = pt7 = new Point(0, 0);

  H.pt8 = pt8 = new Point(0, 0);

  H.pt9 = pt9 = new Point(0, 0);

  H.origin = new Point(0, 0);

  H.blink = function(pos, r) {
    pt1.randomOnCircle(r);
    return pos.add(pt1);
  };

  Line = (function() {
    function Line(start, stop) {
      this.start = start.copyPos();
      this.stop = stop.copyPos();
      this.updateLA();
    }

    Line.prototype.updateLA = function() {
      this.updateL();
      return this.updateA();
    };

    Line.prototype.updateL = function() {
      return this.l = this.start.distance(this.stop);
    };

    Line.prototype.updateA = function() {
      return this.a = this.start.getFaceAngle(this.stop);
    };

    Line.prototype.setLine = function(start, stop) {
      this.start.setPos(start);
      this.stop.setPos(stop);
      this.updateLA();
      return this;
    };

    Line.prototype.setLineOffset = function(start, stop, x, y) {
      this.start.setPosOffset(start, x, y);
      this.stop.setPosOffset(stop, x, y);
      this.updateLA();
      return this;
    };

    Line.prototype.setLineFromLine = function(line) {
      this.start.setPos(line.start);
      this.stop.setPos(line.stop);
      this.updateLA();
      return this;
    };

    Line.prototype.setLineFromLineOffset = function(line, x, y) {
      this.start.setPosOffset(line.start, x, y);
      this.stop.setPosOffset(line.stop, x, y);
      this.updateLA();
      return this;
    };

    Line.prototype.distance = function(pos) {
      pt1.diff(this.start, this.stop);
      pt2.diff(this.start, pos);
      return Math.abs((pt1.cross(pt2)) / this.l);
    };

    Line.prototype.inSegment = function(pos) {
      var proj;
      pt1.diff(this.start, this.stop);
      pt2.diff(this.start, pos);
      proj = (pt1.dot(pt2)) / this.l;
      if (proj < 0) {
        return false;
      }
      if (proj > this.l) {
        return false;
      } else {
        return true;
      }
    };

    Line.prototype.hit = function(pos, r) {
      var d;
      if (this.inSegment(pos)) {
        d = this.distance(pos);
        return d < r;
      } else if (this.start.collide(pos, r)) {
        return true;
      } else if (this.stop.collide(pos, r)) {
        return true;
      } else {
        return false;
      }
    };

    Line.prototype.draw = function(ctx, width, color, offset) {
      var dx, dy;
      ctx.lineWidth = width;
      ctx.strokeStyle = color;
      ctx.beginPath();
      if (offset) {
        dx = offset.x;
        dy = offset.y;
      } else {
        dx = 0;
        dy = 0;
      }
      ctx.moveTo(this.start.x - dx, this.start.y - dy);
      ctx.lineTo(this.stop.x - dx, this.stop.y - dy);
      ctx.stroke();
      return ctx.closePath();
    };

    return Line;

  })();

  H.newLineSS = function(start, stop) {
    return new Line(start, stop);
  };

  H.newLineRA = function(start, r, a) {
    return new Line(start, pt.setPolar(r, a).add(start));
  };

  H.newLine = function() {
    return new Line(H.origin, H.origin);
  };

  H.updateLineFromPos = function(line, pos, r, a) {
    line.start.setPos(pos);
    line.start.setPolar(r, a).add(line.start);
    line.l = r;
    return line.a = a;
  };

  H.line = line = new Line(pt1, pt2);

  H.cam = cam = new Point(0, 0);

  H.camTL = camTL = new Point(0, 0);

  H.camBR = camBR = new Point(0, 0);

  H.updateCamera = function(pos) {
    cam.setPos(pos);
    camTL.setXY(pos.x - C.halfWinWid, pos.y - C.halfWinHei);
    return camBR.setXY(pos.x + C.halfWinWid, pos.y + C.halfWinHei);
  };

  H.onScreen = function(pos) {
    return pos.inBox(camTL.x, camBR.x, camTL.y, camBR.y);
  };

  H.onScreenEntity = function(pos, r) {
    return pos.inBox(camTL.x - r, camBR.x + r, camTL.y - r, camBR.y + r);
  };

  H.onScreenBeam = function(line) {
    return H.onScreen(line.start || H.onScreen(line.stop));
  };

  H.createCanvas = function() {
    return document.createElement("canvas");
  };

  H.drawImg = function(ctx, top, x, y, a) {
    var img;
    img = top.canvas;
    if (a) {
      ctx.save();
      ctx.translate(x, y);
      ctx.rotate(-a);
      ctx.drawImage(img, -Math.floor(img.width / 2), -Math.floor(img.height / 2));
      return ctx.restore();
    } else {
      return ctx.drawImage(img, x - Math.floor(img.width / 2), y - Math.floor(img.height / 2));
    }
  };

  H.drawImgRot = function(ctx, top, x, y, a) {
    var img;
    ctx.save();
    img = top.canvas;
    ctx.translate(x, y);
    ctx.rotate(-a);
    ctx.drawImage(img, -Math.floor(img.width / 2), -Math.floor(img.height / 2));
    return ctx.restore();
  };

  H.drawImgStill = function(ctx, top, x, y) {
    var img;
    img = top.canvas;
    return ctx.drawImage(img, x - Math.floor(img.width / 2), y - Math.floor(img.height / 2));
  };

  H.drawEntity = function(ctx, top, pos, a) {
    var dx, dy;
    dx = pos.x - camTL.x;
    dy = pos.y - camTL.y;
    return H.drawImg(ctx, top, dx, dy, a);
  };

  H.drawLineEntity = function(ctx, line, wid, color) {
    return line.draw(ctx, wid, color, camTL);
  };

  makeClones = function() {
    var row;
    row = function() {
      return [new Point(0, 0), new Point(0, 0), new Point(0, 0)];
    };
    return [row(), row(), row()];
  };

  H.clones = makeClones();

  H.setClones = function(pos) {
    var d, i, j, k, len, len1, m, ref, row, s, x, y;
    s = C.tileSize;
    x = pos.x;
    y = pos.y;
    d = function(i) {
      if (i === 0) {
        return -s;
      } else if (i === 1) {
        return 0;
      } else {
        return s;
      }
    };
    ref = H.clones;
    for (i = k = 0, len = ref.length; k < len; i = ++k) {
      row = ref[i];
      for (j = m = 0, len1 = row.length; m < len1; j = ++m) {
        pt = row[j];
        pt.setXY(x + d(i), y + d(j));
      }
    }
    return H.clones;
  };

  H.cloneCollide = function(pos1, pos2, r) {
    var clone, k, len, len1, m, ref, row;
    ref = H.setClones(pos1);
    for (k = 0, len = ref.length; k < len; k++) {
      row = ref[k];
      for (m = 0, len1 = row.length; m < len1; m++) {
        clone = row[m];
        if (clone.collide(pos2, r)) {
          return clone;
        }
      }
    }
    return false;
  };

  testHelperOn = false;

  if (testHelperOn) {
    t1 = Date.now();
    testCount = 0;
    while (testCount < 100000000) {
      testCount++;
      new Point(0, 0);
    }
    t2 = Date.now();
    testCount = 0;
    while (testCount < 100000000) {
      testCount++;
      H.pt.setXY(0, 0);
    }
    t3 = Date.now();
    console.log("new objs: " + (t2 - t1));
    console.log("reuse objs: " + (t3 - t2));
  }

}).call(this);
