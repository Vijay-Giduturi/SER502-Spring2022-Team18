% ------------- 
% Authored By : Nikhil Alapati
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