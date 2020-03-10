
local http = epic_score.http

local update_formspec = function(meta)
  local topic = meta:get_string("topic")
	meta:set_string("infotext", "Discord highscore post block: '" .. topic .. "'")

	meta:set_string("formspec", "size[8,3;]" ..
		-- col 2
		"field[0.2,0.5;8,1;topic;Topic;" .. topic .. "]" ..

		-- col 3
		"field[0.2,1.5;8,1;url;URL (blanked, type to change);]" ..

		-- col 4
		"button_exit[0.1,2.5;8,1;save;Save]" ..
		"")
end

local execute = function(webhook_url, topic)

  local score_table = epic_score.get_score(topic)
  if not score_table then
    return
  end

  local content = "**Highscore for '" .. topic .. "'**\n"

  for rank, entry in ipairs(score_table) do
    content = content .. "(" .. rank .. ") " ..
      "**" .. entry.score .. "** " ..
      "" .. entry.playername .. " \n";
  end


	local data = {
    content = content
	}

	local json = minetest.write_json(data)

	-- new rank
	http.fetch({
		url = webhook_url,
		extra_headers = { "Content-Type: application/json" },
		timeout = 5,
		post_data = json
	}, function()
		-- ignore error
	end)
end

minetest.register_node("epic_score:discord_highscore", {
	description = "Epic discord highscore block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_discord.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name())
		meta:set_string("url", "")
		meta:set_string("topic", "my maze")
		meta:mark_as_private("url")
    update_formspec(meta, pos)
	end,

  on_receive_fields = function(pos, _, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or sender:get_player_name() ~= meta:get_string("owner") then
			-- not allowed
			return
		end

    if fields.save then
			if fields.url and fields.url ~= "" then
				-- only update if changed
				meta:set_string("url", fields.url)
				meta:mark_as_private("url")
			end
			meta:set_string("topic", fields.topic or "")
			update_formspec(meta, pos)
    end

  end,

	epic = {
    on_enter = function(_, meta, _, ctx)
			local url = meta:get_string("url")
			local topic = meta:get_string("topic")

			execute(url, topic)
      ctx.next()
    end
  }
})
