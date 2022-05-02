################################################
#README for Team18 - 502_Spring2022
################################################

# youtube link of our project
Youtube Link : 

#The README file is related to MacOS#

#Requirements for the project
Since we are using python along with prolog for the development of our project, below are the tools and libraries we have used

1). Python is used to implement lexcial analysis
	Version : python3.9 or higher
	Installation : brew install python3
	Note : Make sure to install brew first and set environment path variables

2). PySwip is the library used to connect python and prolog
	Installation : pip3 install pyswip
	Note: Make sure swipl is on the path variable and DYLD_FALLBACK_LIBRARY_PATH has the directory that contains libsswipl.dylib
	(export DYLD_FALLBACK_LIBRARY_PATH=/Applications/SWI-Prolog.app/Contents/Frameworks
	export PATH=$PATH:/Applications/SWI-Prolog.app/Contents/MacOS)

3). Prolog is used to implement both the parser and semantical analyzer.
	Version : 8.2.10
	Installation : brew install swi-prolog
	Note: Do not use "brew install swi-prolog --HEAD" as this is installing a different/higher version that is not being compatable.

4). sly is used a library that is helpful for lexical analyses
	Instalaltion : pip3 install sly


#Flow of the project
The code that needs to be executed on the implemeted language is first sent to the lexer and done lexcial analysis by creating the list of tokens, then the tokens were passed to the parser to check the grammar and does sematical analysis and then the output of the query (which is the functionality of the code) present in python file is printed on the terminal.

In the terminal,
Go to the directory of the src folder having python file.
1). cd "filepath"

then execute the following command by providing the argument as the path to the code file that we want to execute in our language
2). python lexer_mowa.py ../data/<name_codefile>
