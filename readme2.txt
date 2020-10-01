This exploit exploits the fact that the execlp() function calling "chown"
uses the string "chown" and trusts that the path will find this shell command
in "/bin/chown". In fact, changing the string to such would make it such that
this exploit would not work in its current form.


Step 1: The shellscript makes and populates the repository should it not exist.

Step 2: Make a simple C program that sets UID and EUID to 0 and calls "/bin/sh"

Step 3: Compile this program into a binary called "chown"

Step 4: Append the home directory (where this should be run) onto the PATH with export.

Step 5: Construct filler input such that the shellscript runs w/o user input

Step 6: Clobber in some file, like func.c, so it can be clobbered out.

Step 7: Clobber the same file out, with dummy input catted to "-" the stdin variable

Despite the fact that there is no shell prompt, the resulting command prompt is that
of a root shell (confirm with "whoami")


###########################

Now, the argument can be made that this is far too similar to the chmod script. The argument
in its favor comes from our lazy programmer. When the system manager relays down to the
programmer that the previous vulnerability came from the "chmod" function, they will only
respond to the error pertaining to "chmod," but fail to specify all their vulnerabilities,
including the very similar execlp() call only a few lines over.
