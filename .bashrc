if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

source /etc/profile.d/autojump.bash

# This is where pretty much all aliases/functions come from.
for file in ~/.shellenv/*.sh; do source $file; done

# Trap command not found (127) and throw it at our github clone hook.
# This lets us clone GitHub repos by just typing the repo path
# (git@github.com...) at the prompt and hitting enter twice :).
trap 'github_clone_trap $BASH_COMMAND' ERR

PS1="\[\e[00m\]\u@\h \$(colored-battery-status) \[\$(cabal_sandbox_color)\]\w\[\e[32m\]\$(parse_git_branch)\[\e[00m\]\$ "
export -n PS1
