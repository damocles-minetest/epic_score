local update_formspec = function(meta)
	local topic = meta:get_string("topic")
	meta:set_string("infotext", "Score load block: ''" .. topic .. "'")

	meta:set_string("formspec", "size[8,2;]" ..
		-- col 1
		"field[0.2,0.5;8,1;topic;Topic;" .. topic .. "]" ..

		-- col 2
		"button_exit[0.1,1.5;8,1;save;Save]" ..
		"")
end

minetest.register_node("epic_score:load", {
	description = "Epic score load block, loads a previously saved highscore",
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

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_string("topic", "Example quest")
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.save then
			meta:set_string("topic", fields.topic or "")
			update_formspec(meta, pos)
    end

  end,

	epic = {
    on_enter = function(_, meta, player, ctx)
      local player_meta = player:get_meta()

      local topic = meta:get_string("topic")

			-- retrieve score from per-player store
			local score = player_meta:get_int("epic_highscore:" .. topic)
			player_meta:set_int("epic_score", score)

      ctx.next()
    end
  }
})
