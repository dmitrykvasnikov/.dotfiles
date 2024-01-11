# Dotman


Collection of my dotfiles / configs and simple script to manage it.
Idea of **dotman.sh** was taken from **stow** project.

## Concept
All of your files are kept in /home/user/.dotfiles directory.
When you add file to your .dotfiles with **"add"** option (see below),
config file is moved to **.dotfiles/app_name** folder keeping directories structure
below your /home/user directory, and then replaces with symlink to file
in **.dotfiles**
For example file /home/user/.config/alacritty/alacritty.yml will be copied to
/home/uset/.dotfiles/app_name/.config/alacritty/alacritty.yml
On another maching, after cloning your repo, you can create link with **install**
option
There is a special folder **.root** in **.dotfile**, which used only for **save**
option (see below)


## Options

### ADD
dotman.sh add APP_NAME FILE_NAME
This command will create all necessary directory structure under APP_NAME folder
and move FILE_NAME to this directory, replacing it with symlink
It's not possible to use **.root** as APP_NAME.
If your current config file already a symlink, this command will not touch it and
give you error message

### INSTALL
dotman.sh install APP_NAME
This command will create all necessary directories in your **/home/user** folder
and make there a symlinks to all files from **.dotfiles/APP_NAME** directory
**BE CAREFUL:** if you already have config files in your home direcotory,
they will be replaced with symlinks to files from **.dotfiles** repo.
It's not possible to use **.root** as APP_NAME.


### SAVE
dotman.sh save FILE_NAME
This is just for convinience - you can save files from other system directories
keeping directory structure in **.dotfiles/.root** folder.
You can do it for home directory as well, so file will be just copied wihout making
link instead of original

### RESTORE
dotman.sh restore FILE_NAME
Restore file - this is means that file will be just copied, no symmlink created.
If you restore file from **.dotfiles/.root/etc** directory cp command will be run in
sudo mode and directory structures in will no be created in script (you must create
it manually if necessary). If you restore file from **/dotfiles/.root/home** folder,
structure will be recreated in **/home/user** directory

