-- splashes

splashes = {
  sprs = { 32, 33, 48, 49 },

  init = function(self)
    for splash in all(self) do
      del(self, splash)
    end
  end,

  draw = function(self)
    for splash in all(self) do
      spr(
        self.sprs[splash.index],
        splash.x,
        splash.y
      )
    end
  end,

  update = function(self)
    for splash in all(self) do
      if ticks % 4 == 0 then
        splash.index += 1
      end
      if splash.index > #splashes.sprs then
        del(self, splash)
      end
    end
  end,

  new = function(self, x)
    local splash = {
      x = x,
      y = 116,
      index = 1
    }
    add(self, splash)
  end

}
