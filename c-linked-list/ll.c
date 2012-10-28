/**
 * An example implementation of a singly-linked list
 *
 * Justin Ethier, 2012
 */
#include <stdio.h>
#include <stdlib.h>

struct node {
    struct node *next;
    int val;
};

/**
 * Add a new node to the end of the linked list
 */
struct node *listAdd(struct node *ptr, int val){
    struct node* head = ptr;
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
            break;
        }
        ptr = ptr->next;
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
// void listCdr
// void listCreate-from-array (name TBD)

void listPrint(struct node *ptr){
    while (ptr){
        printf("%d\n", ptr->val);
        ptr = ptr->next;
    }
}

int main(int argc, char **argv){
    struct node* head = NULL;
    head = listAdd(head, 1);
    listAdd(head, 2);
    listAdd(head, 2);
    listAdd(head, 3);
    listAdd(head, 4);
    listAdd(head, 5);
    head = listRemove(head, 2);
    head = listReverse(head);
    listPrint(head);

    head = listRemove(head, 1);
    head = listRemove(head, 1);
    head = listRemove(head, 1);
    head = listRemove(head, 5);
    printf("\n");
    listPrint(head);

    return 1;
}
