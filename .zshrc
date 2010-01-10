# The following lines were added by compinstall
 
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z} m:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle :compinstall filename '~/.zshrc'
 
autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install
 
# key bindings
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
#bindkey "^H" backward-delete-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix
 
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward
 
autoload colors zsh/terminfo
colors

#setopt prompt_subst
#PROMPT="%{$terminfo[bold]$fg[green]%}[%(?..%{$fg[red]%}%?%{$fg[green]%}|)%{$fg[blue]%}%"'$((30 - ${(e)exit_code})'")<..<%/%{$fg[green]%}]$%{$terminfo[sgr0]%} "


PROMPT="%{$terminfo[bold]$fg[yellow]%}%n%{$terminfo[sgr0]%}@%{$fg[yellow]%}%m%{$fg[default]%}:%{$fg[blue]%}%~%{$fg[default]%}$ "

##### PROMPT STUFF #####
#autoload -U promptinit
#promptinit
#prompt adam2


#RPROMPT="%(?..%{$terminfo[bold]$fg[green]%}[%{$fg[red]%}%?%{$fg[green]%}]%{$terminfo[sgr0]%})"
RPROMPT=""

function chpwd {
case $TERM in
*xterm*|*rxvt*|ansi) print -Pn "\e]2;%/ | %y\a" # better for remote shells: "\e]2;%n@%m: %~\a"
;;
screen) print -Pn "\e_ %/ | %y\e\\" # better for remote shells: "\e_ %n@%m: %~\e\\"
;;
esac
}
 
# Before prompt
function precmd {
 
case $TERM in
*xterm*|*rxvt*|ansi) print -Pn "\e]2;%/ | %y\a" # better for remote shells: "\e]2;%n@%m: %~\a"
;;
screen) print -Pn "\e_ %/ | %y\e\\" # better for remote shells: "\e_ %n@%m: %~\e\\"
;;
esac
}
 
# After enter but before command
function preexec {
case $TERM in
*xterm*|*rxvt*|ansi) print -nPR $'\e]0;'"$1 | %y"$'\a' # better for remote shells: "\e]2;%n@%m: $1\a"
;;
screen) print -nPR $'\e_ '"$1 | %y"$'\e\\' # better for remote shells: "\e_ %n@%m: $1\e\\"
;;
esac
}
 
export EDITOR='vim'
export BROWSER='firefox3'

# Ports-Specific:
alias p='psearch'
alias m='sudo time make config-recursive install clean'
alias mm='sudo time make config-recursive install clean; beep; sleep .07; beep -p 600'
#alias pd="cd /usr/ports$1"
alias pfu='sudo portsnap fetch update'
alias pb='sudo portmaster -Bad'

function pd() { cd /usr/ports/${1} }

# Little stupid things to make life .. nice :)
alias vi='vim'
alias ls='ls -G'
alias i='~/.bin/url.sh'
alias lksc='xscreensaver-command -lock'

# BSD, but not *ports* specific.
alias docup='sudo cvsup -L 2 /etc/supfile'

# X11
alias comp='compiz --replace --sm-disable --ignore-desktop-hints ccp &'

# Git
alias ga='git add'
alias gp='git push'

# Python
alias pyc='rm *.pyc; rm */*.pyc'


stty -ixon -ixoff
 
export GREP_COLOR="1;33"
alias grep='grep --color=auto'
export PATH="/usr/sbin:/usr/local/sbin:$PATH"

export PYTHONSTARTUP=~/.pythonrc 
#export PAGER=vimpager

# GoLang Specific:
function go() {
   NAME=`echo ${1} | cut -d '.' -f 1`
   6g ${1};
   6l -o $NAME $NAME.6;
   rm $NAME.6;
#   echo "'$NAME'"
}
export GOROOT=$HOME/go
export GOARCH=amd64
export GOOS=freebsd
export GOBIN=$HOME/bin

