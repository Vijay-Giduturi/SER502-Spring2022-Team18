% ------------- 
% Authored By : Nikhil Alapati, Srikruthi Vedantham, Krishna Chandra Sen Dadi 
% -------------

%% Evaluator of the Grammar %%
%% Semantical Analysis is done with the help of the below code %%



% The Program starts here, the query calls this predicate 
program_eval(P) :- eval_program(P, [], _).


% this is called by evaluator which checks for a block of statements
eval_program(t_program(S), Env, Env_F) :- eval_statement(S, Env, Env_F).


% block can contain more than one statement or one statement
% a Statement can have condiditons, loops, printing function or any initialization
eval_statement(b_statement(S1, S2), Env, Env_F) :- eval_statement(S1, Env, Env1), eval_statement(S2, Env1, Env_F).

eval_statement(b_statement(S), Env, Env_F) :- eval_statement(S, Env, Env_F).

eval_statement(s_initializeStmt(S), Env, Env_F) :- eval_initializeStmt(S, Env, _, Env_F).

eval_statement(s_forloop(S), Env, Env_F) :- eval_loopfor(S, Env, Env_F).

eval_statement(s_whileloop(S), Env, Env_F) :- eval_loopwhile(S, Env, Env_F).

eval_statement(s_ifThenElseStmt(S), Env, Env_F) :- eval_ifThenElseStmt(S, Env, Env_F).

eval_statement(s_showStmt(S), Env, Env_F) :- eval_showStmt(S, Env, Env_F).


% This part of evaluator block takes care of all the if else statements in the code
eval_ifThenElseStmt(c_ifStmt(C1, C2), Env, Env_F) :- eval_booleanExpr(C1, Env, true, Env1), eval_statement(C2, Env1, Env_F) | eval_booleanExpr(C1, Env, false, Env_F).

eval_ifThenElseStmt(c_ifElseStmt(C1, C2, C3), Env, Env_F) :- eval_booleanExpr(C1, Env, true, Env1), eval_statement(C2, Env1, Env_F) | eval_booleanExpr(C1, Env, false, Env1), eval_ifThenElseStmt(C3, Env1, Env_F).

eval_ifThenElseStmt(c_elseIfElseStmt(C1, C2, C3), Env, Env_F) :- eval_booleanExpr(C1, Env, true, Env1), eval_statement(C2, Env1, Env_F) | eval_booleanExpr(C1, Env, false, Env1), eval_ifThenElseStmt(C3, Env1, Env_F).

eval_ifThenElseStmt(c_elseIfStmt(C1, C2), Env, Env_F) :- eval_booleanExpr(C1, Env, true, Env1), eval_statement(C2, Env1, Env_F) | eval_booleanExpr(C1, Env, false, Env_F).

eval_ifThenElseStmt(c_elseStmt(C2), Env, Env_F) :- eval_statement(C2, Env, Env_F).


% There are two types of for loop being implemented, one is normal for loop and other is for in range loop

% The normal for loop evalution is done here
eval_loopfor(l_forTraditional(L1, L2, L3, L4, L), Env, Env_F) :- eval_expression(L2, Env, V1, Env1), update(L1, V1, Env1, Env2), eval_loopfor(l_forTraditional(L3, L4, L), Env2, Env_F).

eval_loopfor(l_forTraditional(L1, L2, L), Env, Env_F) :- eval_booleanExpr(L1, Env, true, Env1), eval_statement(L, Env1, Env2), eval_initializeStmt(L2, Env2, _, Env3),
                                                         eval_loopfor(l_forTraditional(L1, L2, L), Env3, Env_F) | eval_booleanExpr(L1, Env, false, Env_F).


% The for in range loop evaluation is done here
eval_loopfor(l_forInRange(L1, L2, L3, L), Env, Env_F) :- eval_expression(L2, Env, Begin, Env1), eval_expression(L3, Env1, Stop, Env2), update(L1, Begin, Env2, Env3),
                                                         Begin =< Stop, eval_loopfor(forRangeIncr(L1, Begin, Stop, L), Env3, Env_F).

