/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

extern void abort(void) ;
int v  ;
int s  ;
void bar(int a , int b ) 
{ unsigned char x ;

  {
  x = (unsigned char )v;
  if (! s) {
    if (a != (int )x) {
      abort();
    } else {
      if (b != (int )((unsigned char )((int )x + 1))) {
        abort();
      }
    }
  } else {
    if (a != (int )((unsigned char )((int )x + 1))) {
      abort();
    } else {
      if (b != (int )x) {
        abort();
      }
    }
  }
  s ^= 1;
  return;
}
}
int foo(int x ) 
{ unsigned char a ;
  unsigned char b ;

  {
  a = (unsigned char )x;
  b = (unsigned char )(x + 1);
  bar((int )a, (int )b);
  a = (unsigned char )((int )a ^ (int )b);
  b = (unsigned char )((int )b ^ (int )a);
  a = (unsigned char )((int )a ^ (int )b);
  bar((int )a, (int )b);
  return (0);
}
}
int main(void) 
{ 

  {
  v = -10;
  while (v < 266) {
    foo(v);
    v ++;
  }
  return (0);
}
}