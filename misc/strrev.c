#include <stdio.h>
#include <string.h>

/**
 * things to note:
 * - how to index each char
 * - how to replace
 * - efficiently looping
 * - when to stop
 */
char *my_strrev(char *s) {
  int i, len = strlen(s), stop = len/2 + (len % 2);
  char tmp;
  for (i = 0; i < stop; i++) {
    printf("%d, %d, %s\n", i, len-i-1, s);
    tmp = s[i];
    s[i] = s[len - i - 1];
    s[len - i - 1] = tmp;
  }
  return s;
}

void main() {
  char str[] = "testing";
  char str1[] = "t";
  char str2[] = "test";
  printf("%s\n", my_strrev(str));
  printf("%s\n", my_strrev(str1));
  printf("%s\n", my_strrev(str2));
}
