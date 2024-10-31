#!/bin/bash
[ ! $1 ] && echo -e "\e[0;31mERROR:\e[0m Please provide project name" && exit 13

project=$1
projectDir=$HOME"/code/haskell/"$1
if [ -d $projectDir ]; then
    echo -e "\e[0;31mERROR:\e[0m Project already exists" && exit 13
fi
mkdir $projectDir
cd $projectDir
cp ~/.dotfiles/haskell/.gitignore .
cp ~/.dotfiles/haskell/.stylish-haskell.yaml .
cabal init  .
echo -e ""
git init
git add .
git commit -m "Project created"
cd $projectDir
cho -e ""
echo -e "\e[0;33mDONE\e[0m"
