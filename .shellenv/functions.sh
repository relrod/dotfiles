# Misc functions

function pushj {
  pushd `j -b "$1"`
}

function upload {
  if [ ! -f "$1" ]; then
    return 1
  fi
  rsync --progress --partial -avzre ssh "$1" elrod.me:/srv/webmount/tmp/ &&
    echo "http://tmp.elrod.me/$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$(basename "$1")")"
}

function parse_git_branch {
  command git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
