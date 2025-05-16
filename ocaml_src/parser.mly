// Mnemo Parser
// Dallas - NB: This is functional; updates coming

%{
 open Ast
%}

%token PLUS MINUS TIMES DIVIDE
%token PLUSEQ MINUSEQ MULTEQ DIVEQ
%token PLUSPLUS MINUSMINUS
%token NOT OR AND TRUE FALSE
%token COLON DOT COMMA QUESTMARK
%token LPAREN RPAREN LBRACKET RBRACKET
%token EQ IS LT GT LTE GTE
%token IF ELSE ELIF RETURN
%token NARRATIVE CHARACTER ITEM
%token NEXT LABEL HP LEVEL INVENTORY
%token ROOT NARR_LABEL TITLE
%token CODE_BLOCK END_CODE_BLOCK
%token NODE_BLOCK END_NODE_BLOCK
%token NODES_BLOCK END_NODES_BLOCK
%token AT EXCLMPT
%token OPTION
%token ADD REMOVE
%token <int> INT_LITERAL
%token <bool> BOOL_LITERAL
%token <float> FLOAT_LITERAL
%token <string> LABEL_LITERAL
%token <string> TEXT_LITERAL
%token <string> VARIABLE
%token EOF EOL

%right EOL
%right EQ
%left IS NOT GT LT GTE LTE
%left PLUS MINUS
%left TIMES DIVIDE
%nonassoc PLUSPLUS MINUSMINUS

%start exprs_rule
%type <Ast.expr> exprs_rule

%%

// (* main program - sequence of code blocks, node blocks, nodeS blocks *)
exprs_rule:
  | blocks EOF { Seq $1 }
  | /* none */ EOF { Seq [] }

blocks:
  | /* none */ { [] }
  | block              { [$1] }
  | blocks block       { $1 @ [$2] }
block:
  | CODE_BLOCK exprs_seq END_CODE_BLOCK {
      CodeBlock("CODE_BLOCK", $2, "END_CODE_BLOCK")
    }
  | NODE_BLOCK node_rules END_NODE_BLOCK {
      NodeBlock("NODE_BLOCK", [$2], "END_NODE_BLOCK")
    }
  | NODES_BLOCK node_stream END_NODES_BLOCK {
      NodeStream("NODES_BLOCK", $2, "END_NODES_BLOCK")
    }

// (* code block - sequence of non-node expressions *)
exprs_seq:
 | expr_rule { [$1] }
 | exprs_seq expr_rule { $1 @ [$2] }

(* stream of nodes - /nodes block *)
node_stream:
   | node_expr { [$1] }
   | node_stream node_expr { $1 @ [$2] }

node_expr:
| VARIABLE COLON TEXT_LITERAL opt_list {
    let options = List.map (function
      | Tup (TextLit text, LabelLit label) -> (text, label)
      | _ -> failwith "Expected (Text, Label) in opt_list"
    ) $4 in
    let id = !node_counter in
    node_counter := id + 1;
    Nde {
      character = $1;
      id = id;
      dialogue = $3;
      label = "";
      options = options;
      next = id + 1;
    }
  }
| VARIABLE COLON TEXT_LITERAL {
    let id = !node_counter in
    node_counter := id + 1;
    Nde {
      character = $1;
      id = id;
      dialogue = $3;
      label = "";
      options = [];
      next = id + 1;
    }
  }
| VARIABLE COLON TEXT_LITERAL COMMA LABEL LABEL_LITERAL {
    let id = !node_counter in
    node_counter := id + 1;
    Nde {
      character = $1;
      id = id;
      dialogue = $3;
      label = $6;
      options = [];
      next = id + 1;
    }
  }

| VARIABLE COLON TEXT_LITERAL COMMA LABEL LABEL_LITERAL opt_list {
    let options = List.map (function
      | Tup (TextLit text, LabelLit label) -> (text, label)
      | _ -> failwith "Expected (Text, Label) in opt_list"
    ) $7 in
    let id = !node_counter in
    node_counter := id + 1;
    Nde {
      character = $1;
      id = id;
      dialogue = $3;
      label = $6;
      options = options;
      next = id + 1;
    }
  }


// (* node options - tree branch *)
opt_list:
    | option_expr                                   { [$1] }
    | opt_list option_expr                          { $2 :: $1 }

option_expr:
    | AT TEXT_LITERAL COMMA NEXT LABEL_LITERAL { Tup (TextLit $2, LabelLit $5) }


// (* expressions *)
expr_rule:
 INT_LITERAL { IntLit $1 }
 | BOOL_LITERAL { BoolLit $1 }
 | TEXT_LITERAL { TextLit $1 }
 | LABEL_LITERAL { LabelLit $1 }
 | FLOAT_LITERAL { FloatLit $1 }
 | VARIABLE { Var $1 }
 | LPAREN expr_rule RPAREN { $2 }
 | expr_rule PLUS expr_rule { Binop ($1, Add, $3) }
 | expr_rule MINUS expr_rule { Binop ($1, Sub, $3) }
 | expr_rule TIMES expr_rule { Binop ($1, Mul, $3) }
 | expr_rule DIVIDE expr_rule { Binop ($1, Div, $3) }
 | expr_rule GT expr_rule { Binop ($1, Gt, $3) }
 | expr_rule LT expr_rule { Binop ($1, Lt, $3) }
 | expr_rule LTE expr_rule { Binop ($1, Leq, $3) }
 | expr_rule GTE expr_rule { Binop ($1, Geq, $3) }
 | expr_rule IS expr_rule { Binop ($1, Eq, $3) } 
 | expr_rule PLUSPLUS { Unop ($1, Incr) }
 | expr_rule MINUSMINUS { Unop ($1, Decr) }
 | NOT expr_rule { Unop ($2, Not) }
 | VARIABLE EQ expr_rule { Asn ($1, $3) }
