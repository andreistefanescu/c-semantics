module C-CONVERSION-SYNTAX
     imports C-DYNAMIC-SYNTAX

     syntax Int ::= interpretMInt(MInt, Type)   [function]
     // interpret the result of arithmetic as in 6.5.4
     syntax KItem ::= arithInterpret(Type, NumValue) [function]
     syntax KItem ::= arithInterpretHold(Type, NumValue)
     // as described in 6.3 // totype, fromvalue
     // change it to function in order
     // to solve anywhere rule
     syntax KItem ::= cast(Type, RValue) [function]
     //Might not need this if we have anywhere rule
     syntax KItem ::= castHold(Type, RValue)
endmodule

module C-CONVERSION
     imports C-CONVERSION-SYNTAX

     imports C-BITSIZE-SYNTAX
     imports C-BITS-SYNTAX
     imports C-ERROR-SYNTAX
     imports C-SYMLOC-SYNTAX
     imports C-SYNTAX
     imports C-TYPING-COMPATIBILITY-SYNTAX
     imports C-TYPING-SYNTAX
     imports C-SETTINGS-SYNTAX

     imports DEBUG-SYNTAX
     imports COMPAT-SYNTAX

     rule interpretMInt(I:MInt, T:Type) => svalueMInt(I)
          requires hasSignedIntegerType(T)
     rule interpretMInt(I:MInt, T:Type) => uvalueMInt(I)
          requires hasUnsignedIntegerType(T)

