#ifndef _EXPR_TREE_
#define _EXPR_TREE_

#include <stdbool.h>

typedef struct node{
    char label;
    int val;
    struct node *n1;
    struct node *n2;
}node;

typedef struct{
    node *n0;
}exprTree;

node* noeud(char label, node *n1, node *n2);
bool leaf(node *n);
int analyseExpr(node *n);

#endif
