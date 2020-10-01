This exploit uses the vulnerabilities of "realpath()", a function which
is similar to strcpy() in its non-bounds-checking vulnerability, to create
a buffer overflow. The function does a bit more than strcpy(), though, in
that it checks the bounds (but allows non-null-terminated strings to go 
paths them) and within the bounds truncates symbolic paths. If a file DNE,
the return is null, but the "canonical_pathname" argument is still copied
into by the first argument up until the point where realpath() determines
a path is no longer valid.

For example:
"/././././.././././././bin/sh" becomes "/bin/sh"
"/this_dir_dne/./././bin/sh/." becomes "this_dir_dne"

realpath() will still allow us to copy over the return address for the frame,
but we can not store our shellcode in the buffer due to the raw "/bin/sh" in
the shellcode. To get around this problem, we store the shellcode in an
environment variable, which will always have an address for processes and are
copied from parent to child. The shell is its own environment.

By writing a NOP sled into shellcode into an environment variable using the
common "shell"code moniker EGG, we can then find the address of the variable 
and rewrite the return address of is_blocked() using the canonical_path buffer
to the address of the EGG variable.

Step 1: Make the repo and block.list if DNE

Step 2: Make a python script to write the shellcode + nopsled into a file
        called "eggcode", run script, export to EGG
        
Step 3: Make a C program to retrieve the address of EGG, compile, write
        into a file called "eggenv"

Step 4: Make a python script to take the address from "eggenv" and convert
        to a little endian address with enough padding to overwrite the
        is_blocked() address. Write contents into "payload"

Step 5: Run the bcvs program with the contents of payload as argv[2] using
        $(cat payload)
