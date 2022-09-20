-- enemies

enemies = {

  turntime = 20,

  init = function(self)
    for enemy in all(self) do
      del(self, enemy)
    end
  end,

  draw = function(self)
    for enemy in all(self) do
      enemy:draw()
    end
  end,

  update = function(self)
    local dead_count = 0
    for enemy in all(self) do
      enemy:update()
      if enemy.state == 'dead' then
        dead_count += 1
      end
    end
    if dead_count == #self then
      finish:init()
    end
  end,

}
