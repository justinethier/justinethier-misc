/**
 * An example implementation of a singly-linked list
 *
 * Written by Justin Ethier, 2012
 */
#include <stdio.h>
#include <stdlib.h>
#include "linked-list.h"

/**
 * Create a new list
 */
struct node *list(){
    struct node *head = (struct node *)malloc(sizeof(struct node));
    head->next = NULL;
    return head;
}

void listDestroy(struct node *head){
    struct node *tmp = head;
    while (head){
        tmp = head;
        head = head->next;
        free(tmp);
    }
}

/**
 * Add a new node to the end of the linked list. Memory is 
 * allocated from the heap for the new node.
 *
 * Constructs a new linked list if a null pointer is passed.
 * Returns a pointer to the beginning of the modified list
 */
int listAdd(struct node *head, int val){
    struct node *ptr = head;

    if (ptr == NULL) return 0;

    while (ptr->next != NULL) {
        ptr = ptr->next;
    }
    ptr->next = (struct node *)malloc(sizeof(struct node));
    ptr = ptr->next;

    ptr->next = NULL;
    ptr->val = val;

    return 1;
}

/**
 * Removes nodes from the list with the given value,
 * and frees any memory allocated for them.
 */
void listRemove(struct node* ptr, int val){
    struct node *tmp;

    if (ptr == NULL) return;

    while(ptr->next != NULL){
        if (ptr->next->val == val){
            tmp = ptr->next->next;
            free(ptr->next);
            ptr->next = tmp;
        } else {
            ptr = ptr->next;
        }
    }

    return;
}


void listReverse(struct node* head){
    struct node *ptr, *prev = NULL, *tmp;

    if (head == NULL) return;
    ptr = head->next;

    // Change
    //
    //  prev => ptr => next
    // to
    //  prev <= ptr <= next
    //
    while (ptr){
       tmp = ptr->next;
       ptr->next = prev;
       prev = ptr;
       ptr = tmp;
    }

    head->next = prev;
    return;
}

int listIsEmpty(struct node *head){
    return (head == NULL || head->next == NULL);
}

int listCar(struct node *head){
    if (head == NULL || head->next == NULL) return -1;
    return head->next->val;
}
int listValue(struct node *head){
    return listCar(head);
}

struct node *listCdr(struct node *head){
    if (head == NULL) return NULL;

    // No need to allocate a new head, we just
    // ignore the next node's value and can 
    // treat it as head
    return head->next;
}
struct node *listRest(struct node *head){
    return listCdr(head);
}

// void listCreate-from-array (name TBD)
struct node *listFromArray(int *data, int length){
    struct node *l = list();
    int i;

    for (i = 0; i < length; i++){
        listAdd(l, *data);
        data++;
    }

    return l;
}

void listPrint(struct node *head){
    struct node *ptr;
    
    if (head == NULL) return;

    ptr = head->next;
    while (ptr){
        printf("%d\n", ptr->val);
        ptr = ptr->next;
    }
}

int listLength(struct node *head){
    int count = -1;
    
    while (head){
        head = head->next;
        count++;
    }

    return count;
}
