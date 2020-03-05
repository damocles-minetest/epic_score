minetest.register_node("epic_score:highscore", {
	description = "Epic highscore block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_dollar_2.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

  on_rightclick = function(pos, _, player)
		local playername = player:get_player_name()
		if minetest.is_protected(pos, playername) then
			-- view
			epic_score.form_highscore_view(pos, playername)
		else
			-- configure
			epic_score.form_highscore_configure(pos, playername)
		end
	end,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("topic", "Example quest")
  end

})