eval_loopfor(l_forInRange(L1, L2, L3, L), Env, Env_F) :- eval_expression(L2, Env, Begin, Env1), eval_expression(L3, Env1, Stop, Env2), update(L1, Begin, Env2, Env3),
                                                         Begin >= Stop, eval_loopfor(forRangeDecr(L1, Begin, Stop, L), Env3, Env_F).

eval_loopfor(forRangeIncr(L1, L2, L3, L), Env, Env_F) :- eval_statement(L, Env, Env1), lookup(L1, Env1, V), V1 is V+1, V1 >= L2, V1 =< L3, update(L1, V1, Env1, Env2),
                                                         eval_loopfor(forRangeIncr(L1, L2, L3, L), Env2, Env_F).

eval_loopfor(forRangeIncr(L1, _, L2, _), Env, Env) :- lookup(L1, Env, V), V1 is V+1, V1 > L2.

eval_loopfor(forRangeDecr(L1, L2, L3, L), Env, Env_F) :- eval_statement(L, Env, Env1), lookup(L1, Env1, V), V1 is V-1, V1 =< L2, V1 >= L3, update(L1, V1, Env1, Env2),
                                                         eval_loopfor(forRangeDecr(L1, L2, L3, L), Env2, Env_F).

eval_loopfor(forRangeDecr(L1, _, L2, _), Env, Env) :- lookup(L1, Env, V), V1 is V-1, V1 < L2.  



% While loop semantics checking 
eval_loopwhile(l_while(L1, L2), Env, Env_F) :- eval_booleanExpr(L1, Env, true, Env1), eval_statement(L2, Env1, Env2), 

                                               eval_loopwhile(l_while(L1, L2), Env2, Env_F) | eval_booleanExpr(L1, Env, false, Env_F).

% Display of the piece of code which being printed is validated here
eval_showStmt(S, Env, Env_F) :- eval_expression(S, Env, V, Env_F), writeln(V).



% All the boolean evaluations are done in this block

gt(E1, E2, true) :- number(E1), number(E2), E1 > E2.
gt(E1, E2, false) :- number(E1), number(E2), E1 =< E2.
lt(E1, E2, true) :- number(E1), number(E2), E1 < E2.
lt(E1, E2, false) :- number(E1), number(E2), E1 >= E2.
gtOrEqualto(E1, E2, true) :- number(E1), number(E2), E1 >= E2.
gtOrEqualto(E1, E2, false) :- number(E1), number(E2), E1 < E2.
ltOrEqualto(E1, E2, true) :- number(E1), number(E2), E1 =< E2.
ltOrEqualto(E1, E2, false) :- number(E1), number(E2), E1 > E2.

equalto(true, true, true).
equalto(false, false, true).
equalto(true, false, false).
equalto(false, true, false).
equalto(E1, E2, true) :- number(E1), number(E2), E1 =:= E2.
equalto(E1, E2, false) :- number(E1), number(E2), E1 \= E2.
equalto(E1, E2, true) :- string(E1), string(E2), E1 == E2.
equalto(E1, E2, false) :- string(E1), string(E2), E1 \= E2.

% here ^ is and
^(E1, E2, true) :- E1 = true, E2 = true.
^(E1, E2, false) :- E1 = false, E2 = false.
^(E1, E2, false) :- E1 = true, E2 = false.
^(E1, E2, false) :- E1 = false, E2 = true.

or(E1, E2, true) :- E1 = true, E2 = true.
or(E1, E2, true) :- E1 = true, E2 = false.
or(E1, E2, true) :- E1 = false, E2 = true.
or(E1, E2, false) :- E1 = false, E2 = false.

% here ~ is not
~(true, false).
~(false, true).

eval_booleanExpr(B, Env, B, Env) :- B == true | B == false.

eval_booleanExpr(b_not(B), Env, V, Env_F) :- eval_booleanExpr(B, Env, R, Env_F), V \= R.

