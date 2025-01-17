-- Library for working with grids/matrices, also known as 2-dimensional arrays

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

---Transposes an NxN matrix in-place.
---@return Matrix
function matrix:transpose()
  assert(self.rowsize == self.colsize, "Row and column length must be equal for Matrix.transpose")

  for i = 1, self.colsize do
    for j = i, self.rowsize do
      local temp = self[i][j]
      self[i][j] = self[j][i]
      self[j][i] = temp
    end
  end

  return self
end

return M.new
