# dotfiles
Dotfiles managed by chezmoi

Before you use these, add the following to `~/.config/chezmoi/chezmoi.toml`:
```
[data]
    wallhaven_key = "" # api key for noctalia wallhaven plugin
    bitwarden_server_url = "" # url for noctalia bitwarden plugin (default "https://vault.bitwarden.com")
    wallpaper_path = "" # wallpaper path used by noctalia (default "/home/$USER/Pictures/wallpapers")
    autostart = [] # apps that hyprland will start on startup
    nvidia_gpu = false # used by hyprland in config
```

