local CS = require("modules.classsupport.ClassSupport")

local Figure1D, prv = CS.createClass()
Figure1D.constructor = function(self, x)
    prv(self).x = x
end

function Figure1D:getX()
    return prv(self).x
end

return Figure1D
