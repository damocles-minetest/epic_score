
local HUD_POSITION = {x = epic_score.hud.posx, y = epic_score.hud.posy}
local HUD_ALIGNMENT = {x = 1, y = 0}

-- playername => id
local hud_data = {}

minetest.register_on_joinplayer(function(player)
  hud_data[player:get_player_name()] = player:hud_add({
    hud_elem_type = "text",
    position = HUD_POSITION,
    offset = {x = 0,   y = 0},
    text = "",
    alignment = HUD_ALIGNMENT,
    scale = {x = 100, y = 100},
    number = 0xFF0000
  })

end)

minetest.register_on_leaveplayer(function(player)
  hud_data[player:get_player_name()] = nil
end)

local timer = 0
minetest.register_globalstep(function(dtime)
  timer = timer + dtime
  if timer < 1.0 then
    return
  end
  timer = 0

  for _, player in minetest.get_connected_players() do
    local playername = player:get_player_name()
    local meta = player:get_meta()
    local score = meta:get_int("epic_score")

    if epic.state[playername] and score > 0 then
      -- update hud
      player:hud_change(hud_data[playername], "text", "Score: " .. score)
    else
      -- hide hud
      player:hud_change(hud_data[playername], "text", "")
    end
  end
end)
