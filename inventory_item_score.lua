
-- playername => itemname => amount
local item_rewards = {}

local update_formspec = function(meta)
	local amount = meta:get_string("amount")

	meta:set_string("formspec", "size[8,6;]" ..
		"list[context;main;0,0.5;1,1;]" ..
		"field[2,0.5;6,1;amount;Amount;" .. amount .. "]" ..
		"button_exit[6,0.5;2,1;save;Save]" ..

		"list[current_player;main;0,2;8,4;]" ..
		"listring[]" ..
		"")
end

minetest.register_node("epic:inventory_item_score", {
	description = "Epic inventory item score block",
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
		meta:set_int("amount", 0)

		local inv = meta:get_inventory()
		inv:set_size("main", 1)

    update_formspec(meta, pos)
  end,

  on_receive_fields = function(pos, _, fields, sender)
		if not sender or minetest.is_protected(pos, sender:get_player_name()) then
			-- not allowed
			return
		end

		if fields.save then
			local meta = minetest.get_meta(pos);
			meta:set_int("amount", tonumber(fields.amount or "0"))
		end

  end,

	allow_metadata_inventory_put = function(pos, _, _, stack, player)

		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		return stack:get_count()
	end,

	allow_metadata_inventory_take = function(pos, _, _, stack, player)

		if minetest.is_protected(pos, player:get_player_name()) then
			return 0
		end

		return stack:get_count()
	end,

	epic = {
    on_enter = function(_, meta, player, ctx)
			local inv = meta:get_inventory()
			local stack = inv:get_stack("main", 1)
			local item_name = stack:get_name()
			if item_name == "ignore" or item_name == "" then
				return
			end

			local amount = meta:get_int("amount")
			local playername = player:get_player_name()
			local entry = item_rewards[playername]
			if not entry then
				entry = {}
				item_rewards[playername] = entry
			end

			if amount == 0 then
				-- clear entry
				item_rewards[playername][item_name] = nil
			else
				-- update entry
				item_rewards[playername][item_name] = amount
			end

			ctx.next()
    end
  }
})

-- clear counters on epic abort/exit
epic.register_hook({
  -- called on epic exit
  on_epic_exit = function(playername)
		item_rewards[playername] = nil
	end,
	on_epic_abort = function(playername)
		item_rewards[playername] = nil
	end,
})

-- handle active counters
minetest.register_globalstep(function()
	for name, items in pairs(item_rewards) do
		local player = minetest.get_player_by_name(name)
		local player_inv = player:get_inventory()
		local list = player_inv:get_list("main")

		for i, stack in ipairs(list) do
			local amount = items[stack:get_name()]
			if amount < 0 or amount > 0 then
				local count = stack:get_count()
				player_inv:set_stack("main", i, ItemStack(""))

				-- add score
				local meta = player:get_meta()
				local score = meta:get_int("epic_score") or 0
				meta:set_int("epic_score", score + (amount * count))
			end
		end

	end
end)
