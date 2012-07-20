(function() {

  window.addEventListener('load', function() {
    var get_tilt, input_angle, input_reduction, reduction_flag, sensor, showcase, tilt;
    showcase = document.getElementById("showcase");
    reduction_flag = true;
    sensor = new Chaser();
    sensor.diff = function(a, b) {
      var result1, result2;
      result1 = (a - b) % 360;
      result2 = result1 - 360;
      if (Math.abs(result1) < Math.abs(result2)) {
        return result1;
      } else {
        return result2;
      }
    };
    tilt = null;
    get_tilt = function(acc) {
      var xz, y, _tilt;
      y = acc.y;
      xz = Math.sqrt(Math.pow(acc.x, 2) + Math.pow(acc.z, 2));
      if (acc.z < 0) {
        xz = -xz;
      }
      _tilt = Math.atan2(xz, y) / Math.PI * 180;
      if (_tilt > 90) {
        _tilt -= 360;
      }
      return _tilt;
    };
    window.addEventListener('devicemotion', function(e) {
      tilt = get_tilt(e.accelerationIncludingGravity);
      if (reduction_flag) {
        return sensor.update(tilt);
      } else {
        return sensor.x0 = sensor.x = tilt;
      }
    });
    input_reduction = document.getElementById('reduction');
    input_reduction.addEventListener('change', function() {
      return reduction_flag = this.checked;
    });
    input_angle = document.getElementById("angle");
    input_angle.addEventListener('change', function() {
      var angle;
      angle = parseInt(this.value);
      if (reduction_flag) {
        return sensor.update(angle);
      } else {
        return sensor.x0 = sensor.x = angle;
      }
    });
    sensor.update(270);
    return setInterval(function() {
      tilt = sensor.get();
      return showcase.setAttribute("style", ["-webkit-transform:rotateX(", tilt + 90, "deg)"].join(""));
    }, 1000 / 24);
  });

}).call(this);
