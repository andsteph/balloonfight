-- scores

scores = {
	duration = 10,
	amounts = {
		ground = 750,
		air = 500,
		parachute = 1000,
		bubble = 500,
		bonus = 300,
		perfect = 10000
	},

	init = function(self)
		for score in all(self) do
			del(self, score)
		end
	end,

	draw = function(self)
		for score in all(self) do
			print(score.n, score.x - 1, score.y + 1, 0)
			print(score.n, score.x, score.y, 9)
		end
	end,

	update = function(self)
		for score in all(self) do
			score.counter-=1
			if score.counter < 1 then
				del(self, score)
			end
		end
	end,

	new = function(self, x, y, n)
		if type(n) == 'string' then
			n = self.amounts[n]
		end
		player.score+=n
		local score = {
			x = x,
			y = y,
			n = n,
			counter = self.duration,
		}
		add(self, score)
	end

}
