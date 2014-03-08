module C-STMT-BLOCK
     imports C-SYNTAX
     imports C-DYNAMIC-SYNTAX
     imports C-MEMORY-ALLOC-SYNTAX
     imports COMPAT-SYNTAX

     rule BlockStatement(B:K)
          => pushBlock ~> B ~> popBlock
          [structural]
          
     rule [push-block]:
          <k> pushBlock => . ...</k>
          <local>
               C:Bag
          </local>
          <block-stack> 
               .List => ListItem(C)
          ...</block-stack>
          [structural, large] 
          
     rule [pop-block]:
          <k> popBlock => . ...</k>
          <local>
               (_ => C)
          </local>
          <block-stack>
               ListItem(C:Bag) => .List 
          ...</block-stack>
          [structural] 
          
     rule [expression-statement]:
          Computation(_:KResult) => .
          [structural]

     rule Nop => .
          [structural]
     
     rule [dissolve-block]:
          <k> Block(BlockNum:Int, _, list(Statements:List))
               => listToK(Statements)
          ...</k>
          <curr-block> _ => BlockNum </curr-block>
          [structural]

endmodule