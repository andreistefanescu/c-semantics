module COMPAT-SYNTAX
     imports C-SYNTAX // Would like to get rid of this.

     //TODO(liyi): must not need the second one
     syntax KItem ::= l(KLabel) [avoid]
     syntax KItem ::= klist(KList) [function]

     syntax String ::= firstChar(String) [function]
     syntax String ::= nthChar(String, Int) [function]
     syntax String ::= butFirstChar(String) [function]

     syntax List ::= stringToList(String) [function]
     syntax String ::= listToString(List) [function]

     syntax String ::= idToString(CId) [function]

     syntax String ::= toUpperCase(String) [function]

     syntax Bool ::= all(List, KLabel) [function]

     //TODO(liyi): this might be able to remove
     syntax Bool ::= isAllKResultInHeatList(HeatList) [function]

     syntax Bool ::= List "==MSet" List [function]
                   | List "=/=MSet" List [function]
                   //TODO(liyi): might not need this later
                   | listEqual(List, List) [function]

     syntax List ::= removeListItem(List, K) [function]

     // TODO(chathhorn): ugly
     syntax KItem ::= toKRList(List)

     syntax KResult ::= krlist(List)

     syntax List ::= reverseList(List) [function]

     //TODO(liyi): syntax List ::= ListItem(Bag)
     syntax KItem ::= bag2K(Bag)
     syntax KItem ::= list(List)
     syntax KItem ::= map(Map)
     syntax KItem ::= set(Set)

     syntax KItem ::= listToK(List) [function]

     syntax KItem ::= kpair(K, K)

     syntax KList ::= Int "to" Int [function]

     syntax List ::= times(Int, K) [function]

     syntax Set ::= filterSet(Set, KLabel) [function]

     syntax Bool ::= some(Set, KLabel) [function]

     //TODO(liyi): might not need this later
     syntax KItem ::= "dotK"
                    | lookup(Map, K) [function]
endmodule

