/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

enum X {
    A = 0,
    B = 1,
    C = 2,
    D = 3,
    E = 4,
    F = 5,
    G = 6,
    H = 7,
    I = 8,
    J = 9,
    K = 10,
    L = 11,
    M = 12,
    N = 13,
    O = 14,
    P = 15,
    Q = 16
} ;
extern void abort(void) ;
extern void exit(int  ) ;
void bar(char const   *x , int y , char const   *z ) 
{ 

  {
  return;
}
}
long foo(enum X x , void const   *y ) 
{ long a ;

  {
  switch ((int )x) {
  case 10: 
  a = *((long *)y);
  break;
  case 11: 
  a = *((long *)y);
  break;
  case 12: 
  a = *((long *)y);
  break;
  case 13: 
  a = *((long *)y);
  break;
  case 14: 
  a = *((long *)y);
  break;
  default: 
  bar("foo", 1, "bar");
  }
  return (a);
}
}
int main(void) 
{ long i ;
  long tmp ;

  {
  i = 24L;
  tmp = foo((enum X )13, (void const   *)(& i));
  if (tmp != 24L) {
    abort();
  }
  exit(0);
}
}