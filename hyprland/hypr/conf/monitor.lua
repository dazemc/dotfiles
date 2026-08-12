------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
  output = "HDMI-A-1",
  mode = "3840x2160@164.99",
  position = "auto",
  scale = 2,
  vrr = 1,
  bitdepth = 10,
  cm = "hdr",
  sdr_min_luminance = 0.005,
  sdr_max_luminance = 700,
  min_luminance = 0.005,
  max_luminance = 2500,
  max_avg_luminance = 770,
})

hl.config({
  render = {
    cm_enabled = true,
    cm_auto_hdr = 1,
    send_content_type = true,
    non_shader_cm = 1,
    non_shader_cm_interop = 2,
    use_fp16 = 2,
  },

  quirks = {
    prefer_hdr = 2,
  },
})
