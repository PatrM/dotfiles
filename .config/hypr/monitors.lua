-- Monitors
--
-- Refresh rate is pinned explicitly on purpose. The panel advertises several
-- modes (60 / 100 / 120 / 144); "preferred" does not reliably pick the fastest
-- one, so naming the mode avoids silently running at 60Hz.
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "2560x1440@143.91",
    position = "0x0",
    scale    = 1,
})

-- Catch-all for any monitor plugged in later (dock, projector, second screen).
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- NOTE: this display reports "Vrr: incapable" (verified via kscreen-doctor).
-- Do not set vrr here — it will do nothing at best. If you swap in a monitor
-- that supports it, add `vrr = 1` to that monitor's spec.
