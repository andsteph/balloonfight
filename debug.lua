-- debug

debug = {
	on = true,
	visuals = false,

	draw_body = function(self, body, c)
		if self.on and self.visuals then
			rect(
				body.x,
				body.y,
				body.x + body.width,
				body.y + body.height,
				c
			)
		end
	end,

	draw = function(self)
		if self.on then
			print(self.message, 0, 8, 7)
		end
	end,

	input = function(self)
		if self.on then
			local key = stat(31)
			if key == '`' then
				self.visuals = not self.visuals
			end
			if key == '1' then
				bubbles:new(64, 127)
			end
			if key == 'b' then
				player.balloons += 1
				if player.balloons > 2 then
					player.balloons = 1
				end
			end
			if key == 'd' then
				player.balloons = 0
			end
			if key == 'e' then
				enemies:new(64, 64)
			end
			if key == 'l' then
				player.lives += 1
				if player.lives > 2 then
					player.lives = 0
				end
			end
			if key == 'f' then
				balloons:new()
			end
			if key == 's' then
				player.score += 1
			end
		end
	end,

	update = function(self)
		--[[
	 self.messages={
	  'grnd:'..(player.grounded and '1' or '0'),
	  'vely:'..player.vel.y,
	  'velx:'..player.vel.x
	 }
	 self:input()
	 ]]
		self:input()
	end
}
