window.addEventListener 'load', ->
  BG_MAX = 160
  rotation = 0
  first_updown = null # to calculate updown-tilting offset
  last_date = new Date()
  bg = document.getElementById("bg") # background tile
  fg = document.getElementById("fg_img") # az-nyan's body and face'
  hand = document.getElementById("hand_img") # hand
  stop = document.getElementById("stop") # "Stop Pero-Pero"

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

    fg.setAttribute "style", [
      ["left:", -rotation * 1.0, "px"].join(""),
      ["top:", updown*1.2, "px"].join("")
    ].join(";")

    hand.setAttribute "style", [
      ["left:", -rotation * 0.8, "px"].join(""),
      ["top:", updown*1.0, "px"].join("")
    ].join(";")

    offset_rotation = - rotation - 90
    offset_rotation *= BG_MAX / 120
    bg.setAttribute "style", [
      "background-position:", offset_rotation*1.8, "px ", updown*2.0, "px"
    ].join("")
