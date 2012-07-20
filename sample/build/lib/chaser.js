(function() {
  var Chaser;

  Chaser = (function() {

    function Chaser() {
      this.x0 = null;
      this.spring = 0.1;
      this.resistance = 10;
      this.mass = 1000;
      this.vel = 0;
      this.x = 0;
      this.last_date = null;
    }

    Chaser.prototype.update = function(distance) {
      return this.x0 = distance;
    };

    Chaser.prototype.diff = function(a, b) {
      return a - b;
    };

    Chaser.prototype.get = function() {
      var f, time, x;
      x = this.diff(this.x0, this.x);
      time = this.offset_time();
      f = this.spring * x - this.resistance * this.vel;
      this.vel += (f / this.mass) * time;
      this.x += this.vel * time;
      return this.x;
    };

    Chaser.prototype.offset_time = function() {
      var now_date, _last_date;
      if (this.last_date) {
        now_date = new Date();
        _last_date = this.last_date;
        this.last_date = now_date;
        return now_date - _last_date;
      } else {
        this.last_date = new Date();
        return 0;
      }
    };

    return Chaser;

  })();

  window.Chaser = Chaser;

}).call(this);
