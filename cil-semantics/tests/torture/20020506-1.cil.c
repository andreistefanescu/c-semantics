/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

extern  __attribute__((__nothrow__, __noreturn__)) void abort(void)  __attribute__((__leaf__)) ;
void test1(signed char c , int set ) ;
void test2(unsigned char c , int set ) ;
void test3(short s , int set ) ;
void test4(unsigned short s , int set ) ;
void test5(int i , int set ) ;
void test6(unsigned int i , int set ) ;
void test7(long long l , int set ) ;
void test8(unsigned long long l , int set ) ;
void test1(signed char c , int set ) 
{ 

  {
  if (((int )c & 128) == 0) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  if (((int )c & 128) != 0) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if (((int )c & 128) == 128) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if (((int )c & 128) != 128) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  return;
}
}
void test2(unsigned char c , int set ) 
{ 

  {
  if (((int )c & 128) == 0) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  if (((int )c & 128) != 0) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if (((int )c & 128) == 128) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if (((int )c & 128) != 128) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  return;
}
}
void test3(short s , int set ) 
{ 

  {
  if (((int )s & 32768) == 0) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  if (((int )s & 32768) != 0) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if (((int )s & 32768) == 32768) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if (((int )s & 32768) != 32768) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  return;
}
}
void test4(unsigned short s , int set ) 
{ 

  {
  if (((int )s & 32768) == 0) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  if (((int )s & 32768) != 0) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if (((int )s & 32768) == 32768) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if (((int )s & 32768) != 32768) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  return;
}
}
void test5(int i , int set ) 
{ 

  {
  if (((unsigned int )i & 2147483648U) == 0U) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  if (((unsigned int )i & 2147483648U) != 0U) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if (((unsigned int )i & 2147483648U) == 2147483648U) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if (((unsigned int )i & 2147483648U) != 2147483648U) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  return;
}
}
void test6(unsigned int i , int set ) 
{ 

  {
  if ((i & 2147483648U) == 0U) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  if ((i & 2147483648U) != 0U) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if ((i & 2147483648U) == 2147483648U) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if ((i & 2147483648U) != 2147483648U) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  return;
}
}
void test7(long long l , int set ) 
{ 

  {
  if (((unsigned long long )l & 0x8000000000000000ULL) == 0ULL) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  if (((unsigned long long )l & 0x8000000000000000ULL) != 0ULL) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if (((unsigned long long )l & 0x8000000000000000ULL) == 0x8000000000000000ULL) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if (((unsigned long long )l & 0x8000000000000000ULL) != 0x8000000000000000ULL) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  return;
}
}
void test8(unsigned long long l , int set ) 
{ 

  {
  if ((l & 0x8000000000000000ULL) == 0ULL) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  if ((l & 0x8000000000000000ULL) != 0ULL) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if ((l & 0x8000000000000000ULL) == 0x8000000000000000ULL) {
    if (! set) {
      abort();
    }
  } else {
    if (set) {
      abort();
    }
  }
  if ((l & 0x8000000000000000ULL) != 0x8000000000000000ULL) {
    if (set) {
      abort();
    }
  } else {
    if (! set) {
      abort();
    }
  }
  return;
}
}
int main(void) 
{ 

  {
  test1((signed char)0, 0);
  test1((signed char)127, 0);
  test1((signed char)-128, 1);
  test1((signed char)-1, 1);
  test2((unsigned char)0, 0);
  test2((unsigned char)127, 0);
  test2((unsigned char)128, 1);
  test2((unsigned char)255, 1);
  test3((short)0, 0);
  test3((short)32767, 0);
  test3((short)-32768, 1);
  test3((short)-1, 1);
  test4((unsigned short)0, 0);
  test4((unsigned short)32767, 0);
  test4((unsigned short)32768, 1);
  test4((unsigned short)65535, 1);
  test5(0, 0);
  test5(2147483647, 0);
  test5((-0x7FFFFFFF-1), 1);
  test5(-1, 1);
  test6(0U, 0);
  test6(2147483647U, 0);
  test6(2147483648U, 1);
  test6(4294967295U, 1);
  test7(0LL, 0);
  test7(9223372036854775807LL, 0);
  test7((-0x7FFFFFFFFFFFFFFF-1), 1);
  test7(-1LL, 1);
  test8(0ULL, 0);
  test8(9223372036854775807ULL, 0);
  test8(0x8000000000000000ULL, 1);
  test8(0xffffffffffffffffULL, 1);
  return (0);
}
}