local matrix = require("tyrael").matrix

local m = matrix({ { 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 } })

print(10 + m:transpose())
print(m:transpose())
