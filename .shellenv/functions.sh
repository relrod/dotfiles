# Misc functions

function pushj {
  pushd `j -b "$1"`
}

function upload {
  if [ ! -f "$1" ]; then
    return 1
  fi
  if [ "$2" != "" ]; then
    destination="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$2")"
  else
    destination="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$(basename "$1")")"
  fi
  rsync --progress --partial -avzre ssh "$1" elrod.me:/srv/webmount/tmp/"$destination" &&
    echo "http://tmp.elrod.me/$destination"
}

function parse_git_branch {
  command git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
