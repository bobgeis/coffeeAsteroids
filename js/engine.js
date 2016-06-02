// Generated by CoffeeScript 1.10.0
(function() {
  "The \"Engine\"\n\nThis should dispatch game input, update, and view";
  var C, E, Engine, H, S,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  E = {};

  _first.offer('engine', E);

  C = _first.request('config');

  H = _first.request('helper');

  S = _first.request('state');

  Engine = (function() {
    Engine.prototype.state = null;

    function Engine(ctx) {
      this.ctx = ctx;
      this.bindEvent = bind(this.bindEvent, this);
      this.ctx.canvas.width = C.winSize.wid;
      this.ctx.canvas.height = C.winSize.hei;
      S.initStates(this);
      this.bindEvent('keydown');
    }

    Engine.prototype.draw = function() {
      "Draw the game state to the canvas";
      return this.state.draw(this.ctx);
    };

    Engine.prototype.update = function(dt) {
      "Update the game state by dt";
      var step;
      step = C.timeStep * 1.5;
      while (dt > step) {
        this.state.update(step);
        dt = dt - step;
      }
      return this.state.update(dt);
    };

    Engine.prototype.input = function(type, data) {
      "Handle user input";
      return this.state.input(type, data);
    };

    Engine.prototype.changeState = function(newState) {
      "Change between game states";
      if (this.state) {
        this.state.exit();
      }
      this.state = newState;
      return this.state.enter();
    };

    Engine.prototype.bindEvent = function(eventType) {
      return window.addEventListener(eventType, (function(_this) {
        return function(eventData) {
          if (_this.state) {
            return _this.state.input(eventType, eventData);
          }
        };
      })(this));
    };

    return Engine;

  })();

  E.Engine = Engine;

}).call(this);
