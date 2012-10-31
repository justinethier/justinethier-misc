/**
 * An example implementation of a singly-linked list
 *
 * Written by Justin Ethier, 2012
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "linked-list.h"

void testBasic(){
    struct node *l = list();

    listAdd(l, 1);
    listAdd(l, 2);
    listAdd(l, 3);
    listAdd(l, 3);
    listAdd(l, 4);
    listRemove(l, 3);
    listReverse(l);
    assert( 3 == listLength(l));
    assert( 4 == listValue(l));
    listDestroy(l);
    printf("Passed testBasic()\n");
}

/**
 * Test reading data from a list
 */
void testReading(){
    struct node* l = list(), *lp;
    int i, len = 100;
    for (i = 0; i < len; i++){
        listAdd(l, i);
    }
    lp = l;
    i = 0;
    while (!listIsEmpty(lp)){
        assert( i == listCar(lp) );
        lp = listCdr(lp);
        i++;
    }

    listDestroy(l);
    printf("Passed testReading()\n");
}

// TODO: should use assert for tests
void test(){
    struct node* l = NULL, *r;
    int data[] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20};
//assert(0);
    l = listFromArray(data, 11);
    listPrint(l);
    printf("List length = %d\n\n", listLength(l));
    listDestroy(l);

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
    listPrint(l);
    printf("List length = %d\n\n", listLength(l));

    printf("Rest:\n");
    listPrint(listRest(l));
    printf("\n");

    listRemove(l, 1);
    listRemove(l, 1);
    listRemove(l, 1);
    listRemove(l, 5);
    listPrint(l);
    printf("List length = %d\n\n", listLength(l));
}

int main(int argc, char **argv){
    testBasic();
    testReading();
    printf("\n");
    test();
    return 1;
}
