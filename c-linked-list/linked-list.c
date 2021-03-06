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
struct node *list()
{
    struct node *head = (struct node *)malloc(sizeof(struct node));
    head->next = NULL;
    return head;
}

void list_destroy(struct node *head)
{
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
int list_add(struct node *head, int val)
{
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
void list_remove(struct node* ptr, int val)
{
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


void list_reverse(struct node* head)
{
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

int list_is_empty(struct node *head)
{
    return (head == NULL || head->next == NULL);
}

int list_car(struct node *head)
{
    if (head == NULL || head->next == NULL) return -1;
    return head->next->val;
}

int list_value(struct node *head)
{
    return list_car(head);
}

struct node *list_cdr(struct node *head)
{
    if (head == NULL) return NULL;

    // No need to allocate a new head, we just
    // ignore the next node's value and can 
    // treat it as head
    return head->next;
}

struct node *list_rest(struct node *head)
{
    return list_cdr(head);
}

// void listCreate-from-array (name TBD)
struct node *list_from_array(int *data, int length)
{
    struct node *l = list();
    int i;

    for (i = 0; i < length; i++){
        list_add(l, *data);
        data++;
    }

    return l;
}

void list_print(struct node *head)
{
    struct node *ptr;
    
    if (head == NULL) return;

    ptr = head->next;
    while (ptr){
        printf("%d\n", ptr->val);
        ptr = ptr->next;
    }
}

int list_length(struct node *head)
{
    int count = -1;
    
    while (head){
        head = head->next;
        count++;
    }

    return count;
}
