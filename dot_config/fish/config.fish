#source /usr/share/cachyos-fish-config/cachyos-config.fish
source /home/$USER/.config/fish/conf.d/done.fish
source /home/$USER/.config/fish/conf.d/history.fish

function fish_greeting
    fastfetch
end

# Append common directories for executable files to $PATH
fish_add_path ~/.local/bin ~/.cargo/bin ~/Applications/depot_tools


# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'


#common use stuff
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '


# Replace ls with eza
alias ls='eza -1 --color=always --group-directories-first --icons=always' # preferred listing
alias la='eza -lahH --color=always --group-directories-first --icons=always'  # all files and dirs
alias ll='eza -lhH --color=always --group-directories-first --icons=always'  # long format
alias lt='eza -aT --color=always --group-directories-first --icons=always' # tree listing
alias l.="eza -a | grep -e '^\.'"                                     # show only dotfiles


# Format man pages
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"


# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low


#ruby thingy
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

export EDITOR="vim"

# mise thingy, maybe?
/home/johannes/.local/bin/mise activate fish | source





# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end
