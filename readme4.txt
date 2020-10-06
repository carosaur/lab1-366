Sudo Symlink Exploit - 
This exploit uses symlinks to trick bcvs into checking out the sudoers file. We then add ourself as a sudo user, and can easily get into the root shell.
BCVS has weak block.list enforcement, meaning that by just creating a new folder and new .bcvs/block.list file with different/no contents, we can can
take ownership of whatever we want. Block.list is meant to prevent certain files from being chmod/chown to the BCVS user, but by creating our own file setup and 
having symlink permissions, we can overwrite any file we want.

Step 1: set up a new directory with a .bcvs and .bcvs/block.list
Step 2: make some fake input file to check in
Step 3: make a symlink between sudoers file and our sudoers in .bcvs
Step 4: checkout the sudoers file
Step 5: add new lines to the sudoers file giving us sudo permissions
Step 6: check it back in which overwrites the /etc/sudoers because of the symlink
Step 7: run sudo /bin/sh
