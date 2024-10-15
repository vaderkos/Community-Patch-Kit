--- @meta

--- Loads specified `filename` from VFS. It replaces lua's `require` function in Civ5.
--- See [Specifics Of Lua Implementation in Civ5](http://modiki.civfanatics.com/index.php?title=Specificities_of_the_Lua_implementation_in_Civ5)
--- for more information
--- @param filename string # Filename to load, or regex to load files
--- @param useRegex? boolean # Is specified filename a regex to load
--- @return string[]
--- @see require
function include(filename, useRegex) end
