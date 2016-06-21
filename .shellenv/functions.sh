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
  rsync -q --partial --chmod=o+r -avzre ssh "$1" elrod.me:/srv/webmount/tmp/"$destination" &&
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

# Download a paper from the ACM DL via the YSU gemini server.
# (or whatever $CAMPUS_SERVER is set to below)
function acmpaper {
  CAMPUS_SERVER="gemini.csis.ysu.edu"

  if [ "$1" == "" ]; then
    echo "Usage: acmpaper https://dl.acm.org/..."
    return 1
  fi

  src="$(curl -s "$1")"
  title="$(echo "$src" | grep '<title>' | sed -r 's/^<title>([^<]+).+$/\1/')"
  pdfurl="$(echo "$src" | grep 'citation_pdf_url' \
                        | sed 's/.*citation_pdf_url" content="//g' \
                        | sed 's/".*//g' \
                        | sed 's/http:/https:/')"
  cmd="curl -Lo \"$title.pdf\" \"$pdfurl\""
  echo "$cmd"
  ssh "$CAMPUS_SERVER" "$cmd"
  if [ $? -ne 0 ]; then
    echo "Something went wrong when trying to download the PDF."
    echo "Examine the above output and retry."
    return 1
  fi
  # Otherwise if ssh returns successfully, copy the file and rm the source.
  scp "$CAMPUS_SERVER:\"$title.pdf\"" .
  ssh "$CAMPUS_SERVER" "rm \"$title.pdf\""
}

function github_clone_trap {
  if [[ $? == 127 && "$1" =~ ^git@github\.com.* ]]; then
    read -p "About to clone $1 from github... Continue? [Y/n]" -n 1 -r
    if [[ "$REPLY" == "" || "$REPLY" =~ ^[Yy]$ ]]; then
      git clone "$1"
    fi
  fi
}

function git-clone-org {
  f="$(curl -s "https://api.github.com/orgs/$1/repos?per_page=200" | jq '.[] .name')"
  for repo in $f; do
    repo="$(echo "$repo" | sed 's/"//g')"
    fullrepo="$1/$repo"
    if [ ! -d "$repo" ]; then
      echo ">> $repo <<"
      # this assumes `hub` is installed.
      git clone "$fullrepo"
    else
      pushd "$repo"
      git pull
      popd
    fi
  done
}
