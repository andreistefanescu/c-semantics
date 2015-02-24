module C-COMMON-EXPR-MULTIPLICATIVE

     imports C-BITS-SYNTAX
     imports C-CONVERSION-SYNTAX
     imports C-DYNAMIC-SYNTAX
     imports C-ERROR-SYNTAX
     imports C-PROMOTION-SYNTAX
     imports C-SYNTAX
     imports C-TYPING-SYNTAX

     /*@ \fromStandard{\source[n1570]{\para{6.5.5}{3--6}}}{
     The usual arithmetic conversions are performed on the operands.

     The result of the binary \cinline{*} operator is the product of the
     operands.

     The result of the \cinline{/} operator is the quotient from the division
     of the first operand by the second; the result of the \cinline{\%}
     operator is the remainder. In both operations, if the value of the second
     operand is zero, the behavior is undefined.

     When integers are divided, the result of the \cinline{/} operator is the
     algebraic quotient with any fractional part discarded. If the quotient
     \cinline{a/b} is representable, the expression \cinline{(a/b)*b + a\%b}
     shall equal \cinline{a}; otherwise, the behavior of both \cinline{a/b} and
     \cinline{a\%b} is undefined.
     }*/

     rule tv(I1:MInt, T:Type) * tv(I2:MInt, T':Type)
          => tv(mulMInt(I1, I2), T)
          requires isPromoted(T)
               andBool T ==Type T'
               andBool hasUnsignedIntegerType(T)
          [structural]
     rule tv(I1:MInt, T:Type) * tv(I2:MInt, T':Type)
          => tv(miMInt(smulMInt(I1, I2)), T)
          requires isPromoted(T)
               andBool T ==Type T'
               andBool hasSignedIntegerType(T)
               andBool notBool overflowMInt(smulMInt(I1, I2))
          [structural]
     rule (.K => UNSPEC("CEM1", "signed overflow.", "6.3.1.3:3"))
          ~> tv(I1:MInt, T:Type) * tv(I2:MInt, T':Type)
          requires isPromoted(T)
               andBool T ==Type T'
               andBool hasSignedIntegerType(T)
               andBool overflowMInt(smulMInt(I1, I2))
          [structural]

     rule tv(F1:Float, T:Type) * tv(F2:Float, T':Type)
          => tv(F1 *Float F2, T)
          requires T ==Type T'
               andBool hasFloatType(T)
          [structural]


     rule tv(I1:MInt, T:Type) / tv(I2:MInt, T':Type)
          => tv(udivMInt(I1, I2), T)
          requires isPromoted(T)
               andBool T ==Type T'
               andBool hasUnsignedIntegerType(T)
               andBool notBool zeroMInt(I2)
          [structural]
     rule tv(I1:MInt, T:Type) / tv(I2:MInt, T':Type)
          => tv(miMInt(sdivMInt(I1, I2)), T)
          requires isPromoted(T)
               andBool T ==Type T'
               andBool hasSignedIntegerType(T)
               andBool notBool zeroMInt(I2)
               andBool notBool overflowMInt(sdivMInt(I1, I2))
          [structural]
     rule (.K => UNSPEC("CEM2", "signed overflow.", "6.3.1.3:3"))
          ~> tv(I1:MInt, T:Type) / tv(I2:MInt, T':Type)
          requires isPromoted(T)
               andBool T ==Type T'
               andBool hasSignedIntegerType(T)
               andBool notBool zeroMInt(I2)
               andBool overflowMInt(sdivMInt(I1, I2))
          [structural]
     rule (.K => UNDEF("CEM3", "Division by 0.", "6.5.5:5") )
          ~> tv(_:MInt, T:Type) / tv(I:MInt, T':Type)
          requires isPromoted(T)
               andBool T ==Type T'
               andBool hasIntegerType(T)
               andBool zeroMInt(I)
          [structural]

     rule tv(F1:Float, T:Type) / tv(F2:Float, T':Type)
          => tv(F1 /Float F2, T)
          requires T ==Type T'
               andBool hasFloatType(T)
          [structural]


     rule tv(I1:MInt, T:Type) % tv(I2:MInt, T':Type)
          => tv(uremMInt(I1, I2), T)
          requires isPromoted(T)
               andBool T ==Type T'
               andBool hasUnsignedIntegerType(T)
               andBool notBool zeroMInt(I2)
          [structural]
     rule tv(I1:MInt, T:Type) % tv(I2:MInt, T':Type)
          => tv(miMInt(sremMInt(I1, I2)), T)
          requires isPromoted(T)
               andBool T ==Type T'
               andBool hasSignedIntegerType(T)
               andBool notBool zeroMInt(I2)
               andBool notBool overflowMInt(sremMInt(I1, I2))
          [structural]
     rule (.K => UNSPEC("CEM4", "signed overflow.", "6.3.1.3:3"))
          ~> tv(I1:MInt, T:Type) % tv(I2:MInt, T':Type)
          requires isPromoted(T)
               andBool T ==Type T'
               andBool hasSignedIntegerType(T)
               andBool notBool zeroMInt(I2)
               andBool overflowMInt(sremMInt(I1, I2))
          [structural]
     rule (.K => UNDEF("CEM5", "Modulus by 0.", "6.5.5:5") )
          ~> tv(_:MInt, T:Type) % tv(I:MInt, T':Type)
          requires isPromoted(T)
               andBool T ==Type T'
               andBool hasIntegerType(T)
               andBool zeroMInt(I)
          [structural]
endmodule

