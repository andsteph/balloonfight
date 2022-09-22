-- fish

fish = {

	threshold = 90,
	x = 64,
	y = 120,
	speed = 0.75,
	left = 32,
	right = 84,
	body = {
		x = 0,
		y = 0,
		width = 16,
		height = 16,
	},
	top = 80,
	state = 'inactive',
	animations = {
		jumping = animation:new('jumping', {228, 230, 232 }, 3, false ),
		falling = animation:new('falling', { 234, 236, 238 }, 3, false ),
	},
	catch = false,

	draw = function(self)
		spr(self.sprite, self.x, self.y, 2, 2)
	end,

	update = function(self)
		if self.state == 'inactive' then
			if player.x > 32 and player.x < 84 and player.y > self.threshold and self.catch == false then
				self.x = player.x
				self.y = 120
				self.state = 'jumping'
			end
			self.sprite = 228
		elseif self.state == 'jumping' then
			self.y -= self.speed
			if self.y < 109 then
				self.state = 'falling'
			end
			if collision(player.body, self.body) then
				self.catch = true
				player.state = 'caught'
			end
			self.sprite = self.animations.jumping:get()
		elseif self.state == 'falling' then
			self.y += self.speed
			if self.y > 120 then
				self.state = 'inactive'
			end
			self.sprite = self.animations.falling:get()
		end
		self.body.x = self.x
		self.body.y = self.y
	end

}
