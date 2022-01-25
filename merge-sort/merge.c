#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void print_array(int *arr, int len) {
  for (int i = 0; i < len; i++) {
    printf("%d ", arr[i]);
  }
  printf("\n");
}

void merge_sorted(int *lis, int l, int m, int r) {
  int *tmp = malloc(r - l + 1);
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
  memcpy(lis + l, tmp, (r - l) + 1);
  free(tmp);
  print_array(lis, r - l + 1);
}

void merge(int *lis, int l, int m, int r) {
  // TODO: if

  merge(lis, l, (m-l)/2, m);
  merge(lis, m, (r-m)/2, r);
  merge_sorted(lis, l, m, r);
}

void main() {
  int test[] = {2, 4, 6, 1, 3, 5};
  merge_sorted(test, 0, 3, 5);
  print_array(test, 6);
}
