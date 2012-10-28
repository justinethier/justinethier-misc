#include <stdio.h>
#include <stdlib.h>

struct node {
    struct node *next;
    int val;
};

/**
 * Add a new node to the end of the linked list
 */
struct node *add(struct node *ptr, int val){
    if (ptr == NULL){
        ptr = (struct node *)malloc(sizeof(struct node));
    } else {
        while (ptr->next != NULL) {
            ptr = ptr->next;
        }
        ptr->next = (struct node *)malloc(sizeof(struct node));
        ptr = ptr->next;
    }

    ptr->next = NULL;
    ptr->val = val;
    return ptr;
}

struct node* remove(struct node* ptr, int val){
    struct node* head = ptr;

    if (head == NULL) return head;
    if (head->val == val){
        ptr = ptr->next;
        free(head);
        return ptr;
    }

    while(ptr->next != NULL){
        if (ptr->next->val == val){
            if (ptr->next->next == NULL){
                free(ptr->next);
                ptr->next = NULL;
            } else {
                ptr->next = ptr->next->next;
                free(ptr-
            }
        }
        ptr = ptr->next;
    }

    return head;
}

// void reverse
// void car
// void cdr
// void create-from-array (name TBD)

void print(struct node *ptr){
    // TODO: no, use iteration
    if (ptr == NULL) return;
    printf("%d\n", ptr->val);
    print(ptr->next);
}

int main(int argc, char **argv){
    struct node* head = NULL;
    head = add(head, 1);
    add(head, 2);
    add(head, 2);
    add(head, 3);
    add(head, 4);
    remove(head, 2);
    // remove(head, 1);
    print(head);
    return 1;
}
