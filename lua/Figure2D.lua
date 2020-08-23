local CS = require("modules.classsupport.ClassSupport")
local Figure1D = require("Figure1D")

local Figure2D, prv = CS.createClass(Figure1D,function(x, ...) return x end)
Figure2D.constructor = function(self, x, y)
    prv(self).y = y
end

function Figure2D:getY()
    return prv(self).y
end

return Figure2D