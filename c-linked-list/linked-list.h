/**
 * An example implementation of a singly-linked list
 *
 * Written by Justin Ethier, 2012
 */
#include <stdio.h>
#include <stdlib.h>

#ifndef __LINKED_LIST_HEADER__
#define __LINKED_LIST_HEADER__

struct node {
    struct node *next;
    int val;
};

/**
 * Add a new node to the end of the linked list. Memory is 
 * allocated from the heap for the new node.
 *
 * Constructs a new linked list if a null pointer is passed.
 * Returns a pointer to the beginning of the modified list
 */
struct node *listAdd(struct node *ptr, int val);

/**
 * Create a new list
 */
struct node *list(int val);

/**
 * Removes nodes from the list with the given value,
 * and frees any memory allocated for them.
 */
struct node* listRemove(struct node* ptr, int val);
struct node *listReverse(struct node* head);
int listCar(struct node *head);
int listValue(struct node *head);
struct node *listCdr(struct node *head);
struct node *listRest(struct node *head);
struct node *listFromArray(int *data, int length);
void listPrint(struct node *ptr);

#endif
