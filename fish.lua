-- fish

threshold = 100

fish = {

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
	sprs = { 
		jumping = {228, 230, 232 },
		falling = { 234, 236, 238 },
	},
	catch = 0,

	draw = function(self)
		spr(self.sprite, self.x, self.y, 2, 2)
	end,

	update = function(self)
		if self.state == 'inactive' then
			if player.x > 32 and player.x < 84 and player.y > threshold then
				self.animation = animation:new( 'jumping', self.sprs.jumping, 1, false )
				self.x = player.x
				self.y = 120
				self.state = 'jumping'
			end
			self.sprite = 228
		elseif self.state == 'jumping' then
			self.y -= self.speed
			if self.y < 109 then
				self.animation = animation:new( 'falling', self.sprs.falling, 1, false )
				self.state = 'falling'
			end
			if collision(player.body, self.body) then
				self.catch = true
				player.caught = true
			end
			self.sprite = self.animation:get()
		elseif self.state == 'falling' then
			self.y += self.speed
			if self.y > 120 then
				self.catch = false
				self.state = 'inactive'
			end
			self.sprite = self.animation:get()
		end
	end

}
