/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

extern  __attribute__((__nothrow__, __noreturn__)) void abort(void)  __attribute__((__leaf__)) ;
int f(int a , int b ) 
{ 

  {
  if (a == 1) {
    a = 0;
  }
  if (b == 0) {
    a = 1;
  }
  if (a != 0) {
    return (0);
  }
  return (1);
}
}
int main(void) 
{ int tmp ;

  {
  tmp = f(1, 1);
  if (tmp != 1) {
    abort();
  }
  return (0);
}
}