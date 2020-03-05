local update_formspec = function(meta)
	local amount = meta:get_string("amount")
	local seconds = meta:get_string("seconds")
	meta:set_string("infotext", "Periodic score block: " .. amount .. " points / " .. seconds .. " seconds")

	meta:set_string("formspec", "size[8,3;]" ..
		"field[0.2,0.5;8,1;amount;Amount;" .. amount .. "]" ..
		"field[0.2,1.5;8,1;seconds;Per seconds;" .. seconds .. "]" ..

		"button_exit[2.1,1.5;8,1;save;Save]"
	)
end

-- playername => {}
local active_counters = {}

minetest.register_node("epic_score:periodic_add", {
	description = "Epic score periodic add block",
	tiles = {
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png",
		"epic_node_bg.png^epic_dollar.png",
	},
	paramtype2 = "facedir",
	groups = {cracky=3,oddly_breakable_by_hand=3,epic=1},
	on_rotate = screwdriver.rotate_simple,

	on_construct = function(pos)
    local meta = minetest.get_meta(pos)
		meta:set_int("amount", 1)
		meta:set_int("seconds", 10)
    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
    local meta = minetest.get_meta(pos);

		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

    if fields.save then
			meta:set_int("amount", tonumber(fields.amount or "1"))
			meta:set_int("seconds", tonumber(fields.seconds or "10"))
			update_formspec(meta, pos)
    end

  end,

	epic = {
    on_enter = function(_, meta, player, ctx)
			local amount = meta:get_int("amount")
			local seconds = meta:get_int("seconds")
			local playername = player:get_player_name()

			if seconds == 0 or amount == 0 then
				-- disable counter
				active_counters[playername] = nil
			else
				-- set counter
				active_counters[playername] = {
					amount = amount,
					seconds = seconds,
					last_call = 0
				}
			end

      ctx.next()
    end
  }
})

-- handle active counters
minetest.register_globalstep(function()
	local now = os.time()
	for name, entry in pairs(active_counters) do
		local diff = now - entry.last_call
		if diff > entry.seconds then
			entry.last_call = now
			local player = minetest.get_player_by_name(name)
			if player then
				-- add score
				local meta = player:get_meta()
				local score = meta:get_int("epic_score") or 0
				meta:set_int("epic_score", score + entry.amount)
			else
				-- cleanup
				active_counters[name] = nil
			end
		end
	end
end)

-- clear counters on epic abort/exit
epic.register_hook({
  -- called on epic exit
  on_epic_exit = function(playername)
		active_counters[playername] = nil
	end,
	on_epic_abort = function(playername)
		active_counters[playername] = nil
	end,
})
