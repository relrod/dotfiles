# Useful Fedora related aliases/functions

export FAS_USERNAME='codeblock'

alias getsources='spectool -g -A'
alias mypkgs="pkgdb-cli list --user $FAS_USERNAME"
alias pingallproxies='fping proxy01.fedoraproject.org proxy02.fedoraproject.org proxy03.fedoraproject.org proxy04.fedoraproject.org proxy05.fedoraproject.org proxy06.fedoraproject.org proxy07.fedoraproject.org proxy08.fedoraproject.org proxy09.fedoraproject.org'

function peoplepackage {
  ssh fedorapeople.org "mkdir public_html/packages/$1"
  if ls "$1"*".src.rpm" &> /dev/null && ls "$1"*".spec" &> /dev/null; then
    scp "$1"*".src.rpm" "$1"*".spec" "fedorapeople.org:public_html/packages/$1/"
    echo "---"
    echo -n "Review Request: $1 - "
      rpmspec "$1"*".spec" -q --queryformat '%{summary}\n' | head -1
    echo "---"
    echo -n "Spec URL: http://codeblock.fedorapeople.org/packages/$1/"
      echo "$1"*".spec"
    echo -n "SRPM URL: http://codeblock.fedorapeople.org/packages/$1/"
      echo "$1"*".src.rpm"
    echo "Description: "
    rpmspec "$1"*".spec" -q --queryformat '%{description}\n' | sed -e '/./!Q'
    echo
    echo "Fedora Account System Username: $FAS_USERNAME"
    echo "---"
    echo
    echo "Paste above template to https://bugzilla.redhat.com/enter_bug.cgi?product=Fedora&format=fedora-review"
  else
    echo "$1*.src.rpm or $1.spec not found."
  fi
}

function unmonpkgs {
  f=`mktemp`
  curl -so $f "https://fedoraproject.org/wiki/Upstream_release_monitoring"
  for i in `pkgdb-cli list --user "$FAS_USERNAME" | head -n -1 | awk "{print \\\$1}"`; do
    grep "\* $i " $f >/dev/null || echo "Not found: $i"
  done
  rm $f
}

function unmonpkgs_slow {
  f="$(mktemp)"
  curl -s "https://fedoraproject.org/wiki/Upstream_release_monitoring" | grep '^ * ' | awk '{print $2}' > "$f"
  for i in $(pkgdb-cli list --user "$FAS_USERNAME" | head -n -1 | awk "{print \$1}"); do
    grep "^$i\$" "$f" > /dev/null
    if [ "$?" != "0" ]; then
        echo -e "\033[1;31m$i\033[0m"
        while read line; do
          [ "$line" == "" ] && continue
          [ "$line" == " " ] && continue
          (echo "$line" | grep '\*' > /dev/null) || continue
          (echo "$i" | grep "^$line" > /dev/null) &&
            echo -e " ...\033[1;33m   Possible match (\033[1;31m$i\033[0m): $line\033[0m"
        done < "$f"
    fi
  done
  rm "$f"
}

function merge-everything {
  currentbranch=$(git rev-parse --abbrev-ref HEAD)
  for branch in $(git branch | grep -v "$currentbranch"); do
    git checkout "$branch"
    git merge "$currentbranch"
    git push
    fedpkg build
    if [ "$?" -gt 0 ]; then
      echo "Failed to build the package on branch $branch - aborting mission."
      break
    fi
  done
}

# NOTE: This is controversial and probably shouldn't exist, and you're probably
# a bad person if you use it.
function import-from-url {
  tmp="$(mktemp --suffix=.src.rpm)"
  curl -o "$tmp" "$1"
  fedpkg import "$tmp"
  rm "$tmp"
}

function rpmwhich {
  rpm -qf "$(which $1)"
}
