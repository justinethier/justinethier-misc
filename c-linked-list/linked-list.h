/**
 * An example implementation of a singly-linked list
 *
 * Written by Justin Ethier, 2012
 */
#include <stdio.h>
#include <stdlib.h>

#ifndef __LINKED_LIST_HEADER__
#define __LINKED_LIST_HEADER__

// TODO: change this to store void pointers????

/**
 * The basic structure that is used to build a list.
 * Each lists consists of a string of these nodes.
 * 
 * There is also an empty head node that points to the
 * first node. This is done as a convenience so the
 * caller can always use that same pointer without
 * having to reassign it after various operations.
 */
struct node {
    struct node *next;
    int val;
};

// TODO: comment each of the functions below

/**
 * Add a new node to the end of the linked list. Memory is 
 * allocated from the heap for the new node.
 *
 * Constructs a new linked list if a null pointer is passed.
 * Returns a pointer to the beginning of the modified list
 */
int listAdd(struct node *ptr, int val);

/**
 * Create a new list
 */
struct node *list();
void listDestroy(struct node*);
/**
 * Removes nodes from the list with the given value,
 * and frees any memory allocated for them.
 */
void listRemove(struct node* head, int val);
void listReverse(struct node* head);
int listCar(struct node *head);
int listValue(struct node *head);
struct node *listCdr(struct node *head);
struct node *listRest(struct node *head);
struct node *listFromArray(int *data, int length);
void listPrint(struct node *head);
int listLength(struct node *head);

// TODO: remaining functions from R5RS that make sense (eg: pair? list? probably do not make any sense)
// cons (?)
// set-car (?)
// set-cdr (?)
// append
// list-ref
// member
// assoc (????)
// 
// Selected functions from SRFI-1
// http://srfi.schemers.org/srfi-1/srfi-1.html#TheProcedures
// iota
// take
// drop
// split-at
// last

#endif
