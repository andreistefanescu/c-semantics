module C-SYMBOLIC-VALUE-SYNTAX
     imports C-SYMBOLIC-VALUE-SYNTAX
     imports C-DYNAMIC-SYNTAX

     syntax CSize ::= SymVal
     syntax SymBase ::= SymVal
     syntax SymLoc ::= SymVal
     syntax Bits ::= SymVal
     syntax SymVal ::= "symVal"

     syntax Bool ::= isSymbolic(CValue) [function]
endmodule

module C-SYMBOLIC-VALUE
     imports C-SYMBOLIC-VALUE-SYNTAX

     imports C-BITSIZE-SYNTAX
     imports C-BITS-SYNTAX
     imports C-CONVERSION-SYNTAX
     imports C-MEMORY-READING-SYNTAX
     imports C-MEMORY-WRITING-SYNTAX
     imports C-SETTINGS-SYNTAX
     imports C-SYMLOC-SYNTAX
     imports C-SYNTAX
     imports C-TYPING-COMPATIBILITY-SYNTAX
     imports C-TYPING-SYNTAX

     imports COMPAT-SYNTAX

     // Various rules for cramming this symVal down the throat of the
     // semantics. It might make better sense to just move all this stuff to
     // common.
     rule symVal +bytes _:Int => symVal

     rule base(symVal) => symVal
     rule offset(symVal) => symVal:>Int
     rule prov(symVal) => .Set

     rule addProv(_:Set, symVal) => symVal
     rule addProv(_:Provenance, symVal) => symVal
     rule stripProv(symVal) => symVal

     rule write(symVal, _, T:Type) => .K
          requires notBool isConstType(T)
          [structural]
     rule <k> write(symVal, _, _) => .K ...</k>
          <initializing> I:Int </initializing>
          requires I >Int 0
          [structural]

     rule bitSizeofType(T:Type) => symVal:>Int
          requires notBool isCompleteType(T)
               andBool notBool isFlexibleArrayType(T)
     rule bitSizeofType(t(_, arrayType(_, symVal))) => symVal:>Int
     rule bitSizeofType(t(_, variableLengthArrayType(_, _))) => symVal:>Int

     rule splitBytes(tv(symVal, T:Type))
          => dataList(
               times(byteSizeofType(T), piece(symVal, cfg:bitsPerByte)))

     rule write-specific(Loc:SymLoc, symVal, T:Type)
          => writeBytes(Loc, dataList(ListItem(symVal)), T)
          requires (bitSizeofType(T) %Int cfg:bitsPerByte =/=Int 0)
               orBool (isBitfieldType(T) andBool notBool hasUnionMarker(Loc))
          [structural]

     //rule symVal => tv(symVal, t(.Set, no-type))

     rule isSymbolic(V:CValue) => #isSymbolic(V) ==K true

     syntax Bool ::= #isSymbolic(CValue) [function]
                   | #areSymbolic(List) [function]

     rule #isSymbolic(symVal) => true
     rule #isSymbolic(piece(symVal, _)) => true
     rule #isSymbolic(agg(L:List)) => #areSymbolic(L)
     rule #isSymbolic(_) => false [owise]

     rule #areSymbolic(ListItem(V:CValue) L:List)
          => isSymbolic(V) orElseBool #areSymbolic(L)
     rule #areSymbolic(.List) => false

     // Not sure about this -- makes all VLAs compat with non-VLAs.
     rule #areCompat(
               t(Mods:Set, arrayType(T:Type, N:CSize)),
               t(Mods':Set, arrayType(T':Type, N':CSize)), Cache:Set)
          => #areCompat(T, T', Cache)
          requires sameQualifiers(Mods, Mods')
               andBool ((N ==K symVal) orBool (N' ==K symVal))

endmodule
