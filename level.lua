-- level

f_bg = 0x1
f_fg = 0x2
f_solid = 2
f_enemy = 3

level = {
	current = 1,
	celx = 0,
	cely = 0,

	draw_bg = function(self)
		map(self.celx, self.cely, 0, 0, 16, 16, f_bg)
	end,

	draw_fg = function(self)
		map(self.celx, self.cely, 0, 0, 16, 16, f_fg)
	end,

	get = function(self, n)
		local current = n or self.current
		self.celx = current % 10 * 16
		self.cely = flr(current / 10) * 16
		for x = 0, 15 do
			for y = 0, 15 do
				local sprite = mget(
					self.celx + x,
					self.cely + y
				)
				local flag = fget(sprite, f_enemy)
				if flag then
					enemy:new(x * 8, y * 8)
				end
			end
		end
	end,

	is_solid = function(self, x, y)
		return fget(mget(self.celx+x, self.cely+y), f_solid)
	end
}
