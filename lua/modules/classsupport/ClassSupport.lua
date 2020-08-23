local ClassSupport = {}

-- member to store class support specific stuff to classes and instances
local MEMBER = "_cs"

local TYPE_CLASS = 0x01
local TYPE_OBJECT = 0x02

-- drop all arguments
local function returnNothing(...)
end

-- function to get a unique identifier for a clazz (table)
local function getId(tbl)
    return tostring(tbl):gsub("table: ", "", 1)
end

-- for debugging purpose
local clazzById = {}

local function getClassForObject(obj)
    return getmetatable(obj).__index
end

local function getParentClassForClass(clazz)
    local mtOfClazz = getmetatable(clazz)
    local mtOfMtOfClazz = getmetatable(mtOfClazz)
    if mtOfMtOfClazz then
        return mtOfMtOfClazz.__index
    else
        return nil
    end
end

local function clazzToString(clazz)
    local clazzChain = {}
    local clazzIt = clazz
    while (clazzIt)
    do
        table.insert(clazzChain, clazzIt[MEMBER].id)
        clazzIt = getParentClassForClass(clazzIt)
    end
    return "class definition: " .. clazz[MEMBER].id .. " (chain: " .. table.concat(clazzChain, " => ") .. ")"
end

-- for debugging purpose only
function ClassSupport._dbg()
    for _, clazz in pairs(clazzById) do
        print(clazzToString(clazz))
    end
end

-- create a class
local function createClass(parentClazz, superArgMapper)
    local clazz = {}
    clazz[MEMBER] = {}
    clazz[MEMBER].id = getId(clazz)
    clazz[MEMBER].type = TYPE_CLASS

    -- for debugging purpose only
    clazzById[clazz[MEMBER].id] = clazz

    local clazzMetaTable = {}
    clazzMetaTable.__index = clazzMetaTable
    clazzMetaTable.__call = function(clazzCur, ...)
        if parentClazz then
            obj = parentClazz(superArgMapper(...))
        else
            obj = {}
            obj[MEMBER] = {}
            obj[MEMBER].id = getId(obj)
            obj[MEMBER].type = TYPE_OBJECT
            obj[MEMBER].prv = {}
        end
        setmetatable(obj, { __index = clazzCur, __tostring = clazzCur.toString })
        obj[MEMBER].prv[clazzCur[MEMBER].id] = {}
        if clazz.constructor then
            clazz.constructor(obj, ...)
        end
        return obj
    end
    clazzMetaTable.__tostring = clazzToString
    if parentClazz then
        setmetatable(clazzMetaTable, { __index = parentClazz })
    end
    setmetatable(clazz, clazzMetaTable)

    local prv = function(obj)
        return obj[MEMBER].prv[clazz[MEMBER].id]
    end

    return clazz, prv
end

-- create the class object used as base class for all classes
local ObjectClass = createClass()
function ObjectClass:getClass()
    return getClassForObject(self)
end
function ObjectClass:toString()
    return "class instance: " .. self[MEMBER].id .. " (class definition: " .. self:getClass()[MEMBER].id .. ")"
end

function ClassSupport.createClass(parentClazz, superArgMapper)
    parentClazz = parentClazz or ObjectClass
    superArgMapper = superArgMapper or returnNothing
    return createClass(parentClazz, superArgMapper)
end

return ClassSupport
