-- Library for working with grids/matrices, also known MxN arrays

---@overload fun(mat: table[]): Matrix
local M = {}

setmetatable(M --[[@as table]], {
  __call = function(_, mat)
    return M.new(mat)
  end
})

M._mt = {}

---@class Matrix
---@field rowsize integer
---@field colsize integer
---@field shape [integer, integer]
---@operator add(integer | Matrix): Matrix
---@operator mul(integer | Matrix): Matrix
local matrix = {
  rowsize = 0,
  colsize = 0
}

-- Metamethods {{{
M._mt.__index = matrix

function M._mt.__add(a, b)
  if getmetatable(a) ~= M._mt then
    a, b = b, a
  end
  return a:add(b)
end

function M._mt.__mul(a, b)
  if getmetatable(a) ~= M._mt then
    a, b = b, a
  end
  return a:mul(b)
end

function M._mt.__tostring(self)
  local ret = "{\n"

  for _, r in ipairs(self) do
    ret = ret .. "\t{ "
    for _, e in ipairs(r) do
      ret = ret .. ("%s, "):format(e)
    end
    ret = ret .. "},\n"
  end
  ret = ret .. "}"

  return ret
end

-- }}}

-- Constructor {{{
---Create a copy of a 2d array into a Matrix type.
---@param mat table[]
---@return Matrix
---@nodiscard
function M.new(mat)
  assert(type(mat[1]) == 'table', "Rows of argument to Matrix.new should be of `table` type.")

  local ret = {
    rowsize = #mat[1],
    colsize = #mat
  }
  ret.shape = { ret.colsize, ret.rowsize }
  setmetatable(ret, M._mt)

  for _, v in ipairs(mat) do
    assert(#v == ret.rowsize, "Row lengths should be equal for argument to Matrix.new.")

    local row = {}
    for _, e in ipairs(v) do
      row[#row + 1] = e
    end

    ret[#ret + 1] = row
  end

  return ret
end

-- }}}

---Transposes an NxN matrix (not in-place).
---@return Matrix
function matrix:transpose()
  assert(self.rowsize == self.colsize, "Row and column length must be equal for Matrix.transpose.")

  local ret = {}

  for i = 1, self.colsize do
    ret[i] = {}
  end
  for i = 1, self.colsize do
    for j = i, self.rowsize do
      ret[i][j] = self[j][i]
      ret[j][i] = self[i][j]
    end
  end

  return M.new(ret)
end

---Adds two matrices together by component,
---If the parameter is an integer, add the scalar to each component,
---returns a new Matrix.
---@param other Matrix | integer
---@return Matrix
function matrix:add(other)
  local scalar_flag = false
  if type(other) == "number" then
    scalar_flag = true
  else
    assert(self.rowsize == other.rowsize and self.colsize == other.colsize,
      "Matrix dimensions must match for Matrix.add.")
  end

  local ret = {}

  for i = 1, self.colsize do
    ret[i] = {}
    for j = 1, self.rowsize do
      local addend
      if scalar_flag then
        addend = other
      else
        addend = other[i][j]
      end

      ret[i][j] = self[i][j] + addend
    end
  end

  return M.new(ret)
end

local function dot_product(ret, a, b)
  for i = 1, a.colsize do
    ret[i] = {}
    for j = 1, a.colsize do
      ret[i][j] = 0
      for k = 1, a.rowsize do
        ret[i][j] = ret[i][j] + a[i][k] * b[k][j]
      end
    end
  end
end

---Multiplies a matrix and scalar.
---If the parameter is a matrix, performs dot product.
---returns a new Matrix.
---@param other Matrix | integer
---@return Matrix
function matrix:mul(other)
  local scalar_flag = false
  if type(other) == "number" then
    scalar_flag = true
  else
    assert(self.rowsize == other.colsize, "Matrices must follow MxN . NxP = MxP dimensions.")
  end

  local ret = {}

  if scalar_flag then
    for i = 1, self.colsize do
      ret[i] = {}
      for j = 1, self.rowsize do
        ret[i][j] = self[i][j] * other
      end
    end
  else
    dot_product(ret, self, other)
  end

  return M.new(ret)
end

---Return an identity matrix of size n.
---@param n integer
---@return Matrix
function M.identity(n)
  local ret = {}

  for i = 1, n do
    ret[i] = {}
    for j = 1, n do
      if j == i then
        ret[i][j] = 1
      else
        ret[i][j] = 0
      end
    end
  end

  return M.new(ret)
end

return M
