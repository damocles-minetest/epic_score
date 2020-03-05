
local FORMNAME = "epic_score.form_highscore_configure"

function epic_score.form_highscore_configure(pos, playername)
  local meta = minetest.get_meta(pos)
  local name = meta:get_string("name")

  -- TODO
  local formspec = "size[8,2;]" ..
    "label[0,0;Epic start block]" ..
    "label[0,1;" .. name .. "]" ..
    "button_exit[5.5,1;2,1;start;Start]"

  minetest.show_formspec(playername,
    FORMNAME .. ";" .. minetest.pos_to_string(pos),
    formspec
  )
end

minetest.register_on_player_receive_fields(function(_, formname, fields)
	local parts = formname:split(";")
	local name = parts[1]
	if name ~= FORMNAME then
		return
	end

	local pos = minetest.string_to_pos(parts[2])

	if fields.save then
    print(pos) -- TODO
	end

end)
