#!/usr/bin/env lua

--[[
-- (C) 2018 NETDUMA Software
-- Kian Cross <kian.cross@netduma.com>
--
-- repack: keep the user-selected theme (stock resets it to "default" on
-- every boot) and keep the bundled "Default 3.0" (DumaOS 3.3.535
-- Netduma-red) theme symlinked into the cloud themes dir, which is wiped
-- and re-linked here on every start.
--]]

package.path = "/" .. "/dumaos/api/?.lua" .. ";" .. "/" .. "/dumaos/api/libs/?.lua" .. ";" .. package.path

require("libos")
local json = require("json")

local themes_path = "/" .. "/dumaos/themes"

local themes_cloud_path = string.format("%s/cloud", themes_path)
local themes_ready_path = string.format("%s/ready", themes_path)

json.save(themes_ready_path, false)

local manifest = json.load(string.format("%s/default/manifest.json", themes_path))

local theme = os.config_get("DumaOS_Theme")
if not theme or theme == "" then
  if os.rename(string.format("%s/default30/theme.luac", themes_path), string.format("%s/default30/theme.luac", themes_path)) then
    os.config_set("DumaOS_Theme", "default30")
    os.config_set("DumaOS_Theme_Version", "1.0")
  else
    os.config_set("DumaOS_Theme", "default")
    os.config_set("DumaOS_Theme_Version", manifest.version)
  end
end

local theme_version = os.config_get("DumaOS_Theme_Version")
if not theme_version or theme_version == "" then
  os.config_set("DumaOS_Theme_Version", manifest.version)
end

os.execute(string.format("rm -rf %s && rm -rf  %s/* && mkdir -p %s", themes_cloud_path, themes_cloud_path, themes_cloud_path))
os.execute(string.format("ln -s %s/default %s/default", themes_path, themes_cloud_path))
os.execute(string.format("ln -s %s/default30 %s/default30 2>/dev/null", themes_path, themes_cloud_path))
os.execute("sync")

json.save(themes_ready_path, true)
