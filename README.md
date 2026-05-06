# Candela

A customized Universal Blue image with niri as the default compositor.
The name and logo are derived from the niri logo (CC BY-SA 4.0), which is a candle flame.
The logo also uses the visual representation of a [solid angle](https://commons.wikimedia.org/wiki/File:Angle_solide_coordonnees.svg) (CC BY-SA 3.0) from Wikipedia.

A candela is the metric unit of luminous intensity, equal to lumens per steradian.

This is intended for personal use, primarily on my Surface Go 3, and on my main computer as a daily driver.

Therefore, it's rather opinionated:
- A dark theme is applied by default.
- I've opted to use nwggrid as the launcher instead of fuzzel, and wezterm as the terminal instead of alacritty.
- Included software:
    - Firefox, a web browser.
    - Gram, a code editor.
    - Kvantum Manager, a theme selector.
    - Qt6 Settings, a theme selector.
    - Quester (not configured, run `ujust configure-mpd` first), a music player.
- Preinstalled flatpaks, downloaded on first boot:
    - Bazaar, a flatpak installer. Use this to install most software.
    - Kate, a text editor.
    - Loupe, an image viewer. Displayed as "Image Viewer" in the launcher.
    - Mission Center, a task manager.
- Self-explanatory included software:
    - Bluetooth Manager
    - Disks
    - Files
    - Network Manager Applet
    - Volume Control
- Homebrew is included for installing command-line tools.
- Nix is not included, but works; see [Lix](https://lix.systems/).
- Firefox is preconfigured:
    - to preinstall uBlock Origin.
    - to use DuckDuckGo as the default search engine.
    - to remove shopping and slop "search engines".
    - to disable AI features.
    - to disable saving usernames and passwords.
    - to declutter the home page.
- swaylock-plugin is configured to show a random screensaver from wscreensaver.
    - swaylock is also present as a backup locker if swaylock-plugin crashes.
    - swaylock is configured to show a black screen with a lock icon in the center.
        - The icon was created by nephros (CC BY 2.0), and is from the Gentoo icons.
