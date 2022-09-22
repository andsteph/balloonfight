-- balloons

balloons = {

  init = function(self)
    for balloon in all(self) do
      del(self, balloon)
    end
  end,

  update = function(self)
    for balloon in all(self) do
      balloon:update()
      if balloon.y < -8 then
        del(balloons, balloon)
      end
      if collision(player.body, balloon.body) then
        bonus.collected += 1
        del(balloons, balloon)
      end
    end
  end,

  draw = function(self)
    for balloon in all(self) do
      balloon:draw()
    end
  end

}