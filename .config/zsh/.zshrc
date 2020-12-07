##########
##Prompt##
##########

# Git integration
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr 'S'
zstyle ':vcs_info:*' unstagedstr 'U'

zstyle ':vcs_info:git:*' formats '%B  %F{15} %r %F{6} %b %F{2}%u %c'

RPROMPT='$vcs_info_msg_0_'

# New line after every prompt
precmd() {
    precmd() {
        echo
    }
}

export PS1=$'%B%F{4}%~\n%F{5}%m%F{6}@%F{12}%n %(?.%F{6}.%F{1})❯ %F{reset}%b'

###########
##PLUGINS##
###########

# build plugins path if not exist
[ ! -d $ZDOTDIR/plugins ] && mkdir $ZDOTDIR/plugins

# auto suggestions
[ ! -d $ZDOTDIR/plugins/zsh-autosuggestions ] && git clone https://github.com/zsh-users/zsh-autosuggestions $ZDOTDIR/plugins/zsh-autosuggestions
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# syntax highlighting like fish
[ ! -d $ZDOTDIR/plugins/zsh-syntax-highlighting ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZDOTDIR/plugins/zsh-syntax-highlighting
source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

# autojump
source /usr/share/autojump/autojump.zsh

################
##KEY BINDINGS##
################

bindkey "^H" backward-char
bindkey "^L" forward-char
bindkey "^K" history-beginning-search-forward
bindkey "^J" history-beginning-search-backward
bindkey '^ ' autosuggest-execute

#################
##CONFIGURATION##
#################

# History
setopt INC_APPEND_HISTORY_TIME
setopt EXTENDED_HISTORY

# Load aliases if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/aliasrc"

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Yank to the system clipboard
function vi-yank-xclip {
    zle vi-yank
   echo "$CUTBUFFER" | xclip -selection clipboard
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
