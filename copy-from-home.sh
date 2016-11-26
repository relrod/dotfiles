#!/usr/bin/env bash
cp -v ~/.Xdefaults .
cp -v ~/.bashrc .
cp -rv ~/.shellenv .
cp -v ~/devel/haskell/haddock-deploy-template.sh .
mkdir -p .emacs.d
cp -v ~/.emacs.d/etymology.el ./.emacs.d/

echo "Staging in git"
find -name '.*' -a -\! -name '.git' -a -\! -name '.' -print | xargs git add -v
git add -v copy-from-home.sh
echo
echo
git status
echo
echo
echo "Done."
