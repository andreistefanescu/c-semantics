/* Generated by CIL v. 1.7.3 */
/* print_CIL_Input is true */

//#line 212 "/usr/lib/gcc/x86_64-linux-gnu/4.6/include/stddef.h"
typedef unsigned long size_t;

struct listNode {
   int value ;
   struct listNode *next ;
};

//#line 471 "/usr/include/stdlib.h"
extern void * malloc(size_t __size);

struct listNode *reverse(struct listNode *x )
{
  struct listNode *p ;
  struct listNode *y ;

  {
  p = (struct listNode *)((void *)0);
  while ((unsigned long )x != (unsigned long )((void *)0)) {
    y = x->next;
    x->next = p;
    p = x;
    x = y;
  }
  return (p);
}
}

int main(void)
{
  struct listNode *x ;
  int n ;
  struct listNode *y ;
  void *tmp ;

  {
  x = (struct listNode *)((void *)0);
  n = 5;
  while (n) {
    y = x;
    tmp = malloc(sizeof(struct listNode ));
    x = (struct listNode *)tmp;
    x->value = n;
    x->next = y;
    n --;
  }
  x = reverse(x);
  return (0);
}
}
