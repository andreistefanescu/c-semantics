module C-STMT-RETURN
     imports C-CHECK-LOC-SYNTAX
     imports C-COMMON-EXPR-EVAL-SYNTAX
     imports C-CONVERSION-SYNTAX
     imports C-DYNAMIC-SYNTAX
     imports C-ERROR-SYNTAX
     imports C-IO-BUFFERED-SYNTAX
     imports C-SEQUENCE-POINT-SYNTAX
     imports C-SYNTAX
     imports C-TYPING-SYNTAX

     imports COMPAT-SYNTAX

     /*@ \fromStandard{\source[n1570]{\para{6.8.6.4}{2}}}{
     A \cinline{return} statement terminates execution of the current function
     and returns control to its caller. A function may have any number of
     \cinline{return} statements.
     }

     \fromStandard{\source[n1570]{\para{6.8.6.4}{3}}}{
     If a \cinline{return} statement with an expression is executed, the value
     of the expression is returned to the caller as the value of the function
     call expression. If the expression has a type different from the return
     type of the function in which it appears, the value is converted as if by
     assignment to an object having the return type of the function.
     }*/

     rule <k> (.K => deleteObject(Base)) ~> Return(_:RValue) ...</k>
          <local-addresses>... SetItem(Base:SymBase) => .Set ...</local-addresses>
          [structural]

     rule <k> Return(_:RValue) ...</k>
          <local-addresses> .Set => Addresses </local-addresses>
          <block-stack>
               ListItem(bag2K(_ <local-addresses> Addresses:Set </local-addresses>))
               => .List
          ...</block-stack>
          [structural]

     //  this is used for returns with no return value as well, since we return
     //  "emptyValue", which will hopefully be cast to void
     rule <k> Return(V:RValue) ~> _
               => exitRestrictScope(F)
               ~> sequencePoint
               ~> checkUse(stripConstants(cast(T, V)))
               ~> setLoc(CurrLoc, CurrFun)
               ~> K
          </k>
          <tu-id> TU </tu-id>
          <gtypes>...
               F:CId |-> t(Mods:Set, functionType(T:Type, _))
          ...</gtypes>
          <control>
               <curr-tu> TU:String => OldTU </curr-tu>
               <curr-function> F:CId </curr-function>
               <curr-function-params> _ => CurrFunParams </curr-function-params>
               <curr-program-loc> _ </curr-program-loc>
               (<control-details>...
                    <local>...
                         <local-addresses> .Set </local-addresses>
                    ...</local>
                    <block-stack> .List </block-stack>
               ...</control-details>  => C)
          </control>
          <call-stack>
               ListItem(bag2K(
                    <call-stack-frame>...
                         <continuation> K:K </continuation>
                         <stack-control>
                              <curr-tu> OldTU:String </curr-tu>
                              C:Bag
                         </stack-control>
                         <stack-curr-function>
                              CurrFun:CId
                         </stack-curr-function>
                         <stack-curr-function-params>
                              CurrFunParams:List
                         </stack-curr-function-params>
                         <stack-curr-program-loc>
                              CurrLoc:K
                         </stack-curr-program-loc>
                    ...</call-stack-frame>
               )) => .List
          ...</call-stack>
          requires notBool (Noreturn in Mods)
          [structural]

     syntax KItem ::= setLoc(K, CId)
     rule <k> V:KResult ~> setLoc(CurrLoc:K, CurrFun:CId) => V ...</k>
          <curr-program-loc> _ => CurrLoc </curr-program-loc>
          <curr-function> _ => CurrFun </curr-function>

     rule <k> (.K => UNDEF("ESR1", "Return from a function declared _Noreturn.",
                    "6.7.4"))
               ~> Return(_)
          ...</k>
          <curr-function> F:CId </curr-function>
          <curr-tu> TU:String </curr-tu>
          <tu-id> TU </tu-id>
          <gtypes>...
               F:CId |-> t(Mods:Set, _)
          ...</gtypes>
          requires Noreturn in Mods
          [structural]
endmodule
