
epic_score = {}

local MP = minetest.get_modpath("epic_score")

-- utils
dofile(MP.."/persistence.lua")

-- blocks
dofile(MP.."/add_score.lua")
dofile(MP.."/set_score.lua")
dofile(MP.."/highscore.lua")
dofile(MP.."/highscore_commit.lua")

-- items
dofile(MP.."/items.lua")

-- forms
dofile(MP.."/forms/highscore_view.lua")
dofile(MP.."/forms/highscore_configure.lua")
