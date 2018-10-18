#include <stdio.h>
#include <stdlib.h>

void main() {
  int i;

  for (i = 0; i < 20; i++) {
    if (i % 2) {
      int a, *pa = alloca(sizeof(int));
      printf("%p %p\n", &a, pa);
    } else {
      int a, *pa = alloca(sizeof(int));
      printf("%p %p\n", &a, pa);
    }
  }
}
