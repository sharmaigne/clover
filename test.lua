local matrix = require("tyrael").matrix

local a = matrix { { 1, 2, 3 }, { 4, 5, 6 } }
local b = matrix { { 7, 8 }, { 9, 10 }, { 11, 12 } }

print(a:mul(b))
