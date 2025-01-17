-- Library for working with grids/matrices, also known MxN arrays

local M = {}
M.mt = {}

---@class Matrix
---@field rowsize integer
---@field colsize integer
local matrix = {
  rowsize = 0,
  colsize = 0
}
M.mt.__index = matrix

function M.mt.__add(a, b)
  if getmetatable(a) ~= M.mt then
    a, b = b, a
  end
  return a:add(b)
end

function M.mt.__tostring(self)
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
  setmetatable(ret, M.mt)

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
---returns a new Matrix
---@param other Matrix | integer
---@return Matrix
function matrix:add(other)
  local scalar_flag
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

return M.new
