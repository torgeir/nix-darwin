{ config, lib, pkgs, ... }:

{

  home.packages = [ pkgs.unstable.aerospace pkgs.unstable.jankyborders ];

  home.file.".aerospace.toml" = {
    onChange = "/etc/profiles/per-user/torgeir/bin/aerospace reload-config";
    text = ''
      # Place a copy of this config to ~/.aerospace.toml
      # After that, you can edit ~/.aerospace.toml to your liking
      # It's not necessary to copy all keys to your config.
      # If the key is missing in your config, "default-config.toml" will serve as a fallback
      # You can use it to add commands that run after login to macOS user session.
      # 'start-at-login' needs to be 'true' for 'after-login-command' to work
      start-at-login = true
      # Available commands: https://nikitabobko.github.io/AeroSpace/commands
      after-login-command = []
      # You can use it to add commands that run after AeroSpace startup.
      # 'after-startup-command' is run after 'after-login-command'
      # Available commands : https://nikitabobko.github.io/AeroSpace/commands
      after-startup-command = [
          'exec-and-forget /etc/profiles/per-user/torgeir/bin/borders active_color=0xffff7700 inactive_color=0xff333333 width=5.0'
      ]

      # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
      enable-normalization-flatten-containers = true
      enable-normalization-opposite-orientation-for-nested-containers = true

      # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
      # The 'accordion-padding' specifies the size of accordion padding
      # You can set 0 to disable the padding feature
      accordion-padding = 30

      # Possible values: tiles|accordion
      default-root-container-layout = 'tiles'

      # Possible values: horizontal|vertical|auto
      # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
      #               tall monitor (anything higher than wide) gets vertical orientation
      default-root-container-orientation = 'auto'

      # Possible values: (qwerty|dvorak)
      # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
      key-mapping.preset = 'qwerty'

      # Mouse follows focus when focused monitor changes
      # Drop it from your config, if you don't like this behavior
      # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
      # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
      on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

      # Gaps between windows (inner-*) and between monitor edges (outer-*).
      # Possible values:
      # - Constant:     gaps.outer.top = 8
      # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
      #                 In this example, 24 is a default value when there is no match.
      #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
      #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
      [gaps]
      inner.horizontal = 0
      inner.vertical =   0
      outer.top = 6
      outer.bottom = 6
      outer.right = [
        { monitor.phl = 900 },
        { monitor."built-in" = 6 },
        6
      ]
      outer.left = [
        { monitor.phl = 1200 },
        { monitor."built-in" = 6 },
        6
      ]

      # https://nikitabobko.github.io/AeroSpace/guide#default-config
      # 'main' binding mode must be always presented
      # All possible keys:
      # - Letters.        a, b, c, ..., z
      # - Numbers.        0, 1, 2, ..., 9
      # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
      # - F-keys.         f1, f2, ..., f20
      # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
      #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
      # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
      #                   keypadMinus, keypadMultiply, keypadPlus
      # - Arrows.         left, down, up, right

      # All possible modifiers: cmd, alt, ctrl, shift

      # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

      # See: https://nikitabobko.github.io/AeroSpace/commands#exec-and-forget
      # You can uncomment the following lines to open up terminal with alt + enter shortcut (like in i3)
      # alt-enter = '''exec-and-forget osascript -e '
      # tell application "Terminal"
      #     do script
      #     activate
      # end tell'
      # '''……
      [mode.main.binding]
      # disable hide apps
      #cmd-h = [] # Disable "hide application"
      cmd-alt-h = [] # Disable "hide others"

      # similar fn- binds use skhd
      shift-alt-ctrl-cmd-e = 'exec-and-forget open -a emacs'
      shift-alt-ctrl-cmd-i = 'exec-and-forget open -a Firefox\ Developer\ Edition'
      shift-alt-ctrl-cmd-c = 'exec-and-forget open -a IntelliJ\ IDEA'
      shift-alt-ctrl-cmd-o = 'exec-and-forget open -a Microsoft\ Outlook'
      shift-alt-ctrl-cmd-t = 'exec-and-forget open -a Alacritty'
      shift-alt-ctrl-cmd-s = 'exec-and-forget open -a Slack'
      shift-alt-ctrl-cmd-m = 'exec-and-forget open -a Spotify'
      shift-alt-ctrl-cmd-p = 'exec-and-forget open -a 1Password'

      cmd-shift-enter = 'exec-and-forget open -na Firefox\ Developer\ Edition'

      cmd-ctrl-enter = 'exec-and-forget open -a Alacritty'
      cmd-ctrl-shift-enter = 'exec-and-forget open -na Alacritty'
      cmd-shift-h = 'exec-and-forget open -a Finder -- ~/'
      cmd-shift-w = 'exec-and-forget open -a Finder -- ~/Downloads'

      alt-shift-m = 'fullscreen'

      # See: https://nikitabobko.github.io/AeroSpace/commands#focus
      alt-h = 'focus --boundaries all-monitors-outer-frame left'
      alt-j = 'focus --boundaries all-monitors-outer-frame down'
      alt-k = 'focus --boundaries all-monitors-outer-frame up'
      alt-l = 'focus --boundaries all-monitors-outer-frame right'

      # See: https://nikitabobko.github.io/AeroSpace/commands#move
      alt-shift-h = 'move --boundaries all-monitors-outer-frame left'
      alt-shift-j = 'move --boundaries all-monitors-outer-frame down'
      alt-shift-k = 'move --boundaries all-monitors-outer-frame up'
      alt-shift-l = 'move --boundaries all-monitors-outer-frame right'

      # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
      alt-0 = 'workspace 0'
      alt-1 = 'workspace 1'
      alt-2 = 'workspace 2'
      alt-3 = 'workspace 3'
      alt-4 = 'workspace 4'
      alt-5 = 'workspace 5'
      alt-6 = 'workspace 6'
      # alt-7 conflicts with | on a norwegian keyboard
      # alt-8 conflicts with [
      # alt-9 confligts with ]

      # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
      alt-shift-0 = ['move-node-to-workspace 0', "workspace 0"]
      alt-shift-1 = ['move-node-to-workspace 1', "workspace 1"]
      alt-shift-2 = ['move-node-to-workspace 2', "workspace 2"]
      alt-shift-3 = ['move-node-to-workspace 3', "workspace 3"]
      alt-shift-4 = ['move-node-to-workspace 4', "workspace 4"]
      alt-shift-5 = ['move-node-to-workspace 5', "workspace 5"]
      alt-shift-6 = ['move-node-to-workspace 6', "workspace 6"]

      # https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
      alt-tab = 'workspace-back-and-forth'
      alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'
      alt-shift-f = 'layout floating tiling'

      # https://nikitabobko.github.io/AeroSpace/commands#mode
      alt-shift-c = 'reload-config'
      ctrl-alt-c = 'reload-config'
      alt-shift-comma = 'mode service'
      # https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      [mode.service.binding]
      esc = ['mode main']
      r = ['reload-config', 'mode main']
      # https://nikitabobko.github.io/AeroSpace/commands#layout
      a = ['layout accordion horizontal vertical']
      s = ['layout tiles h_tiles v_tiles']
      f = ['layout tiling floating']
      equal = ['balance-sizes', 'mode main']
      # put windows in direction under same parent
      alt-shift-h = ['join-with left', 'mode main']
      alt-shift-j = ['join-with down', 'mode main']
      alt-shift-k = ['join-with up', 'mode main']
      alt-shift-l = ['join-with right', 'mode main']

      cmd-ctrl-alt-p = 'move-node-to-monitor next'


      [workspace-to-monitor-force-assignment]
      1 = 'main'
      2 = 'main'
      3 = 'main'
      4 = 'main'
      5 = 'main'
      # aerospace list-monitors
      6 = ['benq', 'ls32', 'len', 'hp', 'phl', 'main']
      # stop at >6 due to keybind coflicts on norwegian keyboards
      0 = ['built-in', 'main']

      # aerospace list-apps
      [[on-window-detected]]
      if.app-name-regex-substring = '1password'
      # popups are useful where you are
      if.during-aerospace-startup = true
      run = 'move-node-to-workspace 0'
      [[on-window-detected]]
      if.app-name-regex-substring = 'firefox'
      run = 'move-node-to-workspace 1'
      [[on-window-detected]]
      if.app-name-regex-substring = 'emacs'
      run = 'move-node-to-workspace 2'
      [[on-window-detected]]
      if.app-name-regex-substring = 'alacritty'
      # terminals are useful where you need them
      if.during-aerospace-startup = true
      run = 'move-node-to-workspace 3'
      [[on-window-detected]]
      if.app-name-regex-substring = 'idea'
      run = 'move-node-to-workspace 4'
      [[on-window-detected]]
      if.app-name-regex-substring = 'outlook'
      run = 'move-node-to-workspace 5'
      [[on-window-detected]]
      if.app-name-regex-substring = 'spotify'
      run = 'move-node-to-workspace 6'
      # [[on-window-detected]]
      # if.app-id = 'com.tinyspeck.slackmacgap'
      # run = 'move-node-to-workspace 0'
    '';
  };
}
