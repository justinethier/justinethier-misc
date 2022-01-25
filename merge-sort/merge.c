#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void print_array(int *arr, int len) {
  for (int i = 0; i < len; i++) {
    printf("%d ", arr[i]);
  }
  printf("\n");
}

int compare(int *a, int *b, int len) {
  for (int i = 0; i < len; i++) {
    if(a[i] != b[i]) {
      return 0;
    }
  }
  return 1;
}

void test_eq(int *a, int *b, int len) {
  if (!compare(a, b, len)) {
    fprintf(stderr, "Test failed: Arrays are not equal\n");
    print_array(a, len);
    print_array(b, len);
    exit(1);
  }
  printf("Test passed\n");
}

// Take an array where each half has been sorted, and sort
// the whole array in place
//
// lis - array to sort
// l - start of left half of array
// m - end of the left half of array
// r - end of the right half
void merge_sorted(int *lis, int l, int m, int r) {
  int len = (r - l) + 1;
  int buf[len];
  int i, j = 0, k = m + 1;

TODO: only copy entries from l to r

  for (i = 0; i < len; i++) { // Copy the array
    buf[i] = lis[i];
  }

  i = 0;
  while (j <= m && k < len) { // Merge until one array runs out of data
    if (buf[j] < buf[k]) {
      lis[i] = buf[j];
      j++;
    } else {
      lis[i] = buf[k];
      k++;
    }
    i++;
  }

  // Any elements remaining in l?
  while (j <= m) {
    lis[i++] = buf[j++];
  }
  // Any elements remaining in m?
  while (k < len) {
    lis[i++] = buf[k++];
  }
}


void merge(int *lis, int l, int r) {
  if (l < r) {
    int m = l + ((r - l) / 2);
    printf("%d %d %d\n", l, m, r); 

    merge(lis, l, m);
    merge(lis, m + 1, r);
    merge_sorted(lis, l, m, r);
  }
}

void main() {
  int test[] = {2, 4, 6, 1, 3, 5};
  int test_sorted[] = {1, 2, 3, 4, 5, 6};
  int test2[] = {2, 3, 4, 5, -1, 1, 6, 8};
  int test2_sorted[] = {-1, 1, 2, 3, 4, 5, 6, 8};
  merge_sorted(test, 0, 2, 5);
  test_eq(test, test_sorted, 6);

  merge(test2, 0, 7);
  //merge_sorted(test2, 0, 3, 7);
  test_eq(test2, test2_sorted, 8);
}