//  (* add item to inventory *)
 | VARIABLE DOT INVENTORY DOT ADD LPAREN VARIABLE RPAREN { AddItem ($1, $7) }
 (* narrative object declaration and storage - all permutations *)
| VARIABLE EQ NARRATIVE LPAREN TITLE TEXT_LITERAL COMMA ROOT LABEL_LITERAL COMMA NARR_LABEL LABEL_LITERAL RPAREN {
    Nar {
      title = $6;
      root = $9;
      narr_label = $12;
    }
  }
| VARIABLE EQ NARRATIVE LPAREN TITLE TEXT_LITERAL COMMA ROOT LABEL_LITERAL COMMA LABEL_LITERAL RPAREN {
    Nar {
      title = $6;
      root = $9;
      narr_label = $11;
    }
  }
| VARIABLE EQ NARRATIVE LPAREN TITLE TEXT_LITERAL COMMA LABEL_LITERAL COMMA NARR_LABEL LABEL_LITERAL RPAREN {
    Nar {
      title = $6;
      root = $8;
      narr_label = $11;
    }
  }
| VARIABLE EQ NARRATIVE LPAREN TITLE TEXT_LITERAL COMMA LABEL_LITERAL COMMA LABEL_LITERAL RPAREN {
    Nar {
      title = $6;
      root = $8;
      narr_label = $10;
    }
  }
| VARIABLE EQ NARRATIVE LPAREN TEXT_LITERAL COMMA ROOT LABEL_LITERAL COMMA NARR_LABEL LABEL_LITERAL RPAREN {
    Nar {
      title = $5;
      root = $8;
      narr_label = $11;
    }
  }
| VARIABLE EQ NARRATIVE LPAREN TEXT_LITERAL COMMA ROOT LABEL_LITERAL COMMA LABEL_LITERAL RPAREN {
    Nar {
      title = $5;
      root = $8;
      narr_label = $10;
    }
  }
| VARIABLE EQ NARRATIVE LPAREN TEXT_LITERAL COMMA LABEL_LITERAL COMMA NARR_LABEL LABEL_LITERAL RPAREN {
    Nar {
      title = $5;
      root = $7;
      narr_label = $10;
    }
  }
| VARIABLE EQ NARRATIVE LPAREN TEXT_LITERAL COMMA LABEL_LITERAL COMMA LABEL_LITERAL RPAREN {
    Nar {
      title = $5;
      root = $7;
      narr_label = $9;
    }
  }

 (* item object declaration and storage *)
| VARIABLE EQ ITEM LPAREN TEXT_LITERAL COMMA TEXT_LITERAL COMMA INT_LITERAL COMMA
  BOOL_LITERAL COMMA INT_LITERAL COMMA INT_LITERAL COMMA BOOL_LITERAL RPAREN {
    Itm {
      var_name = $1;
      iname = $5;
      usage = $7;
      num = $9;
      unique = $11;
      dur = $13;
      cost = $15;
      cons = $17;
    }
  }

 (* character object declaration and storage *)
| VARIABLE EQ CHARACTER LPAREN TEXT_LITERAL COMMA INT_LITERAL COMMA INT_LITERAL RPAREN {
    Chrc {
      var_name = $1;
      name = $5;
      level = $7;
      hp = $9;
      inventory = [];
    }
  }
 | expr_rule EOL { $1 }

//  (* /node block - declare and store single node variable *)
node_rules:
| VARIABLE COLON TEXT_LITERAL opt_list {
    let options = List.map (function
      | Tup (TextLit text_lit, LabelLit label_lit) -> (text_lit, label_lit)
      | _ -> failwith "Expected (Text, Label) in opt_list"
    ) $4 in
    let id = !node_counter in
    node_counter := id + 1;
    let node = {
      character = $1;
      id = id;
      dialogue = $3;
      label = "";
      options = options;
      next = id + 1;
    } in
    Nde node
  }

| VARIABLE COLON TEXT_LITERAL {
    let id = !node_counter in
    node_counter := id + 1;
    let node = {
      character = $1;
      id = id;
      dialogue = $3;
      label = "";
      options = [];
      next = id + 1;
    } in
    Nde node
  }

| VARIABLE COLON TEXT_LITERAL COMMA LABEL LABEL_LITERAL opt_list {
    let options = List.map (function
      | Tup (TextLit text_lit, LabelLit label_lit) -> (text_lit, label_lit)
      | _ -> failwith "Expected (Text, Label) in opt_list"
    ) $7 in
    let id = !node_counter in
    node_counter := id + 1;
    Nde {
      character = $1;
      id = id;
      dialogue = $3;
      label = $6;
      options = options;
      next = id + 1
    }
  }