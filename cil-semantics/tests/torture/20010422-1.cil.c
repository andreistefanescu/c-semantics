/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

extern  __attribute__((__nothrow__, __noreturn__)) void abort(void)  __attribute__((__leaf__)) ;
extern  __attribute__((__nothrow__, __noreturn__)) void exit(int __status )  __attribute__((__leaf__)) ;
unsigned int foo(unsigned int x ) 
{ 

  {
  if (x < 5U) {
    x = 4U;
  } else {
    x = 8U;
  }
  return (x);
}
}
int main(void) 
{ unsigned int tmp ;

  {
  tmp = foo(8U);
  if (tmp != 8U) {
    abort();
  }
  exit(0);
}
}