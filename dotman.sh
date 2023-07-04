#!/bin/bash
[ ! $1 ] && echo -e "\e[0;31mERROR:\e[0m Option must be provided" && exit 13

# creating structure, 1st parameter is directories, 2nd parameter is base in home directory,
# "" for creating links, "/.dotfiles/Application_Name" for adding files to repository
create_dir_structure() {
	currDir=$home$2
	for dir in $(echo $1 | tr "/" "\n")
	do
		currDir=$currDir"/"$dir
		[ ! -d $currDir ] && mkdir $currDir
	done
}

# Variables
home=$HOME
dotfiles=$home/.dotfiles


# section for installing symlinks from repository
# arg1 = "install" option
# arg2 = application name
if [ $1 == "install" ]; then
  # Checking arguments
  [ ! $2 ] && echo -e "\e[0;31mERROR:\e[0m Application name missed" && exit 13
  [ $2 == '.root' ] && echo -e "\e[0;31mERROR:\e[0m .root directory reserved for 'save' option" && exit 13
  [ ! -d $2 ] && echo -e "\e[0;31mERROR:\e[0m No dotfiles for application \e[0;31m$2\e[0m" && exit 13
  # loop through files in Application folder
  for file in $(find $2"/" -type f)
  do
    source=$(realpath $file)
    # remove Application_Name from path
    file=${file#*$2/}
    # if path contains directory separator - create destination directories structure
    if [[ $file == *"/"* ]]; then
      path=${file%/*}
      create_dir_structure $path ""
    fi
    link=$home"/"$file
    # remove file in home directory if it's existed already
    [ -e $link ] && rm $link
    ln -sf $source $link
  done
  exit 0
fi

# section for adding file to repository and replace it with symlink
# arg1 = "set" option
# arg2 = Application_Name
# arg3 = configuration file name
if [ $1 == 'add' ]; then
  [ ! $2 ] && echo -e "\e[0;31mERROR:\e[0m Application name missed" && exit 13
  [ $2 == '.root' ] && echo -e "\e[0;31mERROR:\e[0m .root name / directory reserved for 'save' option" && exit 13
  [ ! $3 ] && echo -e "\e[0;31mERROR:\e[0m Configuration file missed" && exit 13
  [ ! -f $3 ] && echo -e "\e[0;31mERROR:\e[0m Configuration file \e[0;31m$3\e[0m doesn't exist" && exit 13
  [ -L $3 ] && echo -e "\e[0;31mERROR:\e[0m Configuration file \e[0;31m$3\e[0m already a symlink" && exit 13
  # base to create directory structure$
  link=$(realpath $3)
  file=${link#$home/}
  dotfiles=$dotfiles"/"$2
  source=$dotfiles"/"$file
  [ ! -d $dotfiles ] && mkdir $dotfiles
  # if path contains directory separator - create destination directories structure
  if [[ $file == *"/"* ]]; then
    path=${file%/*}
    create_dir_structure $path "/.dotfiles/"$2
  fi
  mv $link $source
  ln -sf $source $link
  exit 0
fi

# section for saving config files from other system direcotories
# arg1 = "save" option
# arg2 = file to be saved in .dotfiles/.root/.../.../...
if [ $1 == 'save' ]; then
  [ ! $2 ] && echo -e "\e[0;31mERROR:\e[0m File name missed" && exit 13
  [ ! -f $2 ] && echo -e "\e[0;31mERROR:\e[0m Configuration file \e[0;31m$2\e[0m doesn't exist" && exit 13
  [ ! -d $dotfiles"/.root" ] && mkdir $dotfiles"/.root"
  source=$(realpath $2)
  copy=$dotfiles"/.root"$source
  file=${source#*/}
  if [[ $file == *"/"* ]]; then
    path=${file%/*}
    create_dir_structure $path "/.dotfiles/.root"
  fi
  cp $source $copy
  exit 0
fi

# section for restoring config files from other system direcotories
# arg1 = "restore" option
# arg2 = file to be resotred in /
# if file located not in home directory, cp command will be run with sudo priviledges
# in this directories structure doesn't created, you must make it manually if necessary
# in home directory structure will be created
if [ $1 == 'restore' ]; then
  [ ! $2 ] && echo -e "\e[0;31mERROR:\e[0m File name missed" && exit 13
  [ ! -f $2 ] && echo -e "\e[0;31mERROR:\e[0m Configuration file \e[0;31m$2\e[0m doesn't exist" && exit 13
  source=$(realpath $2)
	file=${source#$dotfiles/.root/}
	prefix=${file%%/*}
	if [ "$prefix" == 'home' ]; then
		file=${file#*/*/}
	  if [[ $file == *"/"* ]]; then
      path=${file%/*}
			create_dir_structure $path ""
    fi
		cp -v $source $home/$file
	else
		destdir=/${file%/*}
		# if destination directory doesn't exist, error and stop
		[ ! -d $destdir ] && echo -e "\e[0;31mERROR:\e[0m Directory \e[0;31m$destdir\e[0m doesn't exist" && exit 13
		sudo cp $source $destdir/
	fi
 	exit 0
fi

# Error when no valid options provided
echo -e "\e[0;31mERROR:\e[0m Wrong option: \e[0;31m$1\e[0m" && exit 13


