alias ..='cd ..'
alias rpmbuildcurrentdir='/usr/bin/rpmbuild --define "_sourcedir ." --define "_rpmdir ." --define "_builddir `pwd`" --define "_srcrpmdir ." --define "_speccdir ."'
alias rpmbuildcurrentdirmd5='/usr/bin/rpmbuild-md5 --define "_sourcedir ." --define "_rpmdir ." --define "_builddir `pwd`" --define "_srcrpmdir ." --define "_speccdir ."'
alias git='hub'
alias colordiff="sed -e \"s/^-\(.*\)/`echo -e '\033[31m'`-\1`echo -e '\033[0m'`/\" | sed -e \"s/^+\(.*\)/`echo -e '\033[32m'`+\1`echo -e '\033[0m'`/\""
alias sml='rlwrap sml'
alias gitpullall='find . -maxdepth 2 -name .git -type d -execdir git pull \;'
alias sortedlinecount='find -type f -print | xargs wc -l | sort -n'
alias ciod='cabal install --only-dependencies'
alias nix-env-git='nix-env -f ~/devel/nixos/nixpkgs/'
alias gih='gitignore haskell > .gitignore'
alias gpg='gpg2'
alias grpe='grep'

# Java annoyances.
alias sbt8='PATH=/usr/lib/jvm/java-1.8.0-openjdk/bin/:$PATH sbt -java-home /usr/lib/jvm/java-1.8.0-openjdk/'