//     rule arithInterpret(T:Type, N:Int) => tv(N, T)
//          requires (min(T) <=Int N)
//               andBool (max(T) >=Int N)
//               andBool hasIntegerType(T)
//     rule arithInterpret(T:Type, unknown) => tv(unknown, T)
//     rule arithInterpret(T:Type, trap) => tv(trap, T)
//     // fixme
//     rule arithInterpret(T:Type, F:Float) => tv(F, T)
//          requires hasFloatType(T)
//     // signed arithmetic isn't supposed to overflow
//     rule arithInterpret(T:Type, N:Int) => tv(N %Int (max(T) +Int 1), T)
//          requires hasUnsignedIntegerType(T)
//               andBool (N >Int max(T))
//     rule arithInterpret(T:Type, N:Int)
//          => arithInterpret(T, (N %Int (max(T) +Int 1)) +Int (max(T) +Int 1))
//          // must be like this so ((unsigned int)(~((unsigned int)~0)) != 0)
//          // will work, but not sure why
//          requires hasUnsignedIntegerType(T)
//               andBool (N <Int min(T))
//     rule arithInterpret(T:Type, I:Int) => arithInterpretHold(T:Type, I:Int)
//          requires hasSignedIntegerType(T)
//               andBool notBool ((min(T) <=Int I) andBool (max(T) >=Int I))
//
//     rule (.K => UNSPEC("CCV1", "signed overflow.", "6.3.1.3:3"))
//          ~> arithInterpretHold(T:Type, I:Int)
//          requires hasSignedIntegerType(T)
//               andBool notBool ((min(T) <=Int I) andBool (max(T) >=Int I))
//          [structural]

     rule cast(T':Type, tv(V:CValue, T:Type)) => tv(V, cast(T', T))
          requires stripQualifiers(T) ==K stripQualifiers(T')
               andBool notBool isPointerType(T')

     /*@ \fromStandard{\source[n1570]{\para{6.3.1.2}{1}}}{
     When any scalar value is converted to \cinline{_Bool}, the result is 0 if
     the value compares equal to 0; otherwise, the result is 1.
     }*/
     rule cast(t(Mods:Set, bool), tv(I:Int, T:Type))
          => #if I ==Int 0
               #then tv(0, cast(t(Mods, bool), T))
               #else tv(1, cast(t(Mods, bool), T)) #fi
          requires hasIntegerType(T)

     rule cast(t(Mods:Set, bool), tv(F:Float, T:Type))
          => #if F ==Float Int2Float(0, 53, 11)
               #then tv(0, cast(t(Mods, bool), T))
               #else tv(1, cast(t(Mods, bool), T)) #fi
          requires hasFloatType(T)

     rule cast(t(Mods:Set, bool), tv(V:SymLoc, T:Type))
          => #if V ==K NullPointer
               #then tv(0, cast(t(Mods, bool), T))
               #else tv(1, cast(t(Mods, bool), T)) #fi
          requires isPointerType(T)

     /*@ \fromStandard{\source[n1570]{\para{6.3.1.3}{1}}}{
     When a value with integer type is converted to another integer type other
     than \cinline{_Bool}, if the value can be represented by the new type, it
     is unchanged.
     }*/
     rule cast(T':Type, tv(V:Int, T:Type))
          => tv(V, cast(T', T))
          requires hasIntegerType(T) andBool hasIntegerType(T')
               andBool notBool isBoolType(T')
               andBool inRange(V, T')

     /*@ \fromStandard{\source[n1570]{\para{6.3.1.3}{2}}}{
     Otherwise, if the new type is unsigned, the value is converted by
     repeatedly adding or subtracting one more than the maximum value that can
     be represented in the new type until the value is in the range of the new
     type.
     }*/
     rule cast(T':Type, tv(I:Int, T:Type))
          => cast(T', tv(I +Int max(T') +Int 1, T))
          requires (isBitfieldType(T')
               andThenBool (I <Int min(T')))
               andBool hasIntegerType(T)
               andBool hasUnsignedIntegerType(innerType(T'))

     rule cast(t(Mods:Set, unsigned-char), tv(I:Int, T:Type))
          => cast(t(Mods, unsigned-char),
               tv(I +Int max(t(Mods, unsigned-char)) +Int 1, T))
          requires (I <Int min(t(Mods, unsigned-char)))
               andBool hasIntegerType(T)

     rule cast(t(Mods:Set, unsigned-short-int), tv(I:Int, T:Type))
          => cast(t(Mods, unsigned-short-int),
               tv(I +Int max(t(Mods, unsigned-short-int)) +Int 1, T))
          requires (I <Int min(t(Mods, unsigned-short-int)))
               andBool hasIntegerType(T)

     rule cast(t(Mods:Set, unsigned-int), tv(I:Int, T:Type))
          => cast(t(Mods, unsigned-int),
               tv(I +Int max(t(Mods, unsigned-int)) +Int 1, T))
          requires (I <Int min(t(Mods, unsigned-int)))
               andBool hasIntegerType(T)

     rule cast(t(Mods:Set, unsigned-long-int), tv(I:Int, T:Type))
          => cast(t(Mods, unsigned-long-int),
               tv(I +Int max(t(Mods, unsigned-long-int)) +Int 1, T))
          requires (I <Int min(t(Mods, unsigned-long-int)))
               andBool hasIntegerType(T)

     rule cast(t(Mods:Set, unsigned-long-long-int), tv(I:Int, T:Type))
          => cast(t(Mods, unsigned-long-long-int),
               tv(I +Int max(t(Mods, unsigned-long-long-int)) +Int 1, T))
          requires (I <Int min(t(Mods, unsigned-long-long-int)))
               andBool hasIntegerType(T)

     rule cast(T':Type, tv(I:Int, T:Type))
          => tv(I %Int (max(T') +Int 1), cast(T', T))
          requires isBitfieldType(T')
               andBool (I >Int max(T'))
               andBool hasIntegerType(T)
               andBool hasUnsignedIntegerType(innerType(T'))

     rule cast(t(Mods:Set, unsigned-char), tv(I:Int, T:Type))
          => tv(I %Int (max(t(Mods, unsigned-char)) +Int 1),
               cast(t(Mods, unsigned-char), T))
          requires (I >Int max(t(Mods, unsigned-char)))
               andBool hasIntegerType(T)

     rule cast(t(Mods:Set, unsigned-short-int), tv(I:Int, T:Type))
          => tv(I %Int (max(t(Mods, unsigned-short-int)) +Int 1),
               cast(t(Mods, unsigned-short-int), T))
          requires (I >Int max(t(Mods, unsigned-short-int)))
               andBool hasIntegerType(T)

     rule cast(t(Mods:Set, unsigned-int), tv(I:Int, T:Type))
          => tv(I %Int (max(t(Mods, unsigned-int)) +Int 1),
               cast(t(Mods, unsigned-int), T))
          requires (I >Int max(t(Mods, unsigned-int)))
               andBool hasIntegerType(T)

     rule cast(t(Mods:Set, unsigned-long-int), tv(I:Int, T:Type))
          => tv(I %Int (max(t(Mods, unsigned-long-int)) +Int 1),
               cast(t(Mods, unsigned-long-int), T))
          requires (I >Int max(t(Mods, unsigned-long-int)))
               andBool hasIntegerType(T)

     rule cast(t(Mods:Set, unsigned-long-long-int), tv(I:Int, T:Type))
          => tv(I %Int (max(t(Mods, unsigned-long-long-int)) +Int 1),
               cast(t(Mods, unsigned-long-long-int), T))
          requires (I >Int max(t(Mods, unsigned-long-long-int)))
               andBool hasIntegerType(T)

     /*@ \fromStandard{\source[n1570]{\para{6.3.1.3}{3}}}{
     Otherwise, the new type is signed and the value cannot be represented in
     it; either the result is implementation-defined or an
     implementation-defined signal is raised.
     }*/
     // choice
     // rule cast(T':Type, tv(I:Int, T:Type))
     //      => cast(T', tv(I %Int (2 ^Int absInt(bitSizeofType(T'))), T))
     //      requires isBitfieldType(T')
     //           andBool (absInt(I) >Int (2 ^Int absInt(bitSizeofType(T'))))
     //           andBool hasIntegerType(T)
     //           andBool hasSignedIntegerType(innerType(T'))
     //      [structural]
     // rule cast(t(Mods:Set, signed-char), tv(I:Int, T:Type))
     //      => cast(t(Mods, signed-char),
     //           tv(I %Int (2 ^Int absInt(bitSizeofType(t(Mods, signed-char)))), T))
     //      requires (absInt(I) >Int (2 ^Int absInt(bitSizeofType(t(Mods, signed-char)))))
     //           andBool hasIntegerType(T)
     //      [structural]
     // rule cast(t(Mods:Set, short-int), tv(I:Int, T:Type))
     //      => cast(t(Mods, short-int),
     //           tv(I %Int (2 ^Int absInt(bitSizeofType(t(Mods, short-int)))), T))
     //      requires (absInt(I) >Int (2 ^Int absInt(bitSizeofType(t(Mods, short-int)))))
     //           andBool hasIntegerType(T)
     //      [structural]
     // rule cast(t(Mods:Set, int), tv(I:Int, T:Type))
     //      => cast(t(Mods, int),
     //           tv(I %Int (2 ^Int absInt(bitSizeofType(t(Mods, int)))), T))
     //      requires (absInt(I) >Int (2 ^Int absInt(bitSizeofType(t(Mods, int)))))
     //           andBool hasIntegerType(T)
     //      [structural]
     // rule cast(t(Mods:Set, long-int), tv(I:Int, T:Type))
     //      => cast(t(Mods, long-int),
     //           tv(I %Int (2 ^Int absInt(bitSizeofType(t(Mods, long-int)))), T))
     //      requires (absInt(I) >Int (2 ^Int absInt(bitSizeofType(t(Mods, long-int)))))
     //           andBool hasIntegerType(T)
     //      [structural]
     // rule cast(t(Mods:Set, long-long-int), tv(I:Int, T:Type))
     //      => cast(t(Mods, long-long-int),
     //           tv(I %Int (2 ^Int absInt(bitSizeofType(t(Mods, long-long-int)))), T))
     //      requires (absInt(I) >Int (2 ^Int absInt(bitSizeofType(t(Mods, long-long-int)))))
     //           andBool hasIntegerType(T)
     //      [structural]
     // rule cast(T':Type, tv(I:Int, T:Type))
     //      => tv(I +Int (2 ^Int absInt(bitSizeofType(T'))), T')
     //      requires (I <Int min(T'))
     //           andBool (absInt(I) <=Int (2 ^Int absInt(bitSizeofType(T'))))
     //           andBool hasSignedIntegerType(T')
     //           andBool hasIntegerType(T)
     //           andBool notBool isBoolType (T')
     //      [structural]
     // rule cast(T':Type, tv(I:Int, T:Type))
     //      => tv(I -Int (2 ^Int absInt(bitSizeofType(T'))), T')
     //      requires (I >Int max(T'))
     //           andBool (absInt(I) <=Int (2 ^Int absInt(bitSizeofType(T'))))
     //           andBool hasSignedIntegerType(T')
     //           andBool hasIntegerType(T)
     //           andBool notBool isBoolType (T')
     //      [structural]

     rule cast(T':Type, tv(I:Int, T:Type)) => castHold(T':Type, tv(I:Int, T:Type))
          requires hasSignedIntegerType(T') andBool hasIntegerType(T)
               andBool notBool inRange(I, T')

     rule (.K => UNSPEC("CCV2",
               "conversion to signed integer outside the range that can be represented.",
               "6.3.1.3:3"))
          ~> castHold(T':Type, tv(I:Int, T:Type))
          requires hasSignedIntegerType(T') andBool hasIntegerType(T)
               andBool notBool inRange(I, T')
          [structural]

     // TODO(chathhorn): not sure about this.
     rule cast(T':Type, tv(unknown, T:Type))
          => tv(unknown, cast(T', T))
          requires bitSizeofType(T') >=Int bitSizeofType(T)

     rule cast(T':Type, tv(unknown, T:Type))
          => tv(trap, cast(T', T))

     /*@ \fromStandard{\source[n1570]{\para{6.3.1.4}{1}}}{
     When a finite value of real floating type is converted to an integer type
     other than \cinline{_Bool}, the fractional part is discarded (i.e., the
     value is truncated toward zero). If the value of the integral part cannot
     be represented by the integer type, the behavior is undefined.
     }*/
     rule cast(T':Type, tv(V:Float, T:Type)) => tv(Float2Int(V), cast(T', T))
          requires hasIntegerType(T') andBool hasFloatType(T)
               andBool inRange(Float2Int(V), T')
               andBool notBool isBoolType (T')

     rule cast(T':Type, tv(V:Float, T:Type)) => castHold(T':Type, tv(V:Float, T:Type))
          requires hasIntegerType(T') andBool hasFloatType(T)
               andBool notBool inRange(Float2Int(V), T')

     rule (.K => UNDEF("CCV3",
               "conversion to integer from float outside the range that can be represented.",
               "6.3.1.4:1"))
          ~> castHold(T':Type, tv(V:Float, T:Type))
          requires hasIntegerType(T') andBool hasFloatType(T)
               andBool notBool inRange(Float2Int(V), T')
          [structural]

     /*@ \fromStandard{\source[n1570]{\para{6.3.1.4}{2}}}{
     When a value of integer type is converted to a real floating type, if the
     value being converted can be represented exactly in the new type, it is
     unchanged. If the value being converted is in the range of values that can
     be represented but cannot be represented exactly, the result is either the
     nearest higher or nearest lower representable value, chosen in an
     implementation-defined manner. If the value being converted is outside the
     range of values that can be represented, the behavior is undefined.
     Results of some implicit conversions may be represented in greater range
     and precision than that required by the new type (see 6.3.1.8 and
     6.8.6.4).
     }*/
     rule cast(T':Type, tv(V:Int, T:Type))
          => tv(Int2Float(V, 53, 11), cast(T', T))
          requires hasIntegerType(T)
               andBool inRange(Int2Float(V, 53, 11), T')

     /*@ \fromStandard{\source[n1570]{\para{6.3.1.5}{2}}}{
     When a value of real floating type is converted to a real floating type,
     if the value being converted can be represented exactly in the new type,
     it is unchanged. If the value being converted is in the range of values
     that can be represented but cannot be represented exactly, the result is
     either the nearest higher or nearest lower representable value, chosen in
     an implementation-defined manner. If the value being converted is outside
     the range of values that can be represented, the behavior is undefined.
     Results of some implicit conversions may be represented in greater range
     and precision than that required by the new type (see 6.3.1.8 and
     6.8.6.4).
     }*/
     rule cast(T':Type, tv(V:Float, T:Type)) => tv(V, cast(T', T))
          requires hasFloatType(T') andBool hasFloatType(T)
               andBool inRange(V, T')

     rule cast(T':Type, tv(V:Float, T:Type)) => castHold(T':Type, tv(V:Float, T:Type))
          requires hasFloatType(T') andBool hasFloatType(T)
               andBool notBool inRange(V, T')

     rule (.K => UNDEF("CCV4",
               "floating-point value outside the range of values that can be represented after conversion.",
               "6.3.1.5:1"))
          ~> castHold(T':Type, tv(V:Float, T:Type))
          requires hasFloatType(T') andBool hasFloatType(T)
               andBool notBool inRange(V, T')
          [structural]

     /*@ \fromStandard{\source[n1570]{\para{6.3.2.2}{1}}}{
     The (nonexistent) value of a void expression (an expression that has type
     \cinline{void}) shall not be used in any way, and implicit or explicit
     conversions (except to \cinline{void}) shall not be applied to such an
     expression. If an expression of any other type is evaluated as a void
     expression, its value or designator is discarded. (A void expression is
     evaluated for its side effects.)
     }*/
     rule cast(t(_, void), _:RValue) => voidVal

     rule cast(t(_, T:SimpleType), emptyValue) => castHold(t(.Set, T), emptyValue)
          requires T =/=K void
     rule cast(t(_, T:SimpleType), voidVal) => castHold(t(.Set, T), voidVal)
          requires (T =/=K void)

     rule (.K => UNDEF("CCV5", "casting empty value to type other than void.", "6.3.2.2"))
          ~> castHold(t(_, T:SimpleType), emptyValue)
          requires T =/=K void
          [structural]
     rule (.K => UNDEF("CCV6", "casting void type to non-void type.", "6.3.2.2") )
          ~> castHold(t(_, T:SimpleType), voidVal)
          requires (T =/=K void)
          [structural]

     /*@ \fromStandard{\source[n1570]{\para{6.3.2.3}{1--2}}}{
     A pointer to void may be converted to or from a pointer to any object
     type. A pointer to any object type may be converted to a pointer to void
     and back again; the result shall compare equal to the original pointer.

     For any qualifier $q$, a pointer to a non-$q$-qualified type may be
     converted to a pointer to the $q$-qualified version of the type; the
     values stored in the original and converted pointers shall compare equal.
     }*/


     /*@ \fromStandard{\source[n1570]{\para{6.3.2.3}{3}}}{
     An integer constant expression with the value 0, or such an expression
     cast to type \cinline{void *}, is called a null pointer constant. If a
     null pointer constant is converted to a pointer type, the resulting
     pointer, called a null pointer, is guaranteed to compare unequal to a
     pointer to any object or function.
     }*/
     rule cast(T':Type, V:RValue) => tv(NullPointer, cast(T', type(V)))
          requires isNullPointerConstant(V)
               andBool isPointerType(T')

     /*@ \fromStandard{\source[n1570]{\para{6.3.2.3}{4}}}{
     Conversion of a null pointer to another pointer type yields a null pointer
     of that type. Any two null pointers shall compare equal.
     }*/
     rule cast(T':Type, tv(NullPointer, T:Type)) => tv(NullPointer, cast(T', T))
          requires isPointerType(T)
               andBool isPointerType(T')
          [structural, anywhere]

     /*@ \fromStandard{\source[n1570]{\para{6.3.2.3}{5}}}{
     An integer may be converted to any pointer type. Except as previously
     specified, the result is implementation-defined, might not be correctly
     aligned, might not point to an entity of the referenced type, and might be
     a trap representation.
     }*/
     rule cast(T':Type, tv(V:CValue, T:Type))
          => tv(cfg:intToPointer(V), cast(T', T))
          requires hasIntegerType(T)
               andBool (V =/=K 0)
               andBool isPointerType(T')

     /*@ \fromStandard{\source[n1570]{\para{6.3.2.3}{6}}}{
     Any pointer type may be converted to an integer type. Except as previously
     specified, the result is implementation-defined. If the result cannot be
     represented in the integer type, the behavior is undefined. The result
     need not be in the range of values of any integer type.
     }*/
     rule cast(T':Type, tv(V:CValue, T:Type))
          => tv(cfg:pointerToInt(V), cast(T', T))
          requires isPointerType(T)
               andBool hasIntegerType(T') andBool notBool isBoolType(T')
               andBool (byteSizeofType(T) <=Int byteSizeofType(T')
                    orBool (V ==K NullPointer))
     rule cast(T':Type, tv(V:CValue, T:Type))
          => castHold(T':Type, tv(V:CValue, T:Type))
          requires isPointerType(T)
               andBool (V =/=K NullPointer)
               andBool hasIntegerType(T') andBool notBool isBoolType(T')
               andBool byteSizeofType(T) >Int byteSizeofType(T')
     rule (.K => UNDEF("CCV7",
               "conversion from pointer to integer of a value possibly unrepresentable in the integer type.",
               "6.3.2.3:6"))
          ~> castHold(T':Type, tv(V:CValue, T:Type))
          requires isPointerType(T)
               andBool (V =/=K NullPointer)
               andBool hasIntegerType(T') andBool notBool isBoolType(T')
               andBool byteSizeofType(T) >Int byteSizeofType(T')
          [structural]

     rule cast(T':Type, tv(V:CValue, T:Type))
          => castHold(T', tv(V, T))
          requires (isPointerType(T) andBool hasFloatType(T'))
               orBool (hasFloatType(T) andBool isPointerType(T'))
               orBool (notBool isPointerType(T) andBool notBool hasArithmeticType(T) andBool notBool isVoidType(T'))
               orBool (notBool isPointerType(T') andBool notBool hasArithmeticType(T') andBool notBool isVoidType(T'))

     rule (.K => CV("CCV9",
          "conversion from pointer to floating point type or from floating point type to pointer.",
          "6.5.4:4"))
          ~> castHold(T':Type, tv(_, T:Type))
          requires (isPointerType(T) andBool hasFloatType(T'))
               orBool (hasFloatType(T) andBool isPointerType(T'))

     // TODO(chathhorn): note that this breaks handling of compound literals.
     rule (.K => CV("CCV10",
          "conversion to or from non-scalar type.",
          "6.5.4:2"))
          ~> castHold(T':Type, tv(_, T:Type))
          requires notBool isVoidType(T') andBool (
               (notBool isPointerType(T) andBool notBool hasArithmeticType(T)) orBool
               (notBool isPointerType(T') andBool notBool hasArithmeticType(T')))

     /*@ \fromStandard{\source[n1570]{\para{6.3.2.3}{7}}}{
     A pointer to an object type may be converted to a pointer to a different
     object type. If the resulting pointer is not correctly aligned for the
     referenced type, the behavior is undefined. Otherwise, when converted back
     again, the result shall compare equal to the original pointer. When a
     pointer to an object is converted to a pointer to a character type, the
     result points to the lowest addressed byte of the object. Successive
     increments of the result, up to the size of the object, yield pointers to
     the remaining bytes of the object.
     }*/
     /*@ \fromStandard{\source[n1570]{\para{6.3.2.3}{8}}}{
     A pointer to a function of one type may be converted to a pointer to a
     function of another type and back again; the result shall compare equal to
     the original pointer. If a converted pointer is used to call a function
     whose type is not compatible with the referenced type, the behavior is
     undefined.
     }*/
     rule cast(t(Mods':Set, pointerType(T':Type)),
               tv(Loc:SymLoc, t(Mods:Set, pointerType(T:Type))))
          => tv(Loc, cast(t(Mods', pointerType(T')), t(Mods, pointerType(T))))
          requires getAlignas(T') <=Int getAlign(Loc)
     //TODO(dwightguth): handle pointer alignment
     rule cast(t(_, pointerType(T':Type)), tv(Loc:SymLoc, t(_, pointerType(T:Type))))
          => castHold(t(.Set, pointerType(T':Type)), tv(Loc:SymLoc, t(.Set, pointerType(T))))
          requires getAlignas(T') >Int getAlign(Loc)
     rule (.K => UNDEF("CCV11",
               "conversion to a pointer type with a stricter alignment requirement (possibly undefined).",
               "6.3.2.3:7"))
          ~> castHold(t(_, pointerType(T':Type)), tv(Loc:SymLoc, t(_, pointerType(_))))
          requires getAlignas(T') >Int getAlign(Loc)
          [structural]

     syntax Type ::= cast(Type, Type) [function, klabel('castTypes)]

     rule cast(T':Type, T:Type) => T'
          requires notBool hasReadFrom(T)
               andBool notBool fromConstantExpr(T)
     rule cast(T':Type, T:Type)
          => addModifier(readFrom(getReadFrom(T)), stripReadFrom(T'))
          requires hasReadFrom(T)
     rule cast(T':Type, T:Type) => addModifiers(getConstants(T), T')
          requires fromConstantExpr(T)
endmodule

