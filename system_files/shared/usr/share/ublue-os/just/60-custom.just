configure-mpd:
    #!/usr/bin/bash
    install -d $HOME/.cache/mpd $HOME/.config/mpd/playlists
    install -D -t $HOME/.config/mpDris2 /usr/share/mpDris2/mpDris2.conf
    systemctl --user enable --now mpd.service
    systemctl --user enable --now mpDris2.service
    echo "Next steps:"
    echo "1. Launch Quester"
    echo "2. Refresh Library"
    echo "3. Set the projectM presets directory to /usr/share/projectM/presets"
