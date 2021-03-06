local update_formspec = function(meta)
	local amount = meta:get_string("amount")
	meta:set_string("infotext", "Kill score block: " .. amount .. " points / kill")

	meta:set_string("formspec", "size[8,2;]" ..
		"field[0.2,0.5;8,1;amount;Amount;" .. amount .. "]" ..
		"button_exit[0,1.5;8,1;save;Save]"
	)
end

-- playername => amount
local active_counters = {}

minetest.register_node("epic_score:kill", {
	description = "Epic kill score block",
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
			update_formspec(meta, pos)
    end

  end,

	epic = {
    on_enter = function(_, meta, player, ctx)
			local amount = meta:get_int("amount")
			local playername = player:get_player_name()

			if amount == 0 then
				-- disable counter
				active_counters[playername] = nil
			else
				-- set counter
				active_counters[playername] = amount
			end

      ctx.next()
    end
  }
})

-- players
minetest.register_on_punchplayer(function(player, hitter, _, _, _, damage)
  -- player got hit by another player

	if not hitter or not hitter:is_player() then
    return
  end

	local name = hitter:get_player_name()

	if not active_counters[name] or active_counters[name] == 0 then
		return
	end

  if damage >= player:get_hp() and player:get_hp() > 0 then
		local player_meta = hitter:get_meta()
		local score = player_meta:get_int("epic_score")
		score = score + active_counters[name]
		player_meta:set_int("epic_score", score)
  end
end)

-- mobs
minetest.register_on_mods_loaded(function()
	for _,entity in pairs(minetest.registered_entities) do
		if entity.hp_min or entity.hp_min then -- Probably a mobs_redo mob
			local originalPunch = entity.on_punch
			local originalDie = entity.on_die

			entity.on_punch = function(self, hitter, time_from_last_punch, tool_capabilities, direction)
				-- Save the name of the attacker
				if hitter:is_player() then
					local name = hitter:get_player_name()

					self.attacker = name
				end

				if originalPunch then
					return originalPunch(self, hitter, time_from_last_punch, tool_capabilities, direction)
				end
			end

			entity.on_die = function(self, pos) -- Use the saved name to increase the killer's kill count when the mob dies
				if self.attacker and active_counters[self.attacker] then
					local hitter = minetest.get_player_by_name(self.attacker)
					local player_meta = hitter:get_meta()
					local score = player_meta:get_int("epic_score")
					score = score + active_counters[self.attacker]
					player_meta:set_int("epic_score", score)
				end

				if originalDie then
					originalDie(self, pos)
				end
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
