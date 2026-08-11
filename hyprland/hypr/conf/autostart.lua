-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
local programs = require("conf.programs")
hl.on("hyprland.start", function()
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("waybar")
  hl.exec_cmd("awww-daemon &")
  hl.exec_cmd("aww-img /home/daze/Pictures/night_city.gif &")
  hl.exec_cmd("export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$UID/bus")
  hl.exec_cmd(programs.terminal .. " btop")
end)
