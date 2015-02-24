module C-EXPR-LOGICAL
     imports C-SYMBOLIC-VALUE-SYNTAX
     imports C-SYNTAX
     imports C-DYNAMIC-SYNTAX
     imports C-TYPING-SYNTAX
     imports C-STMT-IF-THEN-SYNTAX

     context _ && (HOLE => reval(HOLE)) [result(RValue)]
     rule tv(I:MInt, t(_, int)) && _:KResult => tv(I, t(.Set, int))
          requires uvalueMInt(I) ==K 0
          [structural]
     rule tv(I:MInt, t(_, int)) && V:KResult => simplifyTruth(V)
          requires uvalueMInt(I) ==K 1
          [structural]
     rule tv(symVal, t(_, int)) && _:KResult => tv(symVal, t(.Set, int))
          [structural]
     rule (tv(V:CValue, T:Type) => simplifyTruth(tv(V, T))) && _
          requires notBool isTruthValue(tv(V, T)) // symVal is a truth value.
          [structural]

     context _ || (HOLE => reval(HOLE)) [result(RValue)]
     rule tv(I:MInt, t(_, int)) || V:KResult => V
          requires uvalueMInt(I) ==K 0
          [structural]
     rule tv(I:MInt, t(_, int)) || _:KResult => tv(I, t(.Set, int))
          requires uvalueMInt(I) ==K 1
          [structural]
     rule tv(symVal, t(_, int)) || _:KResult => tv(symVal, t(.Set, int))
          [structural]
     rule (tv(V:CValue, T:Type) => simplifyTruth(tv(V, T))) || _
          requires notBool isTruthValue(tv(V, T))
          [structural]

endmodule
