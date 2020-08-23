--json = require("modules.json.json")

local CS = require("modules.classsupport.ClassSupport")

local Figure1D = require("Figure1D")
local Figure2D = require("Figure2D")
local Figure3D = require("Figure3D")

dim1 = Figure1D(1)
dim2 = Figure2D(2, 3)
dim3 = Figure3D(4, 5, 6)
print("done")

print(dim3:getX())
print(dim3:getY())
print(dim3:getZ())
print(dim2:getX())
print(dim2:getY())
print(dim1:getX())

print(dim1)
print(dim2)
print(dim3)

print("===")
print(dim1:toString())
print("===")
print(dim2:toString())
print("===")
print(dim3:toString())

print(Figure3D)
print(Figure2D)
print(Figure1D)
