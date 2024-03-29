export SHELL=zsh
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [[ -z "$TMUX" ]] && [[ -z "$TERM_PROGRAM" ]]; then
    tmux a -t "main" 2> /dev/null
    if [ $? != 0 ]; then
        tmux new-session -s "main" 2> /dev/null
    fi
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git themes zsh-autosuggestions zsh-syntax-highlighting)

DISABLE_AUTO_UPDATE=true source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.profile ] && source ~/.profile

cdf() {
    local result=$(dirname $(FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden" fzf --preview="ls -la --color \$(dirname {})") 2> /dev/null)
    if ! [ "$result" = "" ]; then
        cd $result
    fi
}

gitlog() {
    git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)<%an>%Creset' --abbrev-commit
}

HISTFILE="$HOME/.zsh_history"
HISTSIZE=2147483647
SAVEHIST=$HISTSIZE
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
unsetopt HIST_BEEP
unsetopt BEEP

bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word

alias v=vim
alias n=nvim
alias nv=nvim

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none

[ -f ~/.zshrc-local ] && source ~/.zshrc-local
