/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

struct __anonstruct_A_21 {
   short i  __attribute__((__packed__, __aligned__(2))) ;
   int f[2]  __attribute__((__packed__, __aligned__(2))) ;
};
typedef struct __anonstruct_A_21 A;
extern  __attribute__((__nothrow__, __noreturn__)) void abort(void)  __attribute__((__leaf__)) ;
extern  __attribute__((__nothrow__, __noreturn__)) void exit(int __status )  __attribute__((__leaf__)) ;
int f(A *ap ) 
{ short i ;
  short j ;

  {
  j = (short)1;
  i = (short )ap->f[1];
  i = (short )((int )i + ap->f[j]);
  j = (short)0;
  while ((int )j < 2) {
    i = (short )((int )i + ap->f[j]);
    j = (short )((int )j + 1);
  }
  return ((int )i);
}
}
int main(void) 
{ A a ;
  int tmp ;

  {
  a.f[0] = 100;
  a.f[1] = 13;
  tmp = f(& a);
  if (tmp != 139) {
    abort();
  }
  exit(0);
}
}