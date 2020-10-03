This sploit was an attempt at a simple buffer overflow in the copyFile function. CopyFile asks for two files-  src and dest - that represent the names of the 
source file and the name of the destination file which should be the same. Running this as a checkin, we can overflow the source file name since only 72 chars are
alloted with no checks. Running this program in GDB with test input showed that the exact number of bytes needed to overwrite the return address was 222. We 
construct a NOP sled and the overwrite the return address to point to somewhere in the NOP sled. The NOPs are followed by shellcode to get a root shell. Thus, the 
pointer will "slide" through our NOPs to find the new code to start running which is our injected code. If the addresses are aligned, this will result in a root shell.
Our attack constructs a byte buffer of length 223 (one space for '\0'). 

Step 1: Run some test code to find the exact length of the buffer needed, in our case 222 bytes.
Step 2: Write some C code to output a buffer of bytes as follows: Our shellcode is 48 bytes and the return address is 6 bytes, so we use 222-48-6 = 168 bytes 
of padding for NOP, add in shellcode, then return address at end.
Step 3: Run the exploit to output our code in bytes and use that output as the second command line arguement to /opt/bcvs/bcvs which is the "src" file
Step 4: This should result in a root shell

Issues with our attack:
On Caroline's machine, the 222 bytes and return address resulted in a non-root shell everytime. We found shellcode that includes setuid(0) that is used in our 
other attacks that results in root shell, but only ever gave a student shell on Caroline's machine; however, this particular setup failed on other machines. 
The returna address, NOP sled and shellcode are correct, but we could not generalize this attack to the other machines OR get a root shell.
