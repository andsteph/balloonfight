-- background stars

bgstars = {

    init = function(self)
        for i = 1, 25 do
            local bgstar = {
                x = flr(rnd(128)),
                y = flr(rnd(128)),
                c = flr(rnd(14)) + 2
            }
            self[i] = bgstar
        end
    end,

    draw = function(self)
        for bgstar in all(self) do
            pset(bgstar.x, bgstar.y, bgstar.c)
        end
    end,

    update = function(self)
        for bgstar in all(self) do
            if flr(rnd(100)) == 0 then
                bgstar.x = flr(rnd(128))
                bgstar.y = flr(rnd(128))
            end
        end
    end
}
