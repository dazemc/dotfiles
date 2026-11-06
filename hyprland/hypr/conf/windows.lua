--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
  -- Ignore maximize requests from all apps. You'll probably like this.
  name = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
  name = "move-hyprland-run",
  match = { class = "hyprland-run" },

  move = "20 monitor_h-120",
  float = true,
})

hl.window_rule({
  match = {
    class = "spotify"
  },
  workspace = "5 silent"
})

hl.window_rule({
  match = {
    class = "firefox"
  },
  workspace = "3"
})

hl.window_rule({
  match = {
    class = "kitty"
  },
  workspace = "2"
})

hl.window_rule({
  match = {
    class = "btop"
  },
  workspace = 4
})

hl.window_rule({
  match = {
    class = "steam"
  },
  workspace = 1
})

-- this will launch all steam(gamescope) games on workspace 9
hl.window_rule({
  match = {
    class = "gamescope"
  },
  workspace = 9
})

-- Keep workspaces 1-5 and 9 on the main monitor.
-- Keep this in sync with conf/monitor.lua; if the output name changes the
-- rules are silently ignored or move workspaces to the wrong display.
hl.workspace_rule({
  workspace = "1",
  monitor = "HDMI-A-2",
  default = true,
})

hl.workspace_rule({
  workspace = "2",
  monitor = "HDMI-A-2",
})

hl.workspace_rule({
  workspace = "3",
  monitor = "HDMI-A-2",
})

hl.workspace_rule({
  workspace = "4",
  monitor = "HDMI-A-2",
})

hl.workspace_rule({
  workspace = "5",
  monitor = "HDMI-A-2",
})

hl.workspace_rule({
  workspace = "9",
  monitor = "HDMI-A-2",
})
