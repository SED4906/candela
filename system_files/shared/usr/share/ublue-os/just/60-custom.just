configure-mpd:
    #!/usr/bin/bash
    sudo install -o $USER -d /var/lib/mpd/{,music,playlists}
    sudo install -o $USER -d /var/log/mpd
    systemctl --user restart mpd.service
    install -D -t $HOME/.config/mpDris2 /usr/share/mpDris2/mpDris2.conf
    systemctl --user enable --now mpDris2.service
    echo "Next steps:"
    echo "1. Copy your (properly tagged) music library into /var/lib/mpd/music"
    echo "1a. Run ‘mpc rescan’"
    echo "2. Launch Quester"
    echo "2a. Refresh Library"
    echo "2b. Set the projectM presets directory to /usr/share/projectM/presets"
