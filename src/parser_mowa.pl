% ------------- 
% Authored By : Vijay Ram Giduturi, Nikhil Alapati, Phani Teja Inaganti
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





% Loop statements - Traditional 'for' loop, 'for i in range(x,y)' loop, and a 'while' loop
% FOR::= for ( IN ; C ; U ) { K } | for I in range ( N , N ) { K }
% WHILE::= while(C) {K}

loop_for(L) --> forTraditionalLoop(L) | forInRangeLoop(L) .

forTraditionalLoop(L) --> [for], ['('], id(L1), [=], number(L2), [;], booleanExpr(L3), [;], initialize(L4), [')'], ['{'], block(L5), ['}'], { L = l_forTraditional(L1,L2,L3,L4,L5) }. 

forInRangeLoop(L) --> [for], id(L1), [in], [range], ['('], field(L2), [','], field(L3), [')'], ['{'], block(L4), ['}'], { L = l_forInRange(L1,L2,L3,L4) }.
 
loop_while(L) --> [while], ['('], booleanExpr(L1), [')'], ['{'], block(L2), ['}'], { L = l_while(L1,L2) }.
           




% This is used to show output on the output screen
% Print::= show(“V”) | show(I)

showStatement(S) -->  expression(S1), { S = s_showStmt(S1) }.




% It includes all boolean operations and conditions based on it.   
% B ::= true | false | ~ B | B or B | B ^ B   
% C ::= E < E | E > E | E<= E | E >= E | E == E | E ~= E | B
% Merged both in the same one(in B)

booleanExpr(B) -->  [true], { B = (true) } | [false], { B = (false) }  | [~], booleanExpr(B1), { B = b_not(B1) } 
                | expression(B1), [==], expression(B2), { B = b_exprEqualExpr(B1,B2) } 
                | expression(B1), [==], booleanExpr(B2), { B = b_exprEqualBool(B1,B2) } | booleanExpr(B1), [==], expression(B2), { B = b_boolEqualExpr(B1,B2) } 
                | expression(B1), [~], [=], booleanExpr(B2), { B = b_exprNotBool(B1,B2) } | booleanExpr(B1), [~], [=], expression(B2), { B = b_boolNotExpr(B1,B2) } | [true], [==], [true], { B=(true) } 
                | [false], [==], [false], { B = (true) } | [true], [==], [false], { B = (false) } 
                | [false], [==], [true], { B = (false) } 
                | expression(B1), [~], [=], expression(B2), { B = b_exprNotExpr(B1,B2) }  
                | booleanExpr(B1), [^], booleanExpr(B2), { B = b_and(B1,B2) } | expression(B1), [>], expression(B2), { B = b_exprGTExpr(B1,B2) } 
                | booleanExpr(B1), [or], booleanExpr(B2), { B = b_or(B1,B2) } | expression(B1), [<], expression(B2), { B = b_exprLTExpr(B1,B2) } 
                | expression(B1) ,[<=], expression(B2), { B = b_exprLTEExpr(B1,B2) } | expression(B1), [>=], expression(B2), { B = b_exprGTEExpr(B1,B2) }.  




% Arithmetic Expressions, string 
% E ::= E + E | E - E | E * E | E / E | I | N | T

expression(E)--> expression(E1), [+], expr(E2), { E = e_addition(E1,E2) } 
               | expression(E1), [-], expr(E2), { E = e_subtraction(E1,E2) } | ['('], booleanExpr(E1), ['?'], ternary(E2), [:], ternary(E3), [')'], { E = e_ternaryStmt(E1,E2,E3) } 
               | expr(E) .


expr(E)--> expr(E1) , [*], field(E2), { E = e_multiplication(E1,E2) }
        | expr(E1) , [/], field(E2), { E = e_division(E1,E2) }
        | field(E).

field(E) --> id(E) | number(E) | stringExpr(E).





% String matching
% I::= [a-z] Ids | [A-Z] Ids
% Ids ::= [a-z] | [A-Z] | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | empty

stringExpr(string(S)) --> [S], {string(S)}.

% Identifier matching

id(identifiers(I)) -->[I], { atom(I), identifiers_in_lexer(R), not(member(I,R)) }.

% Reserved identifiers which need to be matched

identifiers_in_lexer([+, -, >, <, =, ^, or, ~, ==, --, ++, <=, >=, if, elseIf, else, for, in, range, while, show, true, false]).





% Number matching

% N::= 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9

number(number(N)) --> [N], { number(N) }.





% Ternary condition value

ternary(C) --> expression(C) | booleanExpr(C) | stringExpr(C) | id(C) |  number(C).

