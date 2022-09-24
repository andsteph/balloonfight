-- sound

sound = {

  new = function(self, n, duration)
    local o = {
      n = n,
      duration = duration,
      timer = 0,
      play = function(self)
        if self.timer <= 0 then
          sfx(n)
          self.timer = self.duration
        else
          self.timer -= 1
        end
      end
    }
    return o
  end,

}