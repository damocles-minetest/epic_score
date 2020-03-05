
epic_score -- Score plugin for the epic mod
-----------------


A mod for [minetest](http://www.minetest.net)

![](https://github.com/damocles-minetest/epic_score/workflows/luacheck/badge.svg)

# Overview

State: **WIP**

# TODO

* [x] score add block (epic-block)
  * adds a score-count to the player metadata `epic_score`

* [x] score set block (epic-block)
  * sets the score-count to a fixed value

* [ ] commit score clock (epic-block)
  * Saves the current score to a `highscore` block

* [ ] highscore block (standalone-block)
  * show highscore of a quest/topic
  * clear highscore button for admins
  * json-export to `epic_score/<topic>`

* [ ] score items (coins)
  * add to score if collected (mechanism?)

* [ ] hud integration

# Licenses

## Code

* MIT

## Assets

* 16x16 Icons in `textures/*`
  * CC BY-SA 3.0 http://www.small-icons.com/packs/16x16-free-toolbar-icons.htm
  * CC BY-SA 3.0 http://www.small-icons.com/packs/16x16-free-application-icons.htm
