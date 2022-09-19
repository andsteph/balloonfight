-- level

f_fg = 0
f_bg = 1
f_solid = 2
f_enemy = 3

level = {
	current = 1,
	celx = 0,
	cely = 0,

	draw_bg = function(self)
		map(self.celx, self.cely, 0, 0, 16, 16, f_bg + 1)
	end,

	draw_fg = function(self)
		map(self.celx, self.cely, 0, 0, 16, 16, f_fg + 1)
	end,

	get = function(self)
		self.celx = self.current % 10 * 16
		self.cely = flr(self.current / 10) * 16
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

	collision = function(self, rect1)
		for x = 0, 15 do
			for y = 0, 15 do
				local sprite = mget(
					self.celx + x,
					self.cely + y
				)
				local flag = fget(sprite, f_solid)
				local rect2 = {
					x = x * 8, y = y * 8, width = 8, height = 8
				}
				if flag and collision(rect1, rect2) then
					return rect2
				end
			end
		end
		return false
	end
}
