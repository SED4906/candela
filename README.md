# Candela

A customized Universal Blue image with niri as the default compositor.
The name and logo are derived from the niri logo (CC BY-SA 4.0), which is a candle flame. A candela is the metric unit of luminous intensity.

This is intended for personal use, primarily on my Surface Go 3.

Therefore, it's rather opinionated:
- A dark theme is applied by default.
- I've opted to use nwggrid as the launcher instead of fuzzel.
- Bazaar, Kate, Loupe, and Mission Center are the preinstalled flatpaks.
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

## Music Player Daemon

To set up Music Player Daemon for use with Quester:

1. `sudo install -o $USER -d /var/lib/mpd`
2. `sudo install -o $USER -d /var/log/mpd`
3. `mkdir /var/lib/mpd/{music,playlists}`
4. Copy your (properly tagged) music library into `/var/lib/mpd/music/`
5. `mpc rescan`
6. Launch Quester
7. Refresh Library
8. Set the projectM preset directory to `/usr/share/projectM/presets`
