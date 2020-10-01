This exploit exploits the fact that the execlp() function calling "chmod"
uses the string "chmod" and trusts that the path will find this shell command
in "/bin/chmod". In fact, changing the string to such would make it such that
this exploit would not work in its current form.


Step 1: The shellscript makes and populates the repository should it not exist.

Step 2: Make a simple C program that sets UID and EUID to 0 and calls "/bin/sh"

Step 3: Compile this program into a binary called "chmod"

Step 4: Append the home directory (where this should be run) onto the PATH with export.

Step 5: Construct filler input such that the shellscript runs w/o user input

Step 6: Clobber in some file, like func.c, so it can be clobbered out.

Step 7: Clobber the same file out, with dummy input catted to "-" the stdin variable

Despite the fact that there is no shell prompt, the resulting command prompt is that
of a root shell (confirm with "whoami")
