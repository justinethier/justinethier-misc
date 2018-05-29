#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "arpa/inet.h"

uint64_t bswap_48(uint64_t x) {
    return ((((x) & 0x0000000000ff) << 40) |    \
            (((x) & 0x00000000ff00) << 24) |    \
            (((x) & 0x000000ff0000) << 8)  |    \
            (((x) & 0x0000ff000000) >> 8)  |    \
            (((x) & 0x00ff00000000) >> 24) |    \
            (((x) & 0xff0000000000) >> 40));
}

void main() 
{
  //242 39 0 0 0 0
  printf("%ld\n", bswap_48( 0xF22700000000));
  printf("%04X\n", htonl(10226));
}