module COMPAT
     imports COMPAT-SYNTAX

     rule stringToList("") => .List
     rule stringToList(S:String)
               => ListItem(firstChar(S:String))
                    stringToList(butFirstChar(S:String))
          requires S:String =/=String ""

     rule listToString(.List) => ""
     rule listToString((ListItem(S:String) L:List))
               => S:String +String listToString(L:List)

     rule idToString(Identifier(S:String)) => S

     rule [firstChar]:
          firstChar(S:String) => substrString(S, 0, 1)

     rule [nthChar]:
          nthChar(S:String, N:Int) => substrString(S, N, N +Int 1)

     rule [butFirstChar]:
          butFirstChar(S:String)
          => substrString(S:String, 1, lengthString(S:String))

     rule all(ListItem(K:K) L:List, Lbl:KLabel)
          => Lbl(K:K) andBool all(L, Lbl)
     rule all(.List, _) => true

     rule toUpperCase(S:String)
          => toUpperCase(firstChar(S:String))
               +String toUpperCase(butFirstChar(S:String))
          requires lengthString(S) >Int 1

     rule toUpperCase(C:String)
          => C:String
          requires (lengthString(C) ==Int 1)
               andBool (ordChar(C) <Int ordChar("a")
                    orBool ordChar(C) >Int ordChar("z"))
     rule toUpperCase(C:String)
          => chrChar(absInt(ordChar(C)
               -Int (ordChar("a") -Int ordChar("A"))))
          requires (lengthString(C) ==Int 1)
               andBool (ordChar(C) >=Int ordChar("a")
                    andBool ordChar(C) <=Int ordChar("z"))

     rule removeListItem(.List, _) => .List
     rule removeListItem(ListItem(A:K) M:List, A) => M
     rule removeListItem(ListItem(A:K) M:List, A':K)
          => ListItem(A) removeListItem(M, A')
          requires A =/=K A'

     //TODO(liyi): might not need this later
     rule listEqual(.List, .List) => true
     rule listEqual(L:List, .List) => false
          requires L =/=K .List
     rule listEqual(.List, L:List) => false
          requires L =/=K .List
     rule listEqual(ListItem(A:K) L1:List, ListItem(A:K) L2:List)
          => listEqual(L1, L2)
     rule listEqual(ListItem(A1:K) _, ListItem(A2:K) _)
          => false
          requires A1 =/=K A2

     syntax Bool ::= subset(K, Set, Set) [function]

     rule subset(K:K, S1:Set, S2:Set) => S1 <=Set (S2 -Set SetItem(K))
          requires K in S2
     rule subset(K:K, _, S2:Set) => false
          requires notBool (K in S2)

     rule '_==MSet_(.List ,, .List) => true
     rule '_==MSet_(.List ,, ListItem(_) _:List) => false
     rule '_==MSet_(ListItem(_) _:List ,, .List) => false
     rule '_==MSet_(ListItem(K:K) M:List ,, M':List)
          => '_==MSet_(M:List ,, removeListItem(M', K))
          requires K:K in M':List
     rule '_==MSet_(ListItem(K:K) _:List ,, M':List)
          => false
          requires notBool (K:K in M':List)

     rule M:List =/=MSet M':List => notBool '_==MSet_(M ,, M')

     rule list(L:List) => toKRList(L)
          [structural]

     syntax KItem ::= "toKRList'" "(" SubKRList ")" [strict]

     // TODO(liyi): might not need this after associative matching
     syntax SubKRItem ::= sItem(K) [strict]
     syntax SubKRList ::= List{SubKRItem, "ss::"} [strict]
     syntax SubKRList ::= toSubKRList(List) [function]

     syntax SubResult ::= srItem(K)
     syntax SubKRItem ::= SubResult
     syntax KResult ::= SubResult

     rule toSubKRList(.List) => .SubKRList
     rule toSubKRList(ListItem(K:K) L:List) => sItem(K) ss:: toSubKRList(L)

     // TODO(liyi): overcome the context associative matching
     //context toKRList'(_:List ListItem(HOLE) _:List)
     rule sItem(V:KResult) => srItem(V) [structural]

     rule toKRList(L:List) => toKRList'(toSubKRList(L)) ~> krlist(.List)
          [structural]

     rule toKRList'((srItem(V:KResult) ss:: S:SubKRList) => S)
          ~> krlist(_:List (.List => ListItem(V)))
          requires getKLabel(V) =/=KLabel 'krlist
          [structural]
     // Somewhat contrived feature: nested lists are flattened.
     rule toKRList'((srItem(krlist(L:List)) ss:: S:SubKRList) => S)
          ~> krlist( _:List (.List => L))
          [structural]
     rule toKRList'(.SubKRList) => .K
          [structural]

     rule reverseList(.List) => .List
     rule reverseList(ListItem(K:K) L:List)
          => reverseList(L:List) ListItem(K:K)

     rule listToK(ListItem(K:K) L:List) => K ~> listToK(L)
     rule listToK(.List) => .K

     rule N:Int to N => .KList
     rule N:Int to N':Int => (N,, ((N +Int 1) to N'))
          requires N <Int N'

     rule times(0, _) => .List
     rule times(N:Int, K:K) => ListItem(K) times(N -Int 1, K)
          requires N >Int 0

     syntax List ::= klistToList(KList) [function]

     rule klistToList((K:K,, L:KList)) => ListItem(K) klistToList(L)
     rule klistToList(.KList) => .List

     rule 'klist(L:KList) => 'list(klistToList(L))

     syntax Set ::= #filterSet(K, Set, KLabel) [function]

     rule #filterSet(K:K, .Set, Pred:KLabel)
          => SetItem(K)
          requires Pred(K) ==K true
     rule #filterSet(K:K, .Set, Pred:KLabel)
          => .Set
          requires Pred(K) =/=K true
     rule #filterSet(K:K, SetItem(K':K) S:Set, Pred:KLabel)
          => SetItem(K) #filterSet(K', S, Pred)
          requires Pred(K) ==K true
     rule #filterSet(K:K, SetItem(K':K) S:Set, Pred:KLabel)
          => #filterSet(K', S, Pred)
          requires Pred(K) =/=K true

     rule filterSet(SetItem(K:K) S:Set, Pred:KLabel)
          => #filterSet(K, S, Pred)
     rule filterSet(.Set, _)
          => .Set

     rule some(S:Set, Lbl:KLabel) => some'(.K, S, Lbl)

     syntax Bool ::= "some'" "(" K "," Set "," KLabel ")" [function]
     rule some'(.K, SetItem(K:K) S:Set, Lbl:KLabel) => some'(K, S, Lbl)
     rule some'(K:K, _, Lbl:KLabel) => true
          requires Lbl(K) ==K true
     rule some'(K:K, S:Set, Lbl:KLabel) => some'(.K, S, Lbl)
          requires Lbl(K) =/=K true
               andBool (K =/=K .K)
     rule some'(.K, .Set, _) => false


     // TODO(liyi): might be able to remove later
     rule isAllKResultInHeatList(.HeatList) => true
     rule isAllKResultInHeatList(hItem(_) hs:: _) => false
     rule isAllKResultInHeatList(hrItem(_) hs:: HL:HeatList)
          => isAllKResultInHeatList(HL)

     //TODO(liyi): might not need this
     rule dotK => .K [structural]
     rule lookup(Key |-> Val:K _:Map, Key:K) => Val

endmodule
