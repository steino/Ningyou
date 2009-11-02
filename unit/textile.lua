local textile = require"helper.textile"
local utils = require"helper.utils"

local input = [[
A wild line appears!(tm)
 
* Line 1.1
** Line 2.1
** Line 2.2
* Line 1.2
 
@Some code@
 
'it's'
"it's"
 
3 x 3 = 9
a ^2^ + b ^2^ = c ^2^
log ~2~ x
 
I'm %{color:red}unaware%
of most soft drinks.
 
p(haha). lawl
*(haha) Line 1.1
]]

local output = textile(input)

utils.tableprint(output)
