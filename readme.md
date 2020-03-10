
epic_score -- Score plugin for the epic mod
-----------------


A mod for [minetest](http://www.minetest.net)

![](https://github.com/damocles-minetest/epic_score/workflows/luacheck/badge.svg)

# Overview

Score plugins for the `epic` mod

Features
* set score
* add score
* peridodically add score
* score per item in inventory
* highscore board

# Setup

This mod can post the highscore to a discord webhook if the `http` api is available

minetest.conf
```
secure.http_mods = epic_score
```

# Licenses

## Code

* MIT

## Assets

* 16x16 Icons in `textures/*`
  * CC BY-SA 3.0 http://www.small-icons.com/packs/16x16-free-toolbar-icons.htm
  * CC BY-SA 3.0 http://www.small-icons.com/packs/16x16-free-application-icons.htm
