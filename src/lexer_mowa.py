#Author : Phani Teja Inaganti

import sys
#pyswip is the connection between prolog and python
# In mac use python3, run the command in terminal "pip3 install pyswip" and set up the environment paths, mentioned in readme 
from pyswip import Prolog
# In mac rum the command in terminal "pip3 install sly", sly is used as a library for lexer. 
from sly import Lexer


class mowaLexer(Lexer):

    literals = { '@', '?', ':', '^', '~', ';'}
    #this varaible is used in lex.py file in sly as an attribute 
    tokens = {
                AND,
                ASSIGN,
                BRACKETS,
                COMMENT,
                COMMA,
                DIGIT, 
                DIVIDE, 
                DECR, 
                EQUAL,
                ELSE,
                ELSEIF,
                FOR,
                FALSE,
                GREATERTHAN, 
                GREATERTHANEQUAL,     
                ID, 
                INCR,
                IF,
                IN,
                LESSTHAN, 
                LESSTHANEQUAL,
                MINUS, 
                MULTIPLY, 
                NOT,
                OR,
                RELATIONAL,
                RANGE, 
                STRING,  
                SHOW,
                SUM,  
                TRUE,  
                WHILE    
            }

    # below tokens are for identifiers
    ID = r'[a-zA-Z_][a-zA-Z0-9_]*'
    ID['if'] = IF
    ID['else'] = ELSE
    ID['while'] = WHILE
    ID['show'] = SHOW
    ID['for'] = FOR
    ID['elseIf'] = ELSEIF
    ID['true'] =TRUE
    ID['false'] = FALSE
    ID['^'] = AND
    ID['or'] = OR
    ID['~'] = NOT
    ID['range'] = RANGE
    ID['in'] = IN

    #this is used to skip commented lines
    COMMENT = r'\#(.*)'
    # tokens expressions are mention
    DIVIDE = r'/'
    EQUAL = r'=='
    ASSIGN = r'='
    COMMA = r','
    DIGIT = r'\d+'
    BRACKETS = r'(\(|\)|\{|\})'
    STRING = r'"[^\"]*"'
    INCR = r'\+{2}'
    SUM = r'\+'
    DECR = r'\-{2}'
    MINUS = r'-'
    MULTIPLY = r'\*'
    #below are identifiers
    
    # below are assignment orperators
    RELATIONAL = r'[<*=*>*]+'
    RELATIONAL['>='] = GREATERTHANEQUAL
    RELATIONAL['>'] = GREATERTHAN
    RELATIONAL['<='] = LESSTHANEQUAL
    RELATIONAL['<'] = LESSTHAN
    

    invalid_char = False

    #below varaibles are fixed and are chekced in lex.py file in sly as attributes
    #this is used to ignore the bad characters like spaces and tabs
    ignore = ' \t'
    #this is used to ignore blank lines
    ignore_newline = r'\n+'


    # Used to neglet the commented line of the code
    def COMMENT(self,c):
        return

        # An Error message is showed when any character that is not present in the literals is used in the mowa code
    def error(self, e):
        self.index += 1
        self.invalid_char = True
        print('Bad character')

    # For the token list that is going to be generated in the prolog query, this is used to provide the quotes around the brackets.
    def BRACKETS(self,b):
        b.value = "'"+b.value+"'"
        return b