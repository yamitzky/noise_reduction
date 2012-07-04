window.addEventListener 'load', ->
  rotation = 0
  first_updown = null # to calculate updown-tilting offset
  last_date = new Date()
  showcase = document.getElementById("showcase")

  offset_time = ->
    # from when the acceleration-changed event occurred
    # to calucate an integration
    now_date = new Date()
    _last_date = last_date
    last_date = now_date
    return now_date - _last_date

  get_updown = (acc) ->
    # calc with the acceleration(gravity), not gyro
    y = acc.y
    xz = Math.sqrt(
      Math.pow(acc.x, 2) +
      Math.pow(acc.z, 2)
    )
    xz = -xz if acc.z < 0
    updown = Math.atan2(xz, y) / Math.PI * 180
    updown -= 360 if updown > 90
    return updown

  window.addEventListener 'devicemotion', (e)->
    rotation += e.rotationRate.beta * (offset_time()) * 0.001
    # angle rate(gyro) -> angle using integration

    updown = get_updown(e.accelerationIncludingGravity)
    first_updown = updown unless first_updown
    updown -= first_updown
    # now updown is an offset angle


    showcase.setAttribute "style", [
      ["-webkit-transform:rotateX(", -updown, "deg)",
       "rotateY(", -rotation, "deg)"].join(""),
    ].join(";")
