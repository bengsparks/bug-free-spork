local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('themes.icons')
local colors = require('themes.dracula.colors')
local watch = require('awful.widget.watch')
local beautiful = require('beautiful')
local naughty = require('naughty')

local emptyCenter = require('widget.notification-center.empty')
local width = dpi(410)

local notificationsEmpty = true
awful.spawn.with_shell('echo true > /home/benji/.config/awesome/widget/bar/notifications-bar/nc-status')

local panelLayout = wibox.layout.fixed.vertical()

panelLayout.spacing = dpi(7)
panelLayout.forced_width = width

resetPanelLayout = function()
  panelLayout:reset(panelLayout)
  panelLayout:insert(1, emptyCenter)
  notificationsEmpty = true
  awful.spawn.with_shell('echo true > /home/benji/.config/awesome/widget/bar/notifications-bar/nc-status')
end

removeElement = function(box)
  panelLayout:remove_widgets(box)

  if #panelLayout.children == 0 and notificationsEmpty == false then
    panelLayout:reset(panelLayout)
    panelLayout:insert(1, emptyCenter)
    notificationsEmpty = true
    awful.spawn.with_shell('echo true > /home/benji/.config/awesome/widget/bar/notifications-bar/nc-status')
  end
end

panelLayout:insert(1, emptyCenter)

naughty.connect_signal("added", function(n)
  if #panelLayout.children == 1 and notificationsEmpty then
    panelLayout:reset(panelLayout)
    notificationsEmpty = false
    awful.spawn.with_shell('echo false > /home/benji/.config/awesome/widget/bar/notifications-bar/nc-status')
  end

  local box = require("widget.notification-center.elements")
  panelLayout:insert(1, box.create(n.title, n.message))
  awful.spawn.with_shell('echo false > /home/benji/.config/awesome/widget/bar/notifications-bar/nc-status')
end)

return panelLayout