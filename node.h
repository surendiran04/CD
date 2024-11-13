#ifndef NODE_H
#define NODE_H

typedef struct Node {
    char *tag;
    struct Node *child;
    struct Node *sibling;
} Node;

Node *createNode(char *tag);
void addChild(Node *parent, Node *child);
void printTree(Node *node, int depth);

#endif
 
