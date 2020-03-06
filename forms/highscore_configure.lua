
local FORMNAME = "epic_score.form_highscore_configure"

function epic_score.form_highscore_configure(pos, playername)
  local meta = minetest.get_meta(pos)
  local topic = meta:get_string("topic")

  local formspec = "size[8,2;]" ..
    "field[0.2,0.5;8,1;topic;Topic;" .. topic .. "]" ..

    "button_exit[0,1.2;4,1;save;Save]" ..
    "button_exit[4,1.2;4,1;show;Show]"

  minetest.show_formspec(playername,
    FORMNAME .. ";" .. minetest.pos_to_string(pos),
    formspec
  )
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
  local playername = player:get_player_name()

	local parts = formname:split(";")
	local name = parts[1]
	if name ~= FORMNAME then
		return
	end

	local pos = minetest.string_to_pos(parts[2])

  if minetest.is_protected(pos, player:get_player_name()) then
    -- not allowed
    return
  end

  if fields.show then
    -- show highscore
    epic_score.form_highscore_view(pos, playername)
  end

	if fields.save then
    local meta = minetest.get_meta(pos)
    meta:set_string("topic", fields.topic or "")
	end

end)
