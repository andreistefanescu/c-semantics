module C-COMMON-EXPR-UNARY

     imports C-SYNTAX
     imports C-DYNAMIC-SYNTAX
     imports C-PROMOTION-SYNTAX
     imports C-TYPING-SYNTAX
     imports C-BITS-SYNTAX
     imports C-BITSIZE-SYNTAX
     imports C-SETTINGS-SYNTAX
     imports C-CONVERSION-SYNTAX

     /*@ \fromStandard{\source[n1570]{\para{6.5.3.3}{2}}}{
     The result of the unary \cinline{+} operator is the value of its
     (promoted) operand. The integer promotions are performed on the operand,
     and the result has the promoted type.
     }*/
     rule [unaryPlus-int]:
          + tv(I:MInt, T:Type) => tv(I, T)
          requires isPromoted(T)
               andBool hasIntegerType(T)
          [structural]
     rule [unaryPlus-float]:
          + tv(F:Float, T:Type) => tv(F, T)
          requires hasFloatType(T)
          [structural]

     /*@ \fromStandard{\source[n1570]{\para{6.5.3.3}{3}}}{
     The result of the unary \cinline{-} operator is the negative of its
     (promoted) operand. The integer promotions are performed on the operand,
     and the result has the promoted type.
     }*/
     rule [unaryMinus-int]:
          - tv(I:MInt, T:Type) => tv(mi(bitSizeofType(T), 0), T) - tv(I, T)
          requires isPromoted(T)
               andBool hasIntegerType(T)
          [structural]
     rule [unaryMinus-float]:
          - tv(F:Float, T:Type) => tv(0.0 -Float F, T)
          requires hasFloatType(T)
          [structural]

     /*@ \fromStandard{\source[n1570]{\para{6.5.3.3}{5}}}{
     The result of the logical negation operator \cinline{!} is 0 if the value
     of its operand compares unequal to 0, 1 if the value of its operand
     compares equal to 0. The result has type \cinline{int}.  The expression
     \cinline{!E} is equivalent to \cinline{(0==E)}.
     }*/
     rule !(E:K) => tv(mi(bitSizeofType(int), 0), t(SetItem(IntegerConstant), int)) == E
          [structural]
endmodule

