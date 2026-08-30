-- Overrides for caelestia's ~/.config/hypr/variables.lua (merged on top).
-- "" unbinds a caelestia default.
return {
  -- Apps
  terminal = "kitty",
  browser = "xdg-open https://",
  editor = "",
  fileExplorer = "thunar",
  audioSettings = "pavucontrol",

  -- Cursor
  cursorTheme = "Bibata-Modern-Ice",
  cursorSize = 24,

  -- Workspaces: SUPER+n go, SUPER+SHIFT+n move (CTRL+SUPER+n = move silently, in hypr-user.lua)
  kbGoToWs = "SUPER",
  kbMoveWinToWs = "SUPER + SHIFT",
  kbGoToWsGroup = "",
  kbMoveWinToWsGroup = "",
  kbNextWsGroup = "",
  kbPrevWsGroup = "",
  kbNextWs = { "SUPER + mouse_down", "SUPER + period", "SUPER + Tab" },
  kbPrevWs = { "SUPER + mouse_up", "SUPER + comma", "SUPER + SHIFT + Tab" },
  kbMoveWinToWsNext = "SUPER + SHIFT + bracketright",
  kbMoveWinToWsPrev = "SUPER + SHIFT + bracketleft",
  kbSpecialWs = "SUPER + U",
  kbMoveWinToWsSpecial = "SUPER + SHIFT + U",
  kbMoveWinFromWsSpecial = "",
  kbSystemMonitorWs = "",
  kbMusicWs = "",
  kbCommunicationWs = "",
  kbTodoWs = "",

  -- Groups (SUPER+Comma/U are taken by workspaces)
  kbToggleGroup = "SUPER + G",
  kbUngroup = "SUPER + ALT + G",
  kbGroupLockActive = "SUPER + SHIFT + G",

  -- Windows
  kbWindowFullscreen = "SUPER + SHIFT + F",
  kbWindowBorderedFullscreen = "CTRL + SUPER + F",
  kbToggleWindowFloating = "SUPER + SPACE",
  kbCloseWindow = "SUPER + Q",

  -- Apps and shell
  kbTerminal = "SUPER + Return",
  kbBrowser = "SUPER + B",
  kbEditor = "",
  kbFileExplorer = "SUPER + E",
  kbLauncher = { "SUPER + SUPER_L", "SUPER + D" },
  kbSession = "CTRL + ALT + P",
  kbLock = "CTRL + ALT + L",
  kbShowSidebar = "SUPER + SHIFT + N",

  -- Media: keyboard keys only (bound by caelestia regardless of these)
  kbMediaToggle = "",
  kbMediaNext = "",
  kbMediaPrev = "",
  kbMediaStop = "",
  kbVolumeMute = "",
}
