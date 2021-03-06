module C-DECL-LOCAL
     imports C-DECL-DEFINITION-SYNTAX
     imports C-DECL-INITIALIZER-SYNTAX
     imports C-DECL-TAGGED-SYNTAX
     imports C-ENV-SYNTAX

     imports C-MEMORY-ALLOC-SYNTAX
     imports C-TYPING-SYNTAX
     imports C-SYMLOC-SYNTAX
     imports C-SEQUENCE-POINT-SYNTAX

     imports C-SYNTAX

     imports COMPAT-SYNTAX

     rule declare'(typedDeclaration(T:Type, X:CId), K:K)
          => declareInternalVariable(X, T, K)
          [structural]
     rule <k> declareInternalVariable(X:CId, T:Type, NoInit)
               => addToEnv(X, Base)
               ~> giveType(X, T')
          ...</k>
          <curr-tu> TU:String </curr-tu>
          <tu-id> TU </tu-id>
          <external-defs>...
               X |-> Base:SymBase
          ...</external-defs>
          <external-types>...
               X |-> T':Type
          ...</external-types>
          requires isExternType(T) orBool isFunctionType(T)
          [structural]
     rule <k> declareInternalVariable(X:CId, T:Type, NoInit)
               => giveType(X, T)
          ...</k>
          <curr-tu> TU:String </curr-tu>
          <tu-id> TU </tu-id>
          <external-defs> Defs:Map </external-defs>
          <external-types> Types:Map </external-types>
          requires isExternType(T) orBool isFunctionType(T)
               andBool notBool X in keys(Defs)
               andBool notBool X in keys(Types)
          [structural]
 
     rule <k> declareInternalVariable(X:CId, T:Type, _)
               => addToEnv(X, Base)
               ~> giveType(X, T')
          ...</k>
          <block-history> ListItem(BlockNum:Int) ...</block-history>
          <curr-tu> TU:String </curr-tu>
          <tu-id> TU </tu-id>
          <local-statics>...
               kpair(X, BlockNum) |-> Base:SymBase
          ...</local-statics>
          <local-types>...
               kpair(X, BlockNum) |-> T':Type
          ...</local-types>
          requires isStaticType(T)
          [structural]
     rule declareInternalVariable(X:CId, T:Type, NoInit)
          => declareOnly(X, T)
          requires notBool isStaticType(T)
               andBool (notBool isExternType(T))
               andBool (notBool isFunctionType(T))
          [structural]
     rule declareInternalVariable(X:CId, T:Type, K:K)
          => declareAndDefine(X, T, K)
          requires notBool isStaticType(T)
               andBool (notBool isExternType(T))
               andBool (notBool isFunctionType(T))
               andBool (K =/=K NoInit)
          [structural]

     syntax KItem ::= declareOnly(CId, Type)
     rule <k> declareOnly(X:CId, T:Type)
               => defineAndInit(X, T, NoInit, lfresh(D))
          ...</k>
          <duration> D:Duration </duration>
          <local-vars> Vars:List (.List => ListItem(X)) </local-vars>
          requires isCompleteType(T)
               andBool notBool isRegisterType(T)
               andBool (notBool X in Vars)
          [structural]
     rule <k> declareOnly(X:CId, T:Type)
               => defineAndInit(X, T, NoInit, autoToRegister(lfresh(D)))
          ...</k>
          <duration> D:Duration </duration>
          <local-vars> Vars:List (.List => ListItem(X)) </local-vars>
          requires isCompleteType(T)
               andBool isRegisterType(T)
               andBool (notBool X in Vars)
          [structural]
     // Same as above, but for the case where the variable has already been
     // declared. This is seen if we goto earlier in the same block.
     rule <k> declareOnly(X:CId, T:Type) => .K ...</k>
          <local-vars> Vars:List </local-vars>
          requires isCompleteType(T) andBool X in Vars
          [structural]

     syntax KItem ::= declareAndDefine(CId, Type, K)
     rule <k> declareAndDefine(X:CId, T:Type, K:K)
               => defineAndInit(X, T, figureInit(X, T, K), lfresh(D))
          ...</k>
          <duration> D:Duration </duration>
          <local-vars> Vars:List (.List => ListItem(X)) </local-vars>
          requires notBool X in Vars
               andBool notBool isRegisterType(T)
          [structural]
     rule <k> declareAndDefine(X:CId, T:Type, K:K)
               => defineAndInit(X, T, figureInit(X, T, K), autoToRegister(lfresh(D)))
          ...</k>
          <duration> D:Duration </duration>
          <local-vars> Vars:List (.List => ListItem(X)) </local-vars>
          requires notBool X in Vars
               andBool isRegisterType(T)
          [structural]
     // This happens when we jump before a variable declaration with an
     // initialization in the same block.
     rule <k> declareAndDefine(X:CId, T:Type, K:K)
               => justInit(figureInit(X, T, K))
          ...</k>
          <local-vars> Vars:List </local-vars>
          requires X in Vars
          [structural]

     syntax KItem ::= defineAndInit(CId, Type, K, SymBase) [strict(3)]
     rule <k> defineAndInit(X:CId, _, initValue(X:CId, T':Type, K:K), Base:SymBase)
               => allocObjectIfAbsent(Base, T')
               ~> addToEnv(X, Base)
               ~> giveType(X, T')
               ~> allowInit(K)
               ~> sequencePoint
          ...</k>
          <local-addresses>... .Set => SetItem(Base) ...</local-addresses>
          <should-init> true </should-init>
          [structural]
     rule <k> defineAndInit(X:CId, _, initValue(X:CId, T':Type, _), Base:SymBase)
               => allocObjectIfAbsent(Base, T')
               ~> addToEnv(X, Base)
               ~> giveType(X, T')
          ...</k>
          <should-init> false </should-init>
          <local-addresses>... .Set => SetItem(Base) ...</local-addresses>
          [structural]
     rule <k> defineAndInit(X:CId, T:Type, NoInit, Base:SymBase)
               => allocObjectIfAbsent(Base, T)
               ~> addToEnv(X, Base)
               ~> giveType(X, T)
          ...</k>
          <local-addresses>... .Set => SetItem(Base) ...</local-addresses>
          [structural]

     syntax KItem ::= justInit(K) [strict]
     rule justInit(initValue(_, _, K:K)) => allowInit(K) ~> sequencePoint
          [structural]

     rule <k> addLocalTag(X:CId, Info:FieldInfo) => .K ...</k>
          <structs> Structs:Map => Structs[local(X, Tu, BlockNum) <- Info] </structs>
          <curr-tu> Tu:String </curr-tu>
          <block-history> ListItem(BlockNum:Int) ...</block-history>
          [structural]
endmodule

