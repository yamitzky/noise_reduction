window.addEventListener 'load', ->
  showcase = document.getElementById("showcase")
  reduction_flag = true
  sensor = new Chaser()
  sensor.diff = (a, b)->
    # この場合は角度をつかっているので、差の扱いが特殊
    # 通常は a - b で問題ありません。
    result1 = (a - b) % 360
    result2 = result1 - 360
    if Math.abs(result1) < Math.abs(result2)
      return result1
    else
      return result2

  tilt = null

  get_tilt = (acc) ->
    # calc using the acceleration(gravity), not gyro
    y = acc.y
    xz = Math.sqrt(
      Math.pow(acc.x, 2) +
      Math.pow(acc.z, 2)
    )
    xz = -xz if acc.z < 0
    _tilt = Math.atan2(xz, y) / Math.PI * 180
    _tilt -= 360 if _tilt > 90
    return _tilt

  window.addEventListener 'devicemotion', (e)->
    # called when acceleration changed
    tilt = get_tilt(e.accelerationIncludingGravity)
    if reduction_flag
      sensor.update(tilt)
    else
      sensor.x0 = sensor.x = tilt
  
  input_reduction = document.getElementById('reduction')
  input_reduction.addEventListener 'change', ->
    reduction_flag = this.checked

  input_angle = document.getElementById("angle")
  input_angle.addEventListener 'change', ->
    angle = parseInt(this.value)
    if reduction_flag
      sensor.update(angle)
    else
      sensor.x0 = sensor.x = angle
  sensor.update(270)

  setInterval ->
    tilt = sensor.get()
    showcase.setAttribute "style",
      ["-webkit-transform:rotateX(", tilt+90, "deg)"].join("")
  , 1000/24
