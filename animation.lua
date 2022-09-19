-- animation

animation = {

    new = function(self, name, sprs, delay, loop )
        
        local o = {
            name = name,
            sprs = sprs,
            delay = delay,
            loop = loop,
            ticks = 0,
            index = 1,
            done = false,
            
            get = function(self, n)
                if n then
                    return self.sprs[n]
                end
                self.ticks += 1
                if self.ticks % self.delay == 0 then
                    self.index += 1
                    if self.index > #self.sprs then
                        if self.loop then
                            self.index = 1
                        else
                            self.index = #self.sprs
                            self.done = true
                        end
                    end
                end
                return self.sprs[self.index]
            end
        }
        
        return o
    
    end

}