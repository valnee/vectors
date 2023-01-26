local vector = {}
vector.__index = vector

local SQRT = math.sqrt
local RAD = math.rad
local SIN = math.sin
local COS = math.cos
local ATAN2 = math.atan2

-- i'll put all matrices here, because i just did them.
local function matrix_mult(a,b, mat)
  -- a,b = vector x and y
  local x = a*mat[1] + b*mat[2]+mat[3]
  local y = a*mat[4] + b*mat[5]+mat[6]
  return vector.new(x,y)
end

local function rotation_matrix(a)
  local angle = RAD(a)
  return {
    COS(angle), -SIN(angle),0
    SIN(angle), COS(angle),0
    0,0,1
  }
end

local function scale_matrix(sx,sy)
  return {sx,0,0,
    sy,0,0,
    0,0,1}
end

local function translate_matrix(dx,dy)
  return {1,0,dx,
          0,1,dy,
          0,0,1}
end

function vector.new(x,y)
    local self = setmetatable({}, vector)
    self.x = x or 0
    self.y = y or 0
    return self
end

function vector.__add(a,b)
    if type(a) == "number" then
        return vector.new(b.x+a, b.y+a)
    elseif type(b) == "number" then
        return vector.new(a.x+b, a.y+b)
    else
        return vector.new(a.x+b.x, a.y+b.y)
    end
end

function vector.__sub(a,b)
    if type(a) == "number" then
        return vector.new(b.x-a, b.y-a)
    elseif type(b) == "number" then
        return vector.new(a.x-b, a.y-b)
    else
        return vector.new(a.x-b.x, a.y-b.y)
    end
end

function vector.__mul(a,b)
    if type(a) == "number" then
        return vector.new(b.x*a, b.y*a)
    elseif type(b) == "number" then
        return vector.new(a.x*b, a.y*b)
    else
        return vector.new(a.x*b.x, a.y*b.y)
    end
end

function vector.__div(a,b)
    if type(a) == "number" then
        return vector.new(b.x/a, b.y/a)
    elseif type(b) == "number" then
        return vector.new(a.x/b, a.y/b)
    else
        return vector.new(a.x/b.x, a.y/b.y)
    end
end

function vector.__mod(a,b)
    if type(a) == "number" then
        return vector.new(b.x%a, b.y%a)
    elseif type(b) == "number" then
        return vector.new(a.x%b, a.y%b)
    else
        return vector.new(a.x%b.x, a.y%b.y)
    end
end

function vector.__pow(a,b)
    if type(a) == "number" then
        return vector.new(b.x^a, b.y^a)
    elseif type(b) == "number" then
        return vector.new(a.x^b, a.y^b)
    else
        return vector.new(a.x^b.x, a.y^b.y)
    end
end

function vector.__eq(a,b) return (a.x==b.x) and (a.y==b.y) end
function vector.__lt(a,b) return (a.x<b.x)  and (a.y<b.y) end
function vector.__le(a,b) return (a.x<=b.x) and (a.y<=b.y) end
function vector.__unm(a)  return vector.new(-a.x, -a.y) end
function vector.__len(a)  return a:length() end

function vector.distance(a,b)  local v=b-a return v:length() end
function vector:length()       return SQRT(self.x*self.x + self.y*self.y) end
function vector:normalize()
    local leng = self:length()
    if leng > 0 then
        return vector.new(self.x/leng, self.y/leng)
    end
    return self
end
function vector.cross(a,b)
  return a.x*b.y - a.y*b.x
end
function vector.dot(a,b)       return (a.x*b.x + a.y*b.y) end
function vector:scale(vec)     local v=matrix_mult(self.x,self.y,rotation_matrix(vec.x,vec.y) self.x=v.x self.y=v.y return self end
function vector:rotate(a)      local v=matrix_mult(self.x,self.y,rotation_matrix(a) self.x=v.x self.y=v.y return self end
function vector:translate(vec) local v=matrix_mult(self.x,self.y,translate_matrix(vec.x,vec.y) self.x=v.x self.y=v.y return self end
function vector:lookat(from, to)
    local dir = to-from
    local angle = ATAN2(dir.y, dir.x)
    return self:rotate(angle)
end
function vector:print()    print("x:" .. tostring(self.x) .. " y:" .. tostring(self.y)) end
function vector:clone()    return vector.new(self.x, self.y) end
function vector.zeros()    return vector.new(0,0) end
function vector.ones()     return vector.new(1,1) end
function vector.up()       return vector.new(0,1) end
function vector.down()     return vector.new(0,-1) end
function vector.left()     return vector.new(-1,0) end
function vector.right()    return vector.new(1,0) end
function vector.random(xf,xt, yf,yt)   return vector.new(
    math.random(xf or -1000, xt or 1000),
    math.random(yf or -1000, yt or 1000),
) end

return vector
