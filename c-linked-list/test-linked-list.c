/**
 * An example implementation of a singly-linked list
 *
 * Written by Justin Ethier, 2012
 */
#include <stdio.h>
#include <stdlib.h>
#include "linked-list.h"

void test2(){
    struct node *l;
    l = list();
    listAdd(l, 1);
    listAdd(l, 2);
    listAdd(l, 3);
    listAdd(l, 3);
    listAdd(l, 4);
    listRemove(l, 3);
    listReverse(l);
    listPrint(l);
    //listDestroy(l);
}

void test(){
    struct node* l = NULL;
    int data[] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20};

    l = listFromArray(data, 11);
    listPrint(l);

    l = list();
    listAdd(l, 1);
    listAdd(l, 2);
    listAdd(l, 2);
    listAdd(l, 2);
    listAdd(l, 2);
    listAdd(l, 3);
    listAdd(l, 4);
    listAdd(l, 5);
    listRemove(l, 2);
    listReverse(l);
    printf("\n");
    listPrint(l);
    printf("List length = %d\n\n", listLength(l));

    listRemove(l, 1);
    listRemove(l, 1);
    listRemove(l, 1);
    listRemove(l, 5);
    listPrint(l);
    printf("List length = %d\n\n", listLength(l));
}

int main(int argc, char **argv){
    test2();
    printf("\n");
    test();
    return 1;
}
