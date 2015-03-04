// Copyright (c) 2014-2015 K Team. All Rights Reserved.
require "kernelc.k"

module MAX-SPEC
  imports C-VERIFIER

rule
  <functions>... FUNCTIONS:Map ...</functions>
  <structs>... STRUCTS:Map ...</structs>
  <external-types> EXTERNALTYPES:Map </external-types>
  <external-defs> EXTERNALDEFS:Map </external-defs>
  <linkings> LINKINGS:Map </linkings>
  <translation-units> TRANSLATIONUNITS:Bag </translation-units>
    <activeBlocks> .Map => ?_:Map </activeBlocks>
  <next-malloced> (_:Int => ?_:Int) @ alloc </next-malloced>
  <status> mainCalled </status>
  <mem>... MEM:Map ...</mem>
  // <mem>... MEM:Map tree(TP)(T:Tree) ...</mem>
  // TODO: pattern
  // <effective-types> .Map </effective-types>
  <threads>
    <thread>...
      <thread-id> 0 </thread-id>
        <buffer> .List </buffer>
        <curr-function> _:CId </curr-function>
        <curr-subobject> .List </curr-subobject>
        <locs-written> _:List => .List </locs-written>
      <formatting-wrapper> .Bag </formatting-wrapper>
      <type-wrapper> .Bag </type-wrapper>
      <initializing> Initializing:Int </initializing>
      <next-loc> (10000 => ?_:Int) @ auto(0) </next-loc>
      <k>
        Call(
            tv(loc(0 @ static("max.c"), 0),
               t(.Set, pointerType(t(.Set, functionType(t(.Set, int), ListItem(t(.Set, int)) ListItem(t(.Set, int))))))),
            rvlist(
                ListItem(tv(X:Int &Int 4294967295, t(.Set, int)))
                ListItem(tv(Y:Int &Int 4294967295, t(.Set, int)))))
      =>
        tv(maxInt(X &Int 4294967295, Y &Int 4294967295), t(?_:Set, int))
      ...</k>
    ...</thread>
  </threads>
  <files>
    <file-commands> .K </file-commands>
  </files>
  <error-cell-wrapper> .Bag </error-cell-wrapper>
requires Initializing >=Int 0
 andBool min(t(.Set, int)) <=Int X:Int &Int 4294967295
 andBool X:Int &Int 4294967295 <=Int max(t(.Set, int))
 andBool min(t(.Set, int)) <=Int Y:Int &Int 4294967295
 andBool Y:Int &Int 4294967295 <=Int max(t(.Set, int))

endmodule

