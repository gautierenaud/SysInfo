#include <stdlib.h>
#include "exprTree.h"

node* noeud(char label, node *n1, node *n2){
    node *result = (node*) malloc(sizeof(node));
    result->n1 = n1;
    result->n2 = n2;
    result->label = label;

    return result;
}

bool leaf(node *n){
    return (n->n1 == NULL && n->n2 == NULL);
}

int analyseTree(node *n){
    if (leaf(n)) return n->val;
    else{
        int tmp1 = analyseTree(n->n1), tmp2 = analyseTree(n->n2);
        switch (n->label){
            case '+':
                return tmp1 + tmp2;
                break;
            case '-':
                return tmp1 - tmp2;
                break;
            case '*':
                return tmp1 * tmp2;
                break;
            case '/':
                return tmp1 / tmp2;
                break;   
        }
    }
}
