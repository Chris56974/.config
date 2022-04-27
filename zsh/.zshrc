autoload -U colors && colors	# enable colors

# Make my prompt more colorful
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# man zshoptions
# autocd will automatically type cd for you when you give it a path
# stty stop undef will disable ctrl-s to freeze terminal 
# menucomplete will take the first match if 2 files same name
setopt autocd	extendedglob nomatch menucomplete
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments
zle_highlight=('paste:none') # stop highlighting everything I paste into terminal

# Load aliases and shortcuts if existent.
source "${XDG_CONFIG_HOME}/shell/shortcutrc"
source "${XDG_CONFIG_HOME}/shell/aliasrc"
source "${XDG_CONFIG_HOME}/shell/zshnameddirrc"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}

zle -N zle-keymap-select

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}

zle -N zle-line-init 
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# use lf to switch directories
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

bindkey -s '^o' 'lfcd\n'   # ctrl-o brings up lf
bindkey -s '^a' 'bc -lq\n' # calculator
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n' # go to file
bindkey -s '^E' end-of-line
bindkey '^[[P' delete-char 

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

source "$ZDOTDIR/zsh-functions"

zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"

eval "$(zoxide init zsh)"
