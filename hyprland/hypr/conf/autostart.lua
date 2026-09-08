-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
local programs = require("conf.programs")
hl.on("hyprland.start", function()
  hl.exec_cmd("qs")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("aww-img /home/daze/Pictures/night_city.gif &")
  hl.exec_cmd("export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$UID/bus")
  hl.exec_cmd(programs.terminal .. " --class btop btop", { workspace = "4 silent" })
  hl.exec_cmd(programs.terminal .. " --class kitty", { workspace = "2 silent" })
  hl.exec_cmd("spotify-launcher", { workspace = "5 silent" })
  hl.exec_cmd("firefox --class firefox", { workspace = "3 silent" })
end)
