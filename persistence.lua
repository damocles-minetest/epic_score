
--[[

File: <worlddir>/epic_score/<topic>.json

Content:
[{
  playername: "",
  score: 0
},{
  ...
}]

--]]

local basedir = minetest.get_worldpath() .. "/epic_score"

local function get_score_file(topic)
	local sane_filename = string.gsub(topic, "[.|/]", "")
	return basedir .. "/" .. sane_filename .. ".json"
end

local function load_score(topic)
  local file = io.open(get_score_file(topic), "r")
  local score = nil

  if file then
    local json = file:read("*a")
    score = minetest.parse_json(json or "")
  end

  return score or {}
end

local function save_score(topic, score)
  local file = io.open(get_score_file(topic),"w")
  local json = minetest.write_json(score)
  if file and file:write(json) and file:close() then
    return
  else
    minetest.log("error","[epic_score] save score failed - data may be lost!")
    return
  end
end

-- updates a player score if it is higher than before
function epic_score.update_score(topic, playername, score)
  local score_table = load_score(topic)
  local found = false


  -- existing entry
  for _, entry in ipairs(score_table) do
    if entry.playername == playername then
      if score > entry.score then
        -- only update if higher
        entry.score = score
      end
      found = true
      break
    end
  end

  -- new entry
  if not found then
    table.insert(score_table, {
      playername = playername,
      score = score
    })
  end

  -- sort by score desc
  table.sort(score_table, function(a,b)
    return a.score > b.score
  end)

  -- create new score table with limited entries
  local new_score = {}
  for i, entry in ipairs(score_table) do
    if i > 20 then
      break
    end
    table.insert(new_score, entry)
  end

  save_score(score_table, new_score)
end

function epic_score.get_score(topic)
  return load_score(topic)
end
