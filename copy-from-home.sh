#!/usr/bin/env bash
cp -v ~/.Xdefaults .
cp -v ~/.bashrc .
cp -rv ~/.shellenv .

echo "Staging in git"
find -name '.*' -a -\! -name '.git' -a -\! -name '.' -print | xargs git add -v
git add -v copy-from-home.sh
echo
echo
git status
echo
echo
echo "Done."
