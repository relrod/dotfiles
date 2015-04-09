# Haskell
function hackagedl {
  f="$(curl -sq https://hackage.haskell.org/package/"$1" | sed -n '/.*strong/{s/.*<strong[^<]*>\([^<]*\)<.*/\1/;p;q}')"
  if [ "$f" == "" ]; then
    echo "That package doesn't seem to exist, or something went wrong."
    return 1
  fi
  curl -o "$1-$f.tar.gz" "https://hackage.haskell.org/package/$1-$f/$1-$f.tar.gz"
  echo "Done."
}

function cabal_sandbox_color {
  if [ -f "cabal.sandbox.config" -a -d ".cabal-sandbox" ]; then
    echo -e -n "\e[1;32m"
  else
    echo -e -n "\e[1;34m"
  fi
}

function create-haskell-repo {
    if [ $# -ne 2 ]; then
        echo "Usage: $FUNCNAME reponame description"
        return 1
    fi
    if [ "$1" != "$(basename `pwd`)" ]; then
      echo "Current directory name does NOT match project name."
      echo "Select one: 1. Create new directory for this project"
      echo "            2. Create project here anyway"
      echo "Press control-c to abort."
      read choice
      if [ "$choice" == "1" ]; then
        mkdir "$1" && cd "$1"
      elif [ "$choice" != "2" ]; then
        echo "Invalid choice, aborting."
        return 1
      fi
    fi
    echo -ne "\x01\e[0;32m\x02Creating git repository\x01\e[0m\x02\n"
    git init
    echo -ne "\x01\e[0;32m\x02Creating it on GitHub\x01\e[0m\x02\n"
    git create "$1" -d "$2" -h "https://relrod.github.io/$1"
    echo -ne "\x01\e[0;32m\x02Adding haddock deploy-to-GitHub script\x01\e[0m\x02\n"
    mkdir scripts
    cat ~/devel/haskell/haddock-deploy-template.sh | sed "s/{{NAME}}/$1/g" > scripts/deploy-haddock-manually.sh
    chmod +x scripts/*
    echo -ne "\x01\e[0;32m\x02Initializing .gitignore file\x01\e[0m\x02\n"
    echo -ne "\x01\e[0;32m\x02Running 'cabal init'\x01\e[0m\x02\n"
    mkdir src
    cabal init -l BSD2 --no-comments --source-dir=src -u "https://github.com/relrod/$1" -s "$2"
    gitignore haskell > .gitignore
    git add .
    git commit -sm "Initial commit."
    git push -u origin master
    ghpages-init "relrod/$1"
}

function :t {
  ghc -e ":t $@"
}

function :k {
  ghc -e ":k $@"
}
