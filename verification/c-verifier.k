require "../semantics/c11.k"
require "int_set.k"
require "tree_pattern.k"

module C-VERIFIER
  imports C11
  imports C-CONFIGURATION
  imports TREE-PATTERN

  rule (I1:Int &Int I2:Int) &Int I2:Int => I1:Int &Int I2:Int    [lemma]
  rule I:Int |Int 0 => I [lemma]
  rule 0 |Int I:Int => I [lemma]
  rule ((I1:Int >>Int I2:Int) &Int I3:Int) <<Int I2:Int => I1 &Int (I3 <<Int I2) [lemma]
  rule (I1:Int &Int I2:Int) |Int (I1:Int &Int I3:Int)
    => I1 &Int (I2 |Int I3)
    [lemma]
  syntax KItem ::= "breakpoint"
endmodule

