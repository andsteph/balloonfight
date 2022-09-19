-- onscreen display

osd = {
    draw = function(self)
        -- score
        local padscore = pad(player.score, 6)
        print('i-', 8, 2, 8)
        print(padscore, 16, 2, 7)
        -- lives
        if player.lives > 0 then
            local x = 56
            spr(45 + player.lives, x, 0)
        end
        -- top
        local padtop = pad(0, 6)
        print('top-', 79, 2, 9)
        print(padtop, 95, 2, 7)
    end
}
