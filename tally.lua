-- tally

tally = {
    step = 20,
    value = 300,
    super = 10000,

    init = function(self)
        self.timer = 0
        self.state = 1
        self.total = 0
        self.state = 'init'
        if bonus.collected then
            self.total = bonus.collected * self.value
        end
        _draw = self.draw
        _update = self.update
    end,

    draw = function()
        self = tally
        cls(bgcolor)
        osd:draw()
        local x = 8
        local y = 40
        spr(96, x, y, 2, 2, true)
        if self.timer <= self.step * 2 then
            spr(63, x + 20, y + 4)
        else
            print('300', x + 20, y + 6)
        end
        local text = ''
        if self.timer > self.step then
            text..='x '..tostr(bonus.collected)
        end
        if self.timer > self.step * 2 then
            text..=' = '..tostr(self.total)..' pts.'
        end
        if self.timer > self.step * 3 and bonus.collected == bonus.balloon_max then
            printc('p e r f e c t !!!', y + 40, nil, nil, 9)
            printc('super bonus  ' .. self.super .. 'pts!', y + 50, nil, nil, 9)
        end
        print(text, x + 36, y + 6, 7)
    end,

    update = function()
        self = tally
        if self.timer == self.step * 2 then

        end
        if self.timer == self.step * 3 then
            if bonus.collected == bonus.balloon_max then
                --sfx
                player.score += self.super
            end
        end
        if self.state == 'init' then
            self.timer += 1
            if self.timer > self.step * 4 then
                self.state = 'countdown'
            end
        elseif self.state == 'countdown' then
            if self.total <= 0 then
                self.state = 'complete'
            else
                player.score += 100
                self.total -= 100
            end
        else
            self.timer += 1
            if self.timer > self.step * 5 then
                level.current += 1
                play:init()
            end
        end
    end

}
