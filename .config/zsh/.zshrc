##########
##Prompt##
##########

# Git integration
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
#RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr 'STAGED'
zstyle ':vcs_info:*' unstagedstr 'UNSTAGED'

zstyle ':vcs_info:git:*' formats ' %F{gray} %r %F{cyan} %b %u %c'
patch_format="anan"
nopatch_format="baban"
setopt promptsubst

# New line after every prompt
precmd() {
    precmd() {
        echo
    }
}

export PS1=$'%F{blue}%~$vcs_info_msg_0_\n%F{white}%m%F{white}@%F{white}%n %(?.%F{cyan}.%F{red})❯ %F{white}'

###########
##PLUGINS##
###########

# Source zsh-auto-suggestions
source $ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh

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
