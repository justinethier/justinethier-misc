/**
 * An example implementation of a singly-linked list
 *
 * Written by Justin Ethier, 2012
 */
#include <stdio.h>
#include <stdlib.h>

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
struct node *listAdd(struct node *ptr, int val){
    struct node *head = ptr;
    if (ptr == NULL){
        head = ptr = (struct node *)malloc(sizeof(struct node));
    } else {
        while (ptr->next != NULL) {
            ptr = ptr->next;
        }
        ptr->next = (struct node *)malloc(sizeof(struct node));
        ptr = ptr->next;
    }

    ptr->next = NULL;
    ptr->val = val;
    return head;
}

/**
 * Removes nodes from the list with the given value,
 * and frees any memory allocated for them.
 */
struct node* listRemove(struct node* ptr, int val){
    struct node *head = ptr, *tmp;

    if (head == NULL) return head;
    if (head->val == val){
        ptr = ptr->next;
        free(head);
        return ptr;
    }

    while(ptr->next != NULL){
        if (ptr->next->val == val){
            tmp = ptr->next->next;
            free(ptr->next);
            ptr->next = tmp;
        } else {
            ptr = ptr->next;
        }
    }

    return head;
}

struct node *listReverse(struct node* head){
    struct node *new_head = NULL, *next;

    while (head){
       next = head->next;
       head->next = new_head;
       new_head = head;
       head = next;
    }
    return new_head;
}

// int listCar
int listCar(struct node *head){
    if (head == NULL) return -1;
    return head->val;
}
int listValue(struct node *head){
    return listCar(head);
}

// void listCdr
struct node *listCdr(struct node *head){
    if (head == NULL) return NULL;
    return head->next;
}
struct node *listRest(struct node *head){
    return listCdr(head);
}

// void listCreate-from-array (name TBD)
struct node *listFromArray(int *data, int length){
    struct node *head;
    int i;
    for (i = 0; i < length; i++){
        head = listAdd(head, *data);
        data++;
    }

    return head;
}

void listPrint(struct node *ptr){
    while (ptr){
        printf("%d\n", ptr->val);
        ptr = ptr->next;
    }
}

int main(int argc, char **argv){
    struct node* head = NULL;
    int data[] = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20};

    head = listFromArray(data, 11);
    listPrint(head);

    head = listAdd(head, 1);
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

    return 1;
}
