# Candela

A customized Universal Blue image with niri as the default compositor.
The name and logo are derived from the niri logo (CC BY-SA 4.0), which is a candle flame.
The logo also uses the visual representation of a [solid angle](https://commons.wikimedia.org/wiki/File:Angle_solide_coordonnees.svg) (CC BY-SA 3.0) from Wikipedia.

A candela is the metric unit of luminous intensity, equal to lumens per steradian.

This is intended for personal use.

Therefore, it's rather opinionated:
- A dark theme is applied by default.
- Caps Lock as Compose, Right Alt as AltGr, and Right Control as Hyper.
    - Hyper+Left/Right navigates between columns.
    - Hyper+Up/Down navigates between workspaces.
- I've opted to use nwggrid as the launcher instead of fuzzel, and wezterm as the terminal instead of alacritty.
- Included software:
    - Qt6 Settings, a theme selector.
    - WezTerm, a terminal emulator.
    - [System Control](https://github.com/SED4906/systemcontrol/), a service manager.
- Preinstalled flatpaks, downloaded on first boot:
    - Bazaar, a flatpak installer. Use this to install most software.
    - Firefox, a web browser.
    - Mission Center, a task manager.
- Self-explanatory included software:
    - Bluetooth Manager
    - Disks
    - Files
    - Image Viewer/"Loupe" (flatpak)
    - KWrite (flatpak)
    - Network Manager Applet
    - VLC media player (flatpak)
    - PulseAudio Volume Control
- Nix is not included, but works; see [Lix](https://lix.systems/).
- Firefox is preconfigured:
    - to preinstall uBlock Origin.
    - to use DuckDuckGo as the default search engine.
    - to remove shopping and slop "search engines".
    - to disable AI features.
    - to disable saving usernames and passwords.
    - to declutter the home page.
- swaylock is configured to show a black screen with a lock icon in the center.
    - The icon was created by nephros (CC BY 2.0), and is from the Gentoo icons.
