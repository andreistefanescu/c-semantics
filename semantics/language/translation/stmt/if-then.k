module C-STMT-IF-THEN-SYNTAX
     imports C-DYNAMIC-SYNTAX

     syntax Bool ::= isTruthValue(RValue) [function]
endmodule

module C-STMT-IF-THEN
     imports C-STMT-IF-THEN-SYNTAX
     imports C-SYNTAX
     imports C-TYPING-SYNTAX
     imports C-SYMBOLIC-VALUE-SYNTAX

     rule isTruthValue(tv(V:CValue, t(_, T:SimpleType)))
          => T ==K int andBool (V ==K mi(bitSizeofType(int::Type), 0) orBool V ==K mi(bitSizeofType(int::Type), 0) orBool V ==K symVal)

     rule IfThenElse((V:RValue => simplifyTruth(V)), _, _)
          requires notBool isTruthValue(V)
          [structural]

     // IfThenElse might also be handling the ternary operator (?:) and so
     // needing to return a value.
     rule IfThenElse(tv(I:MInt, t(_, int)), S1:K, S2:K)
          => S1 ~> discard ~> S2
          requires uvalueMInt(I) ==K 0
          [structural]
     rule IfThenElse(tv(I:MInt, t(_, int)), S1:K, S2:K)
          => S2 ~> discard ~> S1
          requires uvalueMInt(I) ==K 1
          [structural]

     // Things get a bit ugly in this case. We only want to return a value if
     // both branches also return a value (and therefore this is a ternary
     // expression).
     rule IfThenElse(tv(symVal, t(_, int)), S1:K, S2:K)
          => maybeSymVal(checkResultInK(S1), checkResultInK(S2))
          [structural]

     //add checkResultInK in order to aovid putting K Sequence in strict position
     syntax KItem ::= maybeSymVal(K, K) [strict]
                    | "checkResult"
                    | checkResultInK(K)

     syntax KResult ::= "noResult"

     rule checkResultInK(K:K) => K ~> checkResult
          [structural]

     rule R:KResult ~> checkResult => R
     rule checkResult => noResult

     rule maybeSymVal(noResult, noResult) => .K
     rule maybeSymVal(tv(_, T:Type), tv(_, T:Type)) => tv(symVal, T)
     rule maybeSymVal(tv(_, T:Type), tv(_, T':Type)) => tv(symVal, stripConstants(T))
          requires T =/=K T' andBool stripConstants(T) ==K stripConstants(T')
     rule maybeSymVal(voidVal, voidVal) => voidVal
     rule maybeSymVal(voidVal, tv(_, T:Type)) => voidVal
          requires isVoidType(T)
     rule maybeSymVal(tv(_, T:Type), voidVal) => voidVal
          requires isVoidType(T)
endmodule

