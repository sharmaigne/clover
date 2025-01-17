-- Library for working with grids/matrices, also known as 2-dimensional arrays

---@class Matrix
---@field rowsize integer
---@field colsize integer

local M = {}
M.mt = {}

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

  ---@type Matrix
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

return M
