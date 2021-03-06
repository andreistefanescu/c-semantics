module C-EXPR-IDENTIFIER
     imports C-COMMON-EXPR-EVAL-SYNTAX
     imports C-DYNAMIC-SYNTAX
     imports C-MEMORY-READING-SYNTAX
     imports C-SYMBOLIC-VALUE-SYNTAX
     imports C-SYMLOC-SYNTAX
     imports C-TYPING-COMPATIBILITY-SYNTAX
     imports C-TYPING-SYNTAX

     rule <k> X:CId => lv(lnew(Base, getAlignas(T)), T) ...</k>
          <env>... X |-> Base:SymBase ...</env>
          <types>... X |-> T:Type ...</types>
          requires notBool isLinkerLoc(Base)
               andBool Base =/=K symVal
          [structural]
     rule <k> X:CId => lv(symVal, T) ...</k>
          <env>... X |-> symVal ...</env>
          <types>... X |-> T:Type ...</types>
          [structural]

     rule <k> X:CId => lv(lnew(Base, getAlignas(T)), T) ...</k>
          <env>... X |-> Base:SymBase ...</env>
          <types>... X |-> T:Type ...</types>
          <curr-tu> Tu:String </curr-tu>
          <tu-id> Tu </tu-id>
          <internals>... X |-> _ ...</internals>
          requires isLinkerLoc(Base)
          [structural]

     // We need to record uses of external symbols because if an external
     // without a definition isn't ever used, then it isn't a link error.
     rule <k> X:CId => lv(lnew(Base, getAlignas(T)), T) ...</k>
          <env>... X |-> Base:SymBase ...</env>
          <types>... X |-> T:Type ...</types>
          <curr-tu> Tu:String </curr-tu>
          <tu-id> Tu </tu-id>
          <externals>... X |-> _ ...</externals>
          <external-uses>... (.Set => SetItem(X)) </external-uses>
          requires isLinkerLoc(Base)
          [structural]

     rule <k> instantiate(Loc:SymLoc, T:Type) => tv(symVal, stripQualifiers(T)) ...</k>
          requires notBool fromConstantExpr(T)
               orBool notBool isStaticDuration(Loc)
               orBool isLinkerLoc(Loc)
     rule <k> instantiate(Loc:SymLoc, T:Type) => read(Loc, T) ...</k>
          requires fromConstantExpr(T)
               andBool isStaticDuration(Loc)
               andBool notBool isLinkerLoc(Loc)

endmodule
