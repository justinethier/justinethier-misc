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
void merge_sorted(int *lis, int l, int m, int r) {
  int tmp[(r - l) + 1];
  int t = 0;
  
  int ll = l, mm = m;
  while(ll < m || mm <= r){
    if (mm <= r && (ll == m || lis[ll] > lis[mm])) {
      tmp[t] = lis[mm];
      t++;
      mm++;
    } else {
      tmp[t] = lis[ll];
      t++;
      ll++;
    }
  }

  print_array(tmp, r - l + 1);
  memcpy(lis + l, tmp, ((r - l) + 1) * sizeof(int));
  print_array(lis, r - l + 1);
}

void merge(int *lis, int l, int r) {
  if (l < r) {
    int m = l + (r - l) / 2;

    merge(lis, l, m);
    merge(lis, m + 1, r);
    merge_sorted(lis, l, m, r);
  }
}

void main() {
  int test[] = {2, 4, 6, 1, 3, 5};
  int test_sorted[] = {1, 2, 3, 4, 5, 6};
  int test2[] = {5, 3, 4, 2, 6, 1, -1, 8};
  int test2_sorted[] = {-1, 1, 2, 3, 4, 5, 6, 8};
  merge_sorted(test, 0, 5/2, 5);
  test_eq(test, test_sorted, 6);

  // TODO: merge(test2, 0, 7);
  merge_sorted(test2, 0, 7/2, 7);
  test_eq(test2, test2_sorted, 8);
}