eval_booleanExpr(b_exprEqualExpr(B1, B2), Env, V, Env_F) :- eval_expression(B1, Env, V1, Env1), eval_expression(B2, Env1, V2, Env_F), equalto(V1, V2, V).

eval_booleanExpr(b_exprEqualBool(B1, B2), Env, true, Env_F) :- eval_expression(B1, Env, V1, Env1), eval_booleanExpr(B2, Env1, V2, Env_F), V1 =:= V2.
eval_booleanExpr(b_exprEqualBool(B1, B2), Env, false, Env_F) :- eval_expression(B1, Env, V1, Env1), eval_booleanExpr(B2, Env1, V2, Env_F), V1 \= V2.

eval_booleanExpr(b_boolEqualExpr(B1, B2), Env, true, Env_F) :- eval_booleanExpr(B1, Env, V1, Env1), eval_expression(B2, Env1, V2, Env_F), V1 =:= V2.
eval_booleanExpr(b_boolEqualExpr(B1, B2), Env, false, Env_F) :- eval_booleanExpr(B1, Env, V1, Env1), eval_expression(B2, Env1, V2, Env_F), V1 \= V2.

eval_booleanExpr(b_exprNotBool(B1, B2), Env, true, Env_F) :- eval_expression(B1, Env, V1, Env1), eval_booleanExpr(B2, Env1, V2, Env_F), V1 \= V2.
eval_booleanExpr(b_exprNotBool(B1, B2), Env, false, Env_F) :- eval_expression(B1, Env, V1, Env1), eval_booleanExpr(B2, Env1, V2, Env_F), V1 =:= V2.

eval_booleanExpr(b_boolNotExpr(B1, B2), Env, true, Env_F) :-  eval_booleanExpr(B1, Env, V1, Env1), eval_expression(B2, Env1, V2, Env_F), V1 \= V2.
eval_booleanExpr(b_boolNotExpr(B1, B2), Env, false, Env_F) :- eval_booleanExpr(B1, Env, V1, Env1), eval_expression(B2, Env1, V2, Env_F), V1 =:= V2.

eval_booleanExpr(b_exprNotExpr(B1, B2), Env, true, Env_F) :- eval_expression(B1, Env, V1, Env1), eval_expression(B2, Env1, V2, Env_F), V1 \= V2.
eval_booleanExpr(b_exprNotExpr(B1, B2), Env, false, Env_F) :- eval_expression(B1, Env, V1, Env1), eval_expression(B2, Env1, V2, Env_F), V1 =:= V2.

eval_booleanExpr(b_and(B1, B2), Env, V, Env_F) :- eval_booleanExpr(B1, Env, V1, Env1), eval_booleanExpr(B2, Env1, V2, Env_F), ^(V1, V2, V).

eval_booleanExpr(b_or(B1, B2), Env, V, Env_F) :- eval_booleanExpr(B1, Env, V1, Env1), eval_booleanExpr(B2, Env1, V2, Env_F), or(V1, V2, V).

eval_booleanExpr(b_exprGTExpr(B1, B2), Env, V, Env_F) :- eval_expression(B1, Env, V1, Env1), eval_expression(B2, Env1, V2, Env_F), gt(V1, V2, V).

eval_booleanExpr(b_exprGTEExpr(B1, B2), Env, V, Env_F) :- eval_expression(B1, Env, V1, Env1), eval_expression(B2, Env1, V2, Env_F), gtOrEqualto(V1, V2, V).

eval_booleanExpr(b_exprLTExpr(B1, B2), Env, V, Env_F) :- eval_expression(B1, Env, V1, Env1), eval_expression(B2, Env1, V2, Env_F), lt(V1, V2, V).

eval_booleanExpr(b_exprLTEExpr(B1, B2), Env, V, Env_F) :- eval_expression(B1, Env, V1, Env1), eval_expression(B2, Env1, V2, Env_F), ltOrEqualto(V1, V2, V).

