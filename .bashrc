if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#source /etc/profile.d/autojump.bash
source <(pagure --bash-completion-script `which pagure`)

# This is where pretty much all aliases/functions come from.
for file in ~/.shellenv/*.sh; do source $file; done

# Trap command not found (127) and throw it at our github clone hook.
# This lets us clone GitHub repos by just typing the repo path
# (git@github.com...) at the prompt and hitting enter twice :).
trap 'github_clone_trap $BASH_COMMAND' ERR

PS1="\[\e[00m\]\u@\h \$(colored-battery-status) \[\$(cabal_sandbox_color)\]\w\[\e[32m\]\$(parse_git_branch)\[\e[00m\]\$ "
export -n PS1

PATH="/home/ricky/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/ricky/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/ricky/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/ricky/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/ricky/perl5"; export PERL_MM_OPT;
