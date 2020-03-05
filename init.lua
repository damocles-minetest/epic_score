
epic_score = {}

local MP = minetest.get_modpath("epic_score")

dofile(MP.."/add_score.lua")
dofile(MP.."/set_score.lua")
dofile(MP.."/highscore.lua")
dofile(MP.."/highscore_commit.lua")
dofile(MP.."/items.lua")

dofile(MP.."/forms/highscore_view.lua")
dofile(MP.."/forms/highscore_configure.lua")
