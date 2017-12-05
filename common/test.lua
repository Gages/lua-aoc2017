local m = require "common"

--Tests
assert(#m.list "1 2 3" == 3)
assert(#m.list "1 2 3 " == 3)
assert(#m.list " 1 2 3" == 3)
assert(#m.list "    " == 0)
assert(#m.list " 1  2  3  " == 3)
assert(m.list "1 2 3" [1] == "1")
assert(m.list "1 2 3" [2] == "2")
assert(m.list "1 2 3" [3] == "3")
