#!/usr/bin/env bash

if [ $# -eq 0 ] ; then
  echo "Usage:
  ./pullpush.sh 'the commit message'"
  exit
fi

# give correct permission
# chmod a+rx `find . -name '*.rb' -type f`
# chmod -R a+r views/*
# chmod -R a+r public/*

# add and commit all files
git add .
git status
read -p " Press Ctrl+C to exit, press any enter key to check the diff..
"

# recheck again
git diff --staged
echo 'Going to commit with message: '\"$*\"
read -p " Press Ctrl+C to exit, press any enter key to really commit..
"

git commit -m "$*" && git pull --no-edit && git push origin main
