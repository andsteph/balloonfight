-- global functions

-- bounce
function bounce(vel)
    return max(-vel/2,min_bounce)
end

-- check for collisions
function collision(rect1,rect2)
    return rect1.x<rect2.x+rect2.width and
        rect1.x+rect1.width>rect2.x and
        rect1.y<rect2.y+rect2.height and
        rect1.y+rect1.height>rect2.y
end

-- distance
function distance(obj1,obj2)
    local x1=obj1.x
    local y1=obj1.y
    local x2=obj2.x
    local y2=obj2.y
    return ((x2-x1)^2+(y2-y1)^2)^0.5
end

-- ease
function ease(current, max, step)
    local s = sgn(max)
    if current == 0 then
        return 0
    else
        return 
    end
end

-- lerp
function lerp(a, b, t)
    return a+(b-a)*t
end

-- pad with zeros
function pad(value,length)
    local string=tostr(value)
    if (#string==length) return string
    return "0"..pad(string, length-1)
end

-- print centered on x axis
function printc(text,y,x1,x2,c)
    x1=x1 or 0
    x2=x2 or 127
    c=c or 7
    local width=#text*4
    local x=(x2-x1)/2+x1-width/2
    print(text,x,y,c)
end

-- random direction
function randdir()
    if rnd()<0.5 then
        return left
    end
    return right
end

-- show sprite made of strings
function str_spr(str,sx,sy)
    for y,row in ipairs(str) do
        for x,col in ipairs(split(row,"")) do
            if col~=1 then
                pset(sx+x-1,sy+y-1,col)
            end
        end
    end
end

-- wrap at edge of screen
function wrap(char)
    if char.x<-8 then
        char.x=127-8
    elseif char.x>127-8 then
        char.x=-8
    end
end
