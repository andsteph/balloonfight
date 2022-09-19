-- input

input = {

    x = 0,
    y = 0,
    b4 = false,
    b5 = false,
    lastb4 = 0,

    update = function(self)
        self.b4 = btn(4, 0)
        self.b5 = btn(5, 0)
        if btn(⬅️) and btn(➡️) == false then
            self.x = -1
        elseif btn(➡️) and btn(⬅️) == false then
            self.x = 1
        else
            self.x = 0
        end
        self.lastb4 = self.b4
    end

}