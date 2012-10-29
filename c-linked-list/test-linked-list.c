/**
 * An example implementation of a singly-linked list
 *
 * Written by Justin Ethier, 2012
 */
#include <stdio.h>
#include <stdlib.h>
#include "linked-list.h"

void test(){
    struct node* head = NULL;
    int data[] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20};

    head = listFromArray(data, 11);
    listPrint(head);

    head = list(1);
    listAdd(head, 2);
    listAdd(head, 2);
    listAdd(head, 2);
    listAdd(head, 2);
    listAdd(head, 2);
    listAdd(head, 3);
    listAdd(head, 4);
    listAdd(head, 5);
    head = listRemove(head, 2);
    head = listReverse(head);
    printf("\n");
    listPrint(head);

    printf("\n");
    listPrint( listRest(head) );

    head = listRemove(head, 1);
    head = listRemove(head, 1);
    head = listRemove(head, 1);
    head = listRemove(head, 5);
    printf("\n");
    listPrint(head);
}

int main(int argc, char **argv){
    test();
    return 1;
}
