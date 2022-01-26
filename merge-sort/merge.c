#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

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
  int i, j;

  for (i = l, j = 0; i <= r; i++, j++) { // Copy the array
    buf[j] = lis[i];
  }

  i = l;
  int ll = 0, mm = m - l, rr = mm + 1;
  while (ll <= mm && rr < len) { // Merge until one array runs out of data
    if (buf[ll] < buf[rr]) {
      lis[i] = buf[ll];
      ll++;
    } else {
      lis[i] = buf[rr];
      rr++;
    }
    i++;
  }

  // Any elements remaining in l?
  while (ll <= mm) {
    lis[i++] = buf[ll++];
  }
  // Any elements remaining in m?
  while (rr < len) {
    lis[i++] = buf[rr++];
  }
}

// Merge sort
//
// lis - array to sort
// l - Left-most (first) index to start sorting at
// r - Right-most (last) index of array to sort
void merge(int *lis, int l, int r) {
  if (l < r) {
    int m = l + ((r - l) / 2);

    merge(lis, l, m);
    merge(lis, m + 1, r);
    merge_sorted(lis, l, m, r);
  }
}

void test_merge_sorted() {
  int test[] = {2, 4, 6, 1, 3, 5};
  int test_sorted[] = {1, 2, 3, 4, 5, 6};
  int test2[] = {2, 3, 4, 5, -1, 1, 6, 8};
  int test2_sorted[] = {-1, 1, 2, 3, 4, 5, 6, 8};

  merge_sorted(test, 0, 2, 5);
  test_eq(test, test_sorted, 6);

  merge_sorted(test2, 0, 3, 7);
  test_eq(test2, test2_sorted, 8);
}

void test_merge() {
  int small[] = {4, 3, 2, 1};
  int small2[] = {1, 2, 3, 4};
  int test[] = {2, 4, 6, 1, 5, 3};
  int test_sorted[] = {1, 2, 3, 4, 5, 6};
  int test2[] = {2, 3, 4, 5, -1, 1, 6, 8};
  int test2_sorted[] = {-1, 1, 2, 3, 4, 5, 6, 8};

  merge(small, 0, 3);
  test_eq(small, small2, 4);

  merge(test, 0, 5);
  test_eq(test, test_sorted, 6);

  merge(test2, 0, 7);
  test_eq(test2, test2_sorted, 8);
}

void test_rand() {
  int *arr = malloc(sizeof(int) * 100);
  int *sorted = malloc(sizeof(int) * 100);
  int i;

  for (i = 0; i < 100; i++) {
    sorted[i] = i;
    arr[i] = i;
  }

  for (i = 0; i < 100; i++) {
    int tmp = arr[i], swap = rand() % 100;
    arr[i] = arr[swap]; 
    arr[swap] = tmp;
  }

  merge(arr, 0, 99);
  test_eq(arr, sorted, 100);

  free(arr);
  free(sorted);
}

void main() {
  srand(time(NULL));
  test_merge_sorted();
  test_merge();
  for (int i = 0; i < 1000; i++) {
    test_rand();
  }
}
