
epic_score = {
  hud = {
    posx = tonumber(minetest.settings:get("epic_score.hud.offsetx") or 0.5),
    posy = tonumber(minetest.settings:get("epic_score.hud.offsety") or 0.7)
  },
  http = minetest.request_http_api()
}

local MP = minetest.get_modpath("epic_score")

-- utils
dofile(MP.."/persistence.lua")
dofile(MP.."/cleanup.lua")

-- hud
dofile(MP.."/hud.lua")

-- blocks
dofile(MP.."/add_score.lua")
dofile(MP.."/set_score.lua")
dofile(MP.."/periodic_add.lua")
dofile(MP.."/kill.lua")
dofile(MP.."/inventory_item_score.lua")
dofile(MP.."/highscore.lua")
dofile(MP.."/highscore_save.lua")

-- webhooks
if epic_score.http then
  dofile(MP.."/discord_highscore.lua")
end

-- items
dofile(MP.."/items.lua")

-- forms
dofile(MP.."/forms/highscore_view.lua")
dofile(MP.."/forms/highscore_configure.lua")


-- clear http api after all is set up
epic_score.http = nil
