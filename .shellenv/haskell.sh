# Haskell
function hackagedl {
  f="$(curl -sq https://hackage.haskell.org/package/$1 | sed -n '/.*strong/{s/.*<strong[^<]*>\([^<]*\)<.*/\1/;p;q}')"
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
