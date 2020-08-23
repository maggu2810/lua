local CS = require("modules.classsupport.ClassSupport")
local Figure2D = require("Figure2D")

local Figure3D, prv = CS.createClass(Figure2D, function(x,y, ...) return x, y end)
Figure3D.constructor = function(self, x, y, z)
    prv(self).z = z
end

function Figure3D:getZ()
    return prv(self).z
end

return Figure3D