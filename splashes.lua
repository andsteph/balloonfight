-- splashes

splashes = {

  init = function(self)
    for splash in all(self) do
      del(self, splash)
    end
  end,

  draw = function(self)
    for splash in all(self) do
      splash:draw()
    end
  end,

  update = function(self)
    for splash in all(self) do
      splash:update()
      if splash.animation.done then
        del(self, splash)
      end
    end
  end,

}
