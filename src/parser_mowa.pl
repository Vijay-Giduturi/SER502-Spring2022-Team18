% ------------- 
% Authored By : Vijay Ram Giduturi
% -------------

:- table booleanExpr/3, expression/3, expr/3.

% Input to our program would be list of tokens.
% P ::= K

program(t_program(P)) --> block(P).




% Block is divided to set of statements or a single statement
% K ::= S K | S

block(B) --> statement(S1), block(S2), { B = b_statement(S1, S2) } | statement(S1), { B = b_statement(S1) } . 




% Each statement is ended by a @.
% Statements can have an initialization, conditions, loops and printing statements.
% S::=IN |IF|FOR|WHILE|Print|U

statement(S) --> initialize(S1), [@], { S = s_initializeStmt(S1) } | ifThenElse(S1), { S = s_ifThenElseStmt(S1) } 
                | loop_for(S1), { S = s_forloop(S1) } | loop_while(S1), { S = s_whileloop(S1) }
                | [show], ['('], showStatement(S), [')'], [@].
                



% Initialization can be used for assigment operations, boolean, unary and ternary statements
% IN::= I → E | I → B | I → “I” | D → E| D →B | D → “I”

initialize(I) --> id(I1), [=], booleanExpr(I2), { I = i_boolean(I1,I2) } | unaryExpr(I1), { I = i_unaryStmt(I1) } 
                | id(I1), [=], initialize(I2), { I = initialize(I1,I2) }
                | expression(I1), { I = i_expression(I1) } .




% Unary statements - increment and decrement
% U::= I++ | I--

unaryExpr(U) --> id(U1), [++], { U = u_increment(U1) } | id(U1), [--], { U = u_decrement(U1) }.




% Conditional statements - If and else 
% IF::= if C { K } ELSE_IF | if C { K } ELSE
% ELSE_IF::= else if B { K } ELSE_IF
% ELSE::=else { K }| empty

ifThenElse(C) --> [if], ['('], booleanExpr(C1), [')'] , ['{'], block(C2), ['}'], { C = c_ifStmt(C1,C2) } 
                | [if], ['('], booleanExpr(C1), [')'] , ['{'], block(C2), ['}'], elseIf(C3), { C = c_ifElseStmt(C1,C2,C3) }.
            
elseIf(C) --> [elseIf], ['('], booleanExpr(C1), [')'], ['{'], block(C2), ['}'], elseIf(C3), { C = c_elseIfElseStmt(C1,C2,C3) } 
            | [elseIf],  ['('], booleanExpr(C1), [')'], ['{'], block(C2), ['}'], { C = c_elseIfStmt(C1,C2) }  
            | [else],  ['{'], block(C1), ['}'], { C = c_elseStmt(C1) }. 




% expressions, loops, booleanexpr, show will be implemented by phani and nikhil 
