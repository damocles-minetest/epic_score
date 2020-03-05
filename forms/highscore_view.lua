
local FORMNAME = "epic_score.form_highscore_view"

function epic_score.form_highscore_view(pos, playername)
  local meta = minetest.get_meta(pos)
  local topic = meta:get_string("topic") or ""

  local score_table = epic_score.get_score(topic)

  local list = ""

  -- render list items
	for i, entry in ipairs(score_table) do
    local color = "#FFFFFF"

    if i == 1 then
      -- gold
      color = "#D4AF37"
    elseif i == 2 then
      -- silver
      color = "#C0C0C0"
    elseif i == 3 then
      -- bronze
      color = "#CD7F32"
    end

    list = list .. "," .. color .. "," .. entry.score .. "," .. entry.playername
  end

  local formspec = [[
			size[16,12;]
			label[0,0;Highscore]
			button_exit[12,11;4,1;exit;Exit]
			tablecolumns[color;text;text]
			table[0,1;15.7,10;items;#999,Score,Playername]] .. list


  minetest.show_formspec(playername,
    FORMNAME .. ";" .. minetest.pos_to_string(pos),
    formspec
  )
end
