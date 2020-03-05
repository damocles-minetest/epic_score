
local FORMNAME = "epic_score.form_highscore_view"

function epic_score.form_highscore_view(pos, playername)
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
