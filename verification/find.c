// Copyright (c) 2014 K Team. All Rights Reserved.
/*
 * Function that searches a binary search tree for a node with a certain value.
 */
#include <stdlib.h>

struct treeNode {
  int value;
  struct treeNode *left;
  struct treeNode *right;
};

#pragma KCC rule <mem>... tree(t)(T:Tree) ...</mem> \
                 <k> find(v, t) => ?b ...</k> \
            requires bst(T) \
            ensures (?b != 0) == (v in tree_keys(T)
int find(int v, struct treeNode *t)
{
  if (t == NULL)
    return 0;
  else if (v == t->value)
    return 1;
  else if (v < t->value)
    return find(v, t->left);
  else
    return find(v, t->right);
}

int main() {
  struct treeNode *t = (struct treeNode *) malloc(sizeof(struct treeNode));
  t->value = 1;
  t->left = NULL;
  t->right = t;
  return 0;
}

