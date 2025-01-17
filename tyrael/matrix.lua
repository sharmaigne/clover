-- Library for working with grids/matrices, also known as 2-dimensional arrays

local M = {}

---@class Matrix
---@field rowsize integer
---@field colsize integer

---Create a copy of a 2d array into a Matrix type.
---@param mat table[]
---@return Matrix
---@nodiscard
function M.new(mat)
  assert(type(mat[1]) == 'table', "Rows of argument to Matrix.new should be of `table` type.")

  ---@type Matrix
  local ret = {
    rowsize = #mat[1],
    colsize = #mat
  }

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

return M
