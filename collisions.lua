-- collisions

collisions = {

  check = function(self, rect1, rect2)
    return rect1.x < rect2.x + rect2.width and
        rect1.x + rect1.width > rect2.x and
        rect1.y < rect2.y + rect2.height and
        rect1.y + rect1.height > rect2.y
  end,

  check_bubbles = function(self)
    for bubble in all(bubbles) do
      if self:check(bubble.body, player.body) then
        bubble:pop()
      end
    end
  end,

  check_enemies = function(self, en)
    for enemy in all(enemies) do
      if self:check(en.body, enemy.body) then
        en.vel.x = -en.vel.x
        enemy.vel.x = -enemy.vel.x
      end
    end
  end,

  check_level = function(self, rect1)
    for x = 0, 15 do
      for y = 0, 15 do
        local rect2 = {
          x = x * 8, y = y * 8, width = 8, height = 8
        }
        if level:is_solid(x, y) and self:check(rect1, rect2) then
          return rect2
        end
      end
    end
    return false
  end,

  check_player = function(self, enemy)
    if player.state ~= 'dead' then
      if enemy.state == 'pumping' then
        if self:check(player.body, enemy.body) then
          enemy:kick()
        end
      elseif enemy.state == 'falling' then
        if self:check(player.foot_body, enemy.ball_body) then
          player.vel.y = -1
          player.vel.x = -player.vel.x / 2
          enemy:kick()
        end
      elseif enemy.state == 'flying' then
        if self:check(player.foot_body, enemy.ball_body) then
          player.vel.y = -1
          player.vel.x = -player.vel.x / 2
          enemy:pop()
        elseif self:check(enemy.foot_body, player.ball_body) then
          enemy.vel.y = -1
          enemy.vel.x = -enemy.vel.x / 2
          player:pop()
        elseif self:check(player.body, enemy.body) then
          player.vel.x = -player.vel.x / 2
          enemy.vel.x = -enemy.vel.x / 2
        end
      end
    end
  end,

  update = function(self)
    for enemy in all(enemies) do
      self:check_bubbles()
      self:check_player(enemy)
      self:check_enemies(enemy)
    end
  end

}
