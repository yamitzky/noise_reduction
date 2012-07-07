###
  This library "chaser.js.coffee" is licensed under The MIT License.
  Copyright(c) 2012 Yamitzky.
###
class Chaser
  constructor: ->
		# PARAMETERS YOU CAN SET
    @x0 = null        # 最後の入力。バネの位置の類推
    @spring = 0.1     # バネ定数k
    @resistance = 10  # 粘性抵抗定数η。振動を収束させる
    @mass = 1000      # 擬似質量

		# used by the class
    @vel = 0
    @x = 0
    @last_date = null

  update: (distance) ->
		# 入力が更新されときに呼び出す
    @x0 = distance

  diff: (a, b) ->
		# 角度など、２点間の差が特殊なときに変更する
    return a - b

  get: ->
		# 以下のモデルに従う
		# x = @x - @x0
    # x = vt
    # F = kx - ηv
    x = @diff(@x0, @x)
    time = @offset_time()
    f = @spring * x - @resistance * @vel
    @vel += (f / @mass) * time
    @x += @vel * time
    return  @x

  offset_time: ->
		# 前回呼び出し時からの経過時間を取得
    if @last_date
      now_date = new Date()
      _last_date = @last_date
      @last_date = now_date
      return now_date - _last_date
    else
      @last_date = new Date()
      return 0

window.Chaser = Chaser
