-- Environment variables
--
-- NVIDIA: this machine runs an RTX 4070 (AD104) on the nvidia-open driver.
-- KDE Plasma already ran fine on Wayland here before Hyprland, which proves
-- DRM/KMS modesetting is correct at the kernel level. That means NO bootloader
-- or mkinitcpio changes are needed — these are wlroots-level hints only.
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")

-- Deliberately NOT set: WLR_NO_HARDWARE_CURSORS.
-- It is a workaround for old NVIDIA cursor corruption, fixed well before the
-- 610.x driver on this box. Only add it if you actually see a broken or
-- invisible cursor, and delete it again once the driver moves on.

-- Toolkit backends — force Wayland where it is safe to do so.
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- Cursor theme/size. Set in one place so GTK, Qt and Hyprland agree.
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")

-- JetBrains IDEs (IntelliJ) historically render blank under some Wayland
-- compositors. If IntelliJ shows an empty window, uncomment this to force it
-- through XWayland, which is stable.
-- hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
