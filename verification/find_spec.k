// Copyright (c) 2014-2015 K Team. All Rights Reserved.
require "kernelc.k"

module FIND-SPEC
  imports C-VERIFIER

rule
  //<functions>... FUNCTIONS:Map ...</functions>
  <functions> FUNCTIONS:Map </functions>
  //<structs>... STRUCTS:Map ...</structs>
  <structs> STRUCTS:Map </structs>
  <external-types> EXTERNALTYPES:Map </external-types>
  <external-defs> EXTERNALDEFS:Map </external-defs>
  <linkings> LINKINGS:Map </linkings>
  <translation-units> TRANSLATIONUNITS:Bag </translation-units>
    <activeBlocks> .Map => ?_:Map </activeBlocks>
  <next-malloced> (_:Int => ?_:Int) @ alloc </next-malloced>
  <status> mainCalled </status>
  <mem>... MEM:Map tree(TP)(T:Tree) ...</mem>
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
            tv(loc(0 @ static("find.c"), 0),
               t(.Set, pointerType(t(.Set, functionType(t(.Set, int), ListItem(t(.Set, int)) ListItem(t(.Set, pointerType(t(.Set, structType(global(Identifier("treeNode"), "find.c"))))))))))),
            rvlist(
                ListItem(tv(V:Int &Int 4294967295, t(.Set, int)))
                ListItem(tv(TP:HeapSymLoc, t(.Set, pointerType(t(.Set, structType(global(Identifier("treeNode"), "find.c")))))))))
      =>
        tv(?B:Int, t(?_:Set, int))
      ...</k>
    ...</thread>
  </threads>
  <files>
    <file-commands> .K </file-commands>
  </files>
  <error-cell-wrapper> .Bag </error-cell-wrapper>
requires bst(T)
 andBool Initializing >=Int 0
 andBool min(t(.Set, int)) <=Int V:Int &Int 4294967295
 andBool V:Int &Int 4294967295 <=Int max(t(.Set, int))
ensures (?B =/=K 0) ==K ((V &Int 4294967295) inIntSet tree_keys(T))


endmodule

