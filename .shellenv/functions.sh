# Misc functions

function pushj {
  pushd "$(j -b "$1")"
}

function upload {
  if [ ! -f "$1"  -a  ! -d "$1" ]; then
    return 1
  fi
  if [ "$2" != "" ]; then
    destination="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$2")"
  else
    destination="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$(basename "$1")")"
  fi
  rsync -q --partial -avzre ssh "$1" elrod.me:/srv/webmount/tmp/"$destination" &&
    echo "http://tmp.elrod.me/$destination"
}

function parse_git_branch {
  command git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function colored-battery-status {
  # This is way faster than cut+sed, though it looks more hideous.
  acpi="$(acpi -b 2>/dev/null)"
  if [ $? -ne 0 ]; then
      return 10
  fi
  if [[ "$acpi" == *"Charging"* ]]; then
      echo -ne "\x01\e[1;33m\x02⚡\x01\e[0m\x02"
  fi
  level="${acpi#Battery*,\ }"
  level="${level%\%*}"
  if [ $level -gt 60 ]; then
      echo -ne "\x01\e[0;32m\x02"
  elif [ $level -gt 40 ]; then
      echo -ne "\x01\e[0;33m\x02"
  elif [ $level -gt 20 ]; then
      echo -ne "\x01\e[0;34m\x02"
  else
      echo -ne "\x01\e[0;31m\x02"
  fi
  echo -ne "$level\x01\e[0m\x02%"
}

function ghpages-init {
    if [ "$1" == "" ]; then
        echo "Usage: ghpages-init username/reponame"
        return 1
    fi
    dir="$(mktemp -d)"
    git clone "ssh://git@github.com/$1" "$dir/repo"
    pushd "$dir/repo"
    git ls-remote | grep gh-pages
    if [ $? == 0 ]; then
        echo "gh-pages exists already. Aborting!"
        popd
        rm -rf "$dir"
        return 1
    else
        git checkout --orphan gh-pages
        git rm -rf .
        echo "hello!" > index.html
        git add index.html
        git commit -m 'Initialize gh-pages'
        git push origin gh-pages
        popd
        rm -rf "$dir"
    fi
}

function create-haskell-repo {
    if [ $# -ne 2 ]; then
        echo "Usage: $FUNCNAME reponame description"
        return 1
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
    git add .
    git commit -sm "Initial commit."
    git push -u origin master
    ghpages-init "relrod/$1"
}

function shellcheckurl {
  url="$1"
  echo "$url" | grep -sq 'github.com/'
  if [ $? -eq 0 ]; then
    url="$(echo "$url" | sed 's/\/blob\//\/raw\//')"
  fi
  curl -sL "$url" | shellcheck -
}

# This lets us do multiple invocations of some single command with different
# arugments. For example, `cabal` has no way to combine commands, e.g.
# `cabal clean build`. You end up needing to do `cabal clean && cabal build`.
function s {
  cmd=""
  ran=0
  for i in "$@"; do
    if [ $ran -eq 0 ]; then
      ran=1
      cmd="$i"
    else
      $1 $i
      if [ $? != 0 ]; then
        break
      else
        continue
      fi
    fi
  done
}

# This does the same thing as `s` above, except it doesn't bail out if one of
# the commands fails.
function ss {
  cmd=""
  ran=0
  for i in "$@"; do
    if [ $ran -eq 0 ]; then
      ran=1
      cmd="$i"
    else
      $1 $i
    fi
  done
}
