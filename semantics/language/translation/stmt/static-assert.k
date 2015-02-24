module C-STMT-STATIC-ASSERT
     imports C-DYNAMIC-SYNTAX
     imports C-ERROR-SYNTAX
     imports C-LITERAL-SYNTAX
     imports C-SYMBOLIC-VALUE-SYNTAX
     imports C-SYNTAX

     context StaticAssert(HOLE, _)
     rule StaticAssert(tv(N:MInt, _), _) => .K
          requires notBool zeroMInt(N)
     rule StaticAssert(tv(symVal, _), _)
          => CV("SSA1",
               "Non-constant expression in static assertion.",
               "6.7.10:2")
     rule StaticAssert(tv(N:MInt, _), stringLiteral(Msg:String))
          => CV("SSA2",
               "Static assertion failed: " +String Msg,
               "6.7.10:2")
          requires zeroMInt(N)


endmodule
