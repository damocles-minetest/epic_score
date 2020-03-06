

local function cleanup(playername)
  local player = minetest.get_player_by_name(playername)
  if player then
    local meta = player:get_meta()
    meta:set_int("epic_score", 0)
  end
end

-- clear score on epic abort/exit
epic.register_hook({
  -- called on epic exit
  on_epic_exit = cleanup,
	on_epic_abort = cleanup,
})
