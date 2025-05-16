# mnemo
 Mnemo - A Text-Based Adventure Programming Language
 
NOTES/README - Dallas

5/16/25:

The scanner, parser, AST, SAST, semantic analyzer, IRgen, and main driver are all functional and working.  


https://github.com/user-attachments/assets/daab91a7-fd63-4b77-8aca-058cff3303d9

To compile (updated build instructions 5/16/25):

```
brew install menhir

cd ocaml_src
ocamlc -c ast.ml
ocamlc -c sast.ml
ocamllex scanner.mll
menhir --infer parser.mly
ocamlc -c parser.mli
ocamlc -c parser.ml
ocamlfind ocamlopt \
  -package llvm,llvm.analysis,llvm.bitwriter \
  -linkpkg \
  ast.ml sast.ml parser.ml scanner.ml semant.ml irgen.ml main.ml \
  -o mnemo
./mnemo test_game.txt test_game.ll
llc -filetype=obj test_game.ll -o test_game.o
clang test_game.o -o test_game
./test_game
```

test_game.txt can be replaced with any source code file in the Mnemo language

This will run the dialogue stream sequentially in the terminal and process branch options from user input.

Earlier conception using runtime evaluator and OCaml Graphics GUI (experimental/non-IR):

![gui_demo](https://github.com/user-attachments/assets/d7bde540-2aec-4024-8f7b-8d280dfb01bf)

![acquire_item](https://github.com/user-attachments/assets/37ede206-6f83-4210-ab93-766d980f9740)

## Implemented Features
Thus far I have implemented the following features:

 -  Object creation and storing object variables including:
	*  Nodes
	*  Characters
	*  Items
	*  Narratives
	*  Objects and their variable names are stored in hashmaps for tracking.

 -  Code, Node, and Node Blocks
	*  Opening + closing tags: /code /end_code, /nodes /end_nodes, 
		/node /end_node
	*  Can appear in any sequence in the program (any combination of blocks)

 -  Add Item to Inventory
	*  Created items can be added to any created character's inventory

 -  Branch Options
	*  When an option is found in a node, it will prompt the user for a choice
	*  Once a choice is made, the ID of the node with the next label is 
	   returned and set as the node's next link.
	*  Once a choice is made, all other choices have their branches killed off
	   and the user will not have access to those nodes for the duration of the
           game.

 -  Sequential Node IDs
	*  As nodes are declared in the code, they are automatically assigned an
	   auto-incrementing ID number.  
	*  Their next link is automatically set to the next node number in the
	   sequence.  
	*  The next link only changes if options are found in the node and the
	   user makes a choice - this updates the next link to the ID of the
	   node corresponding to the selected option.

 -  Dialogue Text Box
	*  A rudimentary ASCII dialogue text box with the character name and
	   dialogue text appears for each node in the terminal when the game is
	   run.

 -  Newlines and Tabs
	*  \new and \tab found inside dialogue text will automatically be converted
           into newlines and tabs.
	*  If more than 3 newlines are found in a text element, an exception is
	   thrown to limit the size of the dialogue text box.

 -  All operations
	*  Binary ops, unary ops, etc.

 -  Graphics Module
	*  GUI and interactivity via Ocaml Graphics!
 
 - Action Queue (*NEW*)
    *  Nodes are processed sequentially given their internal IDs.  However, this
       is not the case for other objects and operations.
    *  Though character, item, narrative creation are parsed sequentially, they
       will not be run sequentially in the executable.
    *  Solution?  Action queue.  All non-node operations (hp increment, item
       creation, add item to inventory, etc.) are added to a queue. 
    *  Node creation adds a blank entry to queue.  Each time a node is printed
       or an action is completed/other object is created, one item is popped
       from the queue.
    *  The actions are added to the queue sequentially as they are parsed to
       maintain the sequence in the exectuable.
    *  So far, only add item to inventory is processed in the queue (which displays
       a status box in the GUI when popped).
   

## Features to be Implemented

The following functionality still needs to be implemented:

 *  Remaining Functions
	-  Remove item from inventory
	-  Clear inventory
	-  Use item
	-  Sell item
	-  Set character name
	-  Inventory size function

 *  Auto-concatenation
	-  Two text types adjacent to each should be concatenated.

 *  Conditions/Flow Control
	-  If, elif, else

 *  Object Declaration Permutations
	-  Objects should be able to be declared with or without optional tags
	   like "label=", "name=", "hp=", etc.  
	-  All possible permutations of tags + no tags will be implemented to 
	   make sure you can either include or exclude whatever you want while
	   writing code.
	-  So far, Narrative object declarations already have all permutations
	   included.  This will be extended to Items and Characters as well.

## Features that Should be Implemented
The following functionality is not in the manual but should be implemented:

  *  Separate text box for printing status changes
	-  Item acquisition, item selling, HP loss, level up, etc.

  *  Inventory Display
	-  Some way of displaying items in a character's inventory

  *  Store Display
	-  A text display for shops to buy and sell items


## Features to be Removed
The following functionality will be removed:

 *  Export, Import
	-  There is no need for these features.  The game code is typed up in a
           text file and automatically runs as an argument passed to the program
	   in the terminal.  These text files can easily be shared, almost like
	   individual game "cartridges."

 *  Concatenate operator
	-  Cannot see when a label would want to be concatenated to text type.

 *  Print Function
	-  All printouts are done inside the interpreter in OCaml during the game
	   loop logic.  There is no need for a separate print function.

## Build Instructions

	There are four main files:
		*  ast.ml		Abstract Syntax Tree
		*  scanner.mll		Scanner/Lexer
		*  parser.mly		Parser
		*  mnemo.ml		Interpreter/Game Loop Logic
  
	Run the following in terminal:
 		opam install graphics
   		ocamlbuild -use-ocamlfind mnemo.native -pkg graphics

	On MacOS, installing the graphics module should install XQuartz.
 	Restart your Mac after installing before building.

  	On Windows, install WSL (Ubuntu on Windows) and run the
   	above in the Ubuntu terminal.
    
	This compiles the executable; to run it:

	./mnemo.native <game_file.txt>

	Where <game_file> is a text file with your code!

	The game will automatically run in the terminal.

## To generated a parsed version of the example.mn
Run the following in the ocaml_src:
```
ocamlbuild test_parser.native
./test_parser.native < example.mn > example.out
```
The parsed program will be in the file `example.out`

## Other Notes
All files are found in the PLT shared folder under "Hello World Front-end".  I
have included a sample game code file, utop screenshots as things were being
implemented, and a short video of the game being run in the terminal.

Have fun!



