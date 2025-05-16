
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | VARIABLE of (
# 30 "parser.mly"
       (string)
# 15 "parser.ml"
  )
    | TRUE
    | TITLE
    | TIMES
    | TEXT_LITERAL of (
# 29 "parser.mly"
       (string)
# 23 "parser.ml"
  )
    | RPAREN
    | ROOT
    | RETURN
    | REMOVE
    | RBRACKET
    | QUESTMARK
    | PLUSPLUS
    | PLUSEQ
    | PLUS
    | OR
    | OPTION
    | NOT
    | NODE_BLOCK
    | NODES_BLOCK
    | NEXT
    | NARR_LABEL
    | NARRATIVE
    | MULTEQ
    | MINUSMINUS
    | MINUSEQ
    | MINUS
    | LTE
    | LT
    | LPAREN
    | LEVEL
    | LBRACKET
    | LABEL_LITERAL of (
# 28 "parser.mly"
       (string)
# 54 "parser.ml"
  )
    | LABEL
    | ITEM
    | IS
    | INVENTORY
    | INT_LITERAL of (
# 25 "parser.mly"
       (int)
# 63 "parser.ml"
  )
    | IF
    | HP
    | GTE
    | GT
    | FLOAT_LITERAL of (
# 27 "parser.mly"
       (float)
# 72 "parser.ml"
  )
    | FALSE
    | EXCLMPT
    | EQ
    | EOL
    | EOF
    | END_NODE_BLOCK
    | END_NODES_BLOCK
    | END_CODE_BLOCK
    | ELSE
    | ELIF
    | DOT
    | DIVIDE
    | DIVEQ
    | COMMA
    | COLON
    | CODE_BLOCK
    | CHARACTER
    | BOOL_LITERAL of (
# 26 "parser.mly"
       (bool)
# 94 "parser.ml"
  )
    | AT
    | AND
    | ADD
  
end

include MenhirBasics

# 4 "parser.mly"
  
 open Ast

# 108 "parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState000 : ('s, _menhir_box_exprs_rule) _menhir_state
    (** State 000.
        Stack shape : .
        Start symbol: exprs_rule. *)

  | MenhirState004 : (('s, _menhir_box_exprs_rule) _menhir_cell1_NODE_BLOCK _menhir_cell0_VARIABLE _menhir_cell0_TEXT_LITERAL, _menhir_box_exprs_rule) _menhir_state
    (** State 004.
        Stack shape : NODE_BLOCK VARIABLE TEXT_LITERAL.
        Start symbol: exprs_rule. *)

  | MenhirState007 : ((('s, _menhir_box_exprs_rule) _menhir_cell1_NODE_BLOCK _menhir_cell0_VARIABLE _menhir_cell0_TEXT_LITERAL, _menhir_box_exprs_rule) _menhir_cell1_COMMA _menhir_cell0_LABEL_LITERAL, _menhir_box_exprs_rule) _menhir_state
    (** State 007.
        Stack shape : NODE_BLOCK VARIABLE TEXT_LITERAL COMMA LABEL_LITERAL.
        Start symbol: exprs_rule. *)

  | MenhirState014 : (((('s, _menhir_box_exprs_rule) _menhir_cell1_NODE_BLOCK _menhir_cell0_VARIABLE _menhir_cell0_TEXT_LITERAL, _menhir_box_exprs_rule) _menhir_cell1_COMMA _menhir_cell0_LABEL_LITERAL, _menhir_box_exprs_rule) _menhir_cell1_opt_list, _menhir_box_exprs_rule) _menhir_state
    (** State 014.
        Stack shape : NODE_BLOCK VARIABLE TEXT_LITERAL COMMA LABEL_LITERAL opt_list.
        Start symbol: exprs_rule. *)

  | MenhirState016 : ((('s, _menhir_box_exprs_rule) _menhir_cell1_NODE_BLOCK _menhir_cell0_VARIABLE _menhir_cell0_TEXT_LITERAL, _menhir_box_exprs_rule) _menhir_cell1_opt_list, _menhir_box_exprs_rule) _menhir_state
    (** State 016.
        Stack shape : NODE_BLOCK VARIABLE TEXT_LITERAL opt_list.
        Start symbol: exprs_rule. *)

  | MenhirState019 : (('s, _menhir_box_exprs_rule) _menhir_cell1_NODES_BLOCK, _menhir_box_exprs_rule) _menhir_state
    (** State 019.
        Stack shape : NODES_BLOCK.
        Start symbol: exprs_rule. *)

  | MenhirState022 : (('s, _menhir_box_exprs_rule) _menhir_cell1_VARIABLE _menhir_cell0_TEXT_LITERAL, _menhir_box_exprs_rule) _menhir_state
    (** State 022.
        Stack shape : VARIABLE TEXT_LITERAL.
        Start symbol: exprs_rule. *)

  | MenhirState025 : ((('s, _menhir_box_exprs_rule) _menhir_cell1_VARIABLE _menhir_cell0_TEXT_LITERAL, _menhir_box_exprs_rule) _menhir_cell1_COMMA _menhir_cell0_LABEL_LITERAL, _menhir_box_exprs_rule) _menhir_state
    (** State 025.
        Stack shape : VARIABLE TEXT_LITERAL COMMA LABEL_LITERAL.
        Start symbol: exprs_rule. *)

  | MenhirState026 : (((('s, _menhir_box_exprs_rule) _menhir_cell1_VARIABLE _menhir_cell0_TEXT_LITERAL, _menhir_box_exprs_rule) _menhir_cell1_COMMA _menhir_cell0_LABEL_LITERAL, _menhir_box_exprs_rule) _menhir_cell1_opt_list, _menhir_box_exprs_rule) _menhir_state
    (** State 026.
        Stack shape : VARIABLE TEXT_LITERAL COMMA LABEL_LITERAL opt_list.
        Start symbol: exprs_rule. *)

  | MenhirState027 : ((('s, _menhir_box_exprs_rule) _menhir_cell1_VARIABLE _menhir_cell0_TEXT_LITERAL, _menhir_box_exprs_rule) _menhir_cell1_opt_list, _menhir_box_exprs_rule) _menhir_state
    (** State 027.
        Stack shape : VARIABLE TEXT_LITERAL opt_list.
        Start symbol: exprs_rule. *)

  | MenhirState028 : ((('s, _menhir_box_exprs_rule) _menhir_cell1_NODES_BLOCK, _menhir_box_exprs_rule) _menhir_cell1_node_stream, _menhir_box_exprs_rule) _menhir_state
    (** State 028.
        Stack shape : NODES_BLOCK node_stream.
        Start symbol: exprs_rule. *)

  | MenhirState032 : (('s, _menhir_box_exprs_rule) _menhir_cell1_CODE_BLOCK, _menhir_box_exprs_rule) _menhir_state
    (** State 032.
        Stack shape : CODE_BLOCK.
        Start symbol: exprs_rule. *)

  | MenhirState034 : (('s, _menhir_box_exprs_rule) _menhir_cell1_VARIABLE, _menhir_box_exprs_rule) _menhir_state
    (** State 034.
        Stack shape : VARIABLE.
        Start symbol: exprs_rule. *)

  | MenhirState036 : (('s, _menhir_box_exprs_rule) _menhir_cell1_NOT, _menhir_box_exprs_rule) _menhir_state
    (** State 036.
        Stack shape : NOT.
        Start symbol: exprs_rule. *)

  | MenhirState037 : (('s, _menhir_box_exprs_rule) _menhir_cell1_LPAREN, _menhir_box_exprs_rule) _menhir_state
    (** State 037.
        Stack shape : LPAREN.
        Start symbol: exprs_rule. *)

  | MenhirState043 : (('s, _menhir_box_exprs_rule) _menhir_cell1_expr_rule, _menhir_box_exprs_rule) _menhir_state
    (** State 043.
        Stack shape : expr_rule.
        Start symbol: exprs_rule. *)

  | MenhirState048 : (('s, _menhir_box_exprs_rule) _menhir_cell1_expr_rule, _menhir_box_exprs_rule) _menhir_state
    (** State 048.
        Stack shape : expr_rule.
        Start symbol: exprs_rule. *)

  | MenhirState050 : (('s, _menhir_box_exprs_rule) _menhir_cell1_expr_rule, _menhir_box_exprs_rule) _menhir_state
    (** State 050.
        Stack shape : expr_rule.
        Start symbol: exprs_rule. *)

  | MenhirState052 : (('s, _menhir_box_exprs_rule) _menhir_cell1_expr_rule, _menhir_box_exprs_rule) _menhir_state
    (** State 052.
        Stack shape : expr_rule.
        Start symbol: exprs_rule. *)

  | MenhirState054 : (('s, _menhir_box_exprs_rule) _menhir_cell1_expr_rule, _menhir_box_exprs_rule) _menhir_state
    (** State 054.
        Stack shape : expr_rule.
        Start symbol: exprs_rule. *)

  | MenhirState056 : (('s, _menhir_box_exprs_rule) _menhir_cell1_expr_rule, _menhir_box_exprs_rule) _menhir_state
    (** State 056.
        Stack shape : expr_rule.
        Start symbol: exprs_rule. *)

  | MenhirState058 : (('s, _menhir_box_exprs_rule) _menhir_cell1_expr_rule, _menhir_box_exprs_rule) _menhir_state
    (** State 058.
        Stack shape : expr_rule.
        Start symbol: exprs_rule. *)

  | MenhirState060 : (('s, _menhir_box_exprs_rule) _menhir_cell1_expr_rule, _menhir_box_exprs_rule) _menhir_state
    (** State 060.
        Stack shape : expr_rule.
        Start symbol: exprs_rule. *)

  | MenhirState062 : (('s, _menhir_box_exprs_rule) _menhir_cell1_expr_rule, _menhir_box_exprs_rule) _menhir_state
    (** State 062.
        Stack shape : expr_rule.
        Start symbol: exprs_rule. *)

  | MenhirState135 : ((('s, _menhir_box_exprs_rule) _menhir_cell1_CODE_BLOCK, _menhir_box_exprs_rule) _menhir_cell1_exprs_seq, _menhir_box_exprs_rule) _menhir_state
    (** State 135.
        Stack shape : CODE_BLOCK exprs_seq.
        Start symbol: exprs_rule. *)

  | MenhirState140 : (('s, _menhir_box_exprs_rule) _menhir_cell1_blocks, _menhir_box_exprs_rule) _menhir_state
    (** State 140.
        Stack shape : blocks.
        Start symbol: exprs_rule. *)


and ('s, 'r) _menhir_cell1_blocks = 
  | MenhirCell1_blocks of 's * ('s, 'r) _menhir_state * (Ast.expr list)

and ('s, 'r) _menhir_cell1_expr_rule = 
  | MenhirCell1_expr_rule of 's * ('s, 'r) _menhir_state * (Ast.expr)

and ('s, 'r) _menhir_cell1_exprs_seq = 
  | MenhirCell1_exprs_seq of 's * ('s, 'r) _menhir_state * (Ast.expr list)

and ('s, 'r) _menhir_cell1_node_stream = 
  | MenhirCell1_node_stream of 's * ('s, 'r) _menhir_state * (Ast.expr list)

and ('s, 'r) _menhir_cell1_opt_list = 
  | MenhirCell1_opt_list of 's * ('s, 'r) _menhir_state * (Ast.expr list)

and ('s, 'r) _menhir_cell1_CODE_BLOCK = 
  | MenhirCell1_CODE_BLOCK of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_COMMA = 
  | MenhirCell1_COMMA of 's * ('s, 'r) _menhir_state

and 's _menhir_cell0_LABEL_LITERAL = 
  | MenhirCell0_LABEL_LITERAL of 's * (
# 28 "parser.mly"
       (string)
# 267 "parser.ml"
)

and ('s, 'r) _menhir_cell1_LPAREN = 
  | MenhirCell1_LPAREN of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_NODES_BLOCK = 
  | MenhirCell1_NODES_BLOCK of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_NODE_BLOCK = 
  | MenhirCell1_NODE_BLOCK of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_NOT = 
  | MenhirCell1_NOT of 's * ('s, 'r) _menhir_state

and 's _menhir_cell0_TEXT_LITERAL = 
  | MenhirCell0_TEXT_LITERAL of 's * (
# 29 "parser.mly"
       (string)
# 286 "parser.ml"
)

and ('s, 'r) _menhir_cell1_VARIABLE = 
  | MenhirCell1_VARIABLE of 's * ('s, 'r) _menhir_state * (
# 30 "parser.mly"
       (string)
# 293 "parser.ml"
)

and 's _menhir_cell0_VARIABLE = 
  | MenhirCell0_VARIABLE of 's * (
# 30 "parser.mly"
       (string)
# 300 "parser.ml"
)

and _menhir_box_exprs_rule = 
  | MenhirBox_exprs_rule of (Ast.expr) [@@unboxed]

let _menhir_action_01 =
  fun _2 ->
    (
# 53 "parser.mly"
                                        (
      CodeBlock("CODE_BLOCK", _2, "END_CODE_BLOCK")
    )
# 313 "parser.ml"
     : (Ast.expr))

let _menhir_action_02 =
  fun _2 ->
    (
# 56 "parser.mly"
                                         (
      NodeBlock("NODE_BLOCK", [_2], "END_NODE_BLOCK")
    )
# 323 "parser.ml"
     : (Ast.expr))

let _menhir_action_03 =
  fun _2 ->
    (
# 59 "parser.mly"
                                            (
      NodeStream("NODES_BLOCK", _2, "END_NODES_BLOCK")
    )
# 333 "parser.ml"
     : (Ast.expr))

let _menhir_action_04 =
  fun _1 ->
    (
# 50 "parser.mly"
                       ( [_1] )
# 341 "parser.ml"
     : (Ast.expr list))

let _menhir_action_05 =
  fun _1 _2 ->
    (
# 51 "parser.mly"
                       ( _1 @ [_2] )
# 349 "parser.ml"
     : (Ast.expr list))

let _menhir_action_06 =
  fun _1 ->
    (
# 144 "parser.mly"
             ( IntLit _1 )
# 357 "parser.ml"
     : (Ast.expr))

let _menhir_action_07 =
  fun _1 ->
    (
# 145 "parser.mly"
                ( BoolLit _1 )
# 365 "parser.ml"
     : (Ast.expr))

let _menhir_action_08 =
  fun _1 ->
    (
# 146 "parser.mly"
                ( TextLit _1 )
# 373 "parser.ml"
     : (Ast.expr))

let _menhir_action_09 =
  fun _1 ->
    (
# 147 "parser.mly"
                 ( LabelLit _1 )
# 381 "parser.ml"
     : (Ast.expr))

let _menhir_action_10 =
  fun _1 ->
    (
# 148 "parser.mly"
                 ( FloatLit _1 )
# 389 "parser.ml"
     : (Ast.expr))

let _menhir_action_11 =
  fun _1 ->
    (
# 149 "parser.mly"
            ( Var _1 )
# 397 "parser.ml"
     : (Ast.expr))

let _menhir_action_12 =
  fun _2 ->
    (
# 150 "parser.mly"
                           ( _2 )
# 405 "parser.ml"
     : (Ast.expr))

let _menhir_action_13 =
  fun _1 _3 ->
    (
# 151 "parser.mly"
                            ( Binop (_1, Add, _3) )
# 413 "parser.ml"
     : (Ast.expr))

let _menhir_action_14 =
  fun _1 _3 ->
    (
# 152 "parser.mly"
                             ( Binop (_1, Sub, _3) )
# 421 "parser.ml"
     : (Ast.expr))

let _menhir_action_15 =
  fun _1 _3 ->
    (
# 153 "parser.mly"
                             ( Binop (_1, Mul, _3) )
# 429 "parser.ml"
     : (Ast.expr))

let _menhir_action_16 =
  fun _1 _3 ->
    (
# 154 "parser.mly"
                              ( Binop (_1, Div, _3) )
# 437 "parser.ml"
     : (Ast.expr))

let _menhir_action_17 =
  fun _1 _3 ->
    (
# 155 "parser.mly"
                          ( Binop (_1, Gt, _3) )
# 445 "parser.ml"
     : (Ast.expr))

let _menhir_action_18 =
  fun _1 _3 ->
    (
# 156 "parser.mly"
                          ( Binop (_1, Lt, _3) )
# 453 "parser.ml"
     : (Ast.expr))

let _menhir_action_19 =
  fun _1 _3 ->
    (
# 157 "parser.mly"
                           ( Binop (_1, Leq, _3) )
# 461 "parser.ml"
     : (Ast.expr))

let _menhir_action_20 =
  fun _1 _3 ->
    (
# 158 "parser.mly"
                           ( Binop (_1, Geq, _3) )
# 469 "parser.ml"
     : (Ast.expr))

let _menhir_action_21 =
  fun _1 _3 ->
    (
# 159 "parser.mly"
                          ( Binop (_1, Eq, _3) )
# 477 "parser.ml"
     : (Ast.expr))

let _menhir_action_22 =
  fun _1 ->
    (
# 160 "parser.mly"
                      ( Unop (_1, Incr) )
# 485 "parser.ml"
     : (Ast.expr))

let _menhir_action_23 =
  fun _1 ->
    (
# 161 "parser.mly"
                        ( Unop (_1, Decr) )
# 493 "parser.ml"
     : (Ast.expr))

let _menhir_action_24 =
  fun _2 ->
    (
# 162 "parser.mly"
                 ( Unop (_2, Not) )
# 501 "parser.ml"
     : (Ast.expr))

let _menhir_action_25 =
  fun _1 _3 ->
    (
# 163 "parser.mly"
                         ( Asn (_1, _3) )
# 509 "parser.ml"
     : (Ast.expr))

let _menhir_action_26 =
  fun _1 _7 ->
    (
# 165 "parser.mly"
                                                         ( AddItem (_1, _7) )
# 517 "parser.ml"
     : (Ast.expr))

let _menhir_action_27 =
  fun _12 _6 _9 ->
    (
# 167 "parser.mly"
                                                                                                                 (
    Nar {
      title = _6;
      root = _9;
      narr_label = _12;
    }
  )
# 531 "parser.ml"
     : (Ast.expr))

let _menhir_action_28 =
  fun _11 _6 _9 ->
    (
# 174 "parser.mly"
                                                                                                      (
    Nar {
      title = _6;
      root = _9;
      narr_label = _11;
    }
  )
# 545 "parser.ml"
     : (Ast.expr))

let _menhir_action_29 =
  fun _11 _6 _8 ->
    (
# 181 "parser.mly"
                                                                                                            (
    Nar {
      title = _6;
      root = _8;
      narr_label = _11;
    }
  )
# 559 "parser.ml"
     : (Ast.expr))

let _menhir_action_30 =
  fun _10 _6 _8 ->
    (
# 188 "parser.mly"
                                                                                                 (
    Nar {
      title = _6;
      root = _8;
      narr_label = _10;
    }
  )
# 573 "parser.ml"
     : (Ast.expr))

let _menhir_action_31 =
  fun _11 _5 _8 ->
    (
# 195 "parser.mly"
                                                                                                           (
    Nar {
      title = _5;
      root = _8;
      narr_label = _11;
    }
  )
# 587 "parser.ml"
     : (Ast.expr))

let _menhir_action_32 =
  fun _10 _5 _8 ->
    (
# 202 "parser.mly"
                                                                                                (
    Nar {
      title = _5;
      root = _8;
      narr_label = _10;
    }
  )
# 601 "parser.ml"
     : (Ast.expr))

let _menhir_action_33 =
  fun _10 _5 _7 ->
    (
# 209 "parser.mly"
                                                                                                      (
    Nar {
      title = _5;
      root = _7;
      narr_label = _10;
    }
  )
# 615 "parser.ml"
     : (Ast.expr))

let _menhir_action_34 =
  fun _5 _7 _9 ->
    (
# 216 "parser.mly"
                                                                                           (
    Nar {
      title = _5;
      root = _7;
      narr_label = _9;
    }
  )
# 629 "parser.ml"
     : (Ast.expr))

let _menhir_action_35 =
  fun _1 _11 _13 _15 _17 _5 _7 _9 ->
    (
# 226 "parser.mly"
                                                                             (
    Itm {
      var_name = _1;
      iname = _5;
      usage = _7;
      num = _9;
      unique = _11;
      dur = _13;
      cost = _15;
      cons = _17;
    }
  )
# 648 "parser.ml"
     : (Ast.expr))

let _menhir_action_36 =
  fun _1 _5 _7 _9 ->
    (
# 240 "parser.mly"
                                                                                       (
    Chrc {
      var_name = _1;
      name = _5;
      level = _7;
      hp = _9;
      inventory = [];
    }
  )
# 664 "parser.ml"
     : (Ast.expr))

let _menhir_action_37 =
  fun _1 ->
    (
# 249 "parser.mly"
                 ( _1 )
# 672 "parser.ml"
     : (Ast.expr))

let _menhir_action_38 =
  fun _1 ->
    (
# 47 "parser.mly"
           ( Seq _1 )
# 680 "parser.ml"
     : (Ast.expr))

let _menhir_action_39 =
  fun _1 ->
    (
# 65 "parser.mly"
             ( [_1] )
# 688 "parser.ml"
     : (Ast.expr list))

let _menhir_action_40 =
  fun _1 _2 ->
    (
# 66 "parser.mly"
                       ( _1 @ [_2] )
# 696 "parser.ml"
     : (Ast.expr list))

let _menhir_action_41 =
  fun _1 _3 _4 ->
    (
# 74 "parser.mly"
                                       (
    let options = List.map (function
      | Tup (TextLit text, LabelLit label) -> (text, label)
      | _ -> failwith "Expected (Text, Label) in opt_list"
    ) _4 in
    let id = !node_counter in
    node_counter := id + 1;
    Nde {
      character = _1;
      id = id;
      dialogue = _3;
      label = "";
      options = options;
      next = id + 1;
    }
  )
# 719 "parser.ml"
     : (Ast.expr))

let _menhir_action_42 =
  fun _1 _3 ->
    (
# 90 "parser.mly"
                              (
    let id = !node_counter in
    node_counter := id + 1;
    Nde {
      character = _1;
      id = id;
      dialogue = _3;
      label = "";
      options = [];
      next = id + 1;
    }
  )
# 738 "parser.ml"
     : (Ast.expr))

let _menhir_action_43 =
  fun _1 _3 _6 ->
    (
# 102 "parser.mly"
                                                        (
    let id = !node_counter in
    node_counter := id + 1;
    Nde {
      character = _1;
      id = id;
      dialogue = _3;
      label = _6;
      options = [];
      next = id + 1;
    }
  )
# 757 "parser.ml"
     : (Ast.expr))

let _menhir_action_44 =
  fun _1 _3 _6 _7 ->
    (
# 115 "parser.mly"
                                                                 (
    let options = List.map (function
      | Tup (TextLit text, LabelLit label) -> (text, label)
      | _ -> failwith "Expected (Text, Label) in opt_list"
    ) _7 in
    let id = !node_counter in
    node_counter := id + 1;
    Nde {
      character = _1;
      id = id;
      dialogue = _3;
      label = _6;
      options = options;
      next = id + 1;
    }
  )
# 780 "parser.ml"
     : (Ast.expr))

let _menhir_action_45 =
  fun _1 _3 _4 ->
    (
# 253 "parser.mly"
                                       (
    let options = List.map (function
      | Tup (TextLit text_lit, LabelLit label_lit) -> (text_lit, label_lit)
      | _ -> failwith "Expected (Text, Label) in opt_list"
    ) _4 in
    let id = !node_counter in
    node_counter := id + 1;
    let node = {
      character = _1;
      id = id;
      dialogue = _3;
      label = "";
      options = options;
      next = id + 1;
    } in
    Nde node
  )
# 804 "parser.ml"
     : (Ast.expr))

let _menhir_action_46 =
  fun _1 _3 ->
    (
# 271 "parser.mly"
                              (
    let id = !node_counter in
    node_counter := id + 1;
    let node = {
      character = _1;
      id = id;
      dialogue = _3;
      label = "";
      options = [];
      next = id + 1;
    } in
    Nde node
  )
# 824 "parser.ml"
     : (Ast.expr))

let _menhir_action_47 =
  fun _1 _3 _6 _7 ->
    (
# 285 "parser.mly"
                                                                 (
    let options = List.map (function
      | Tup (TextLit text_lit, LabelLit label_lit) -> (text_lit, label_lit)
      | _ -> failwith "Expected (Text, Label) in opt_list"
    ) _7 in
    let id = !node_counter in
    node_counter := id + 1;
    Nde {
      character = _1;
      id = id;
      dialogue = _3;
      label = _6;
      options = options;
      next = id + 1
    }
  )
# 847 "parser.ml"
     : (Ast.expr))

let _menhir_action_48 =
  fun _1 ->
    (
# 70 "parser.mly"
               ( [_1] )
# 855 "parser.ml"
     : (Ast.expr list))

let _menhir_action_49 =
  fun _1 _2 ->
    (
# 71 "parser.mly"
                           ( _1 @ [_2] )
# 863 "parser.ml"
     : (Ast.expr list))

let _menhir_action_50 =
  fun _1 ->
    (
# 135 "parser.mly"
                                                    ( [_1] )
# 871 "parser.ml"
     : (Ast.expr list))

let _menhir_action_51 =
  fun _1 _2 ->
    (
# 136 "parser.mly"
                                                    ( _2 :: _1 )
# 879 "parser.ml"
     : (Ast.expr list))

let _menhir_action_52 =
  fun _2 _5 ->
    (
# 139 "parser.mly"
                                               ( Tup (TextLit _2, LabelLit _5) )
# 887 "parser.ml"
     : (Ast.expr))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | ADD ->
        "ADD"
    | AND ->
        "AND"
    | AT ->
        "AT"
    | BOOL_LITERAL _ ->
        "BOOL_LITERAL"
    | CHARACTER ->
        "CHARACTER"
    | CODE_BLOCK ->
        "CODE_BLOCK"
    | COLON ->
        "COLON"
    | COMMA ->
        "COMMA"
    | DIVEQ ->
        "DIVEQ"
    | DIVIDE ->
        "DIVIDE"
    | DOT ->
        "DOT"
    | ELIF ->
        "ELIF"
    | ELSE ->
        "ELSE"
    | END_CODE_BLOCK ->
        "END_CODE_BLOCK"
    | END_NODES_BLOCK ->
        "END_NODES_BLOCK"
    | END_NODE_BLOCK ->
        "END_NODE_BLOCK"
    | EOF ->
        "EOF"
    | EOL ->
        "EOL"
    | EQ ->
        "EQ"
    | EXCLMPT ->
        "EXCLMPT"
    | FALSE ->
        "FALSE"
    | FLOAT_LITERAL _ ->
        "FLOAT_LITERAL"
    | GT ->
        "GT"
    | GTE ->
        "GTE"
    | HP ->
        "HP"
    | IF ->
        "IF"
    | INT_LITERAL _ ->
        "INT_LITERAL"
    | INVENTORY ->
        "INVENTORY"
    | IS ->
        "IS"
    | ITEM ->
        "ITEM"
    | LABEL ->
        "LABEL"
    | LABEL_LITERAL _ ->
        "LABEL_LITERAL"
    | LBRACKET ->
        "LBRACKET"
    | LEVEL ->
        "LEVEL"
    | LPAREN ->
        "LPAREN"
    | LT ->
        "LT"
    | LTE ->
        "LTE"
    | MINUS ->
        "MINUS"
    | MINUSEQ ->
        "MINUSEQ"
    | MINUSMINUS ->
        "MINUSMINUS"
    | MULTEQ ->
        "MULTEQ"
    | NARRATIVE ->
        "NARRATIVE"
    | NARR_LABEL ->
        "NARR_LABEL"
    | NEXT ->
        "NEXT"
    | NODES_BLOCK ->
        "NODES_BLOCK"
    | NODE_BLOCK ->
        "NODE_BLOCK"
    | NOT ->
        "NOT"
    | OPTION ->
        "OPTION"
    | OR ->
        "OR"
    | PLUS ->
        "PLUS"
    | PLUSEQ ->
        "PLUSEQ"
    | PLUSPLUS ->
        "PLUSPLUS"
    | QUESTMARK ->
        "QUESTMARK"
    | RBRACKET ->
        "RBRACKET"
    | REMOVE ->
        "REMOVE"
    | RETURN ->
        "RETURN"
    | ROOT ->
        "ROOT"
    | RPAREN ->
        "RPAREN"
    | TEXT_LITERAL _ ->
        "TEXT_LITERAL"
    | TIMES ->
        "TIMES"
    | TITLE ->
        "TITLE"
    | TRUE ->
        "TRUE"
    | VARIABLE _ ->
        "VARIABLE"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let rec _menhir_run_001 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_NODE_BLOCK (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | COLON ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | TEXT_LITERAL _v_0 ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | COMMA ->
                      let _menhir_stack = MenhirCell0_VARIABLE (_menhir_stack, _v) in
                      let _menhir_stack = MenhirCell0_TEXT_LITERAL (_menhir_stack, _v_0) in
                      let _menhir_stack = MenhirCell1_COMMA (_menhir_stack, MenhirState004) in
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | LABEL ->
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | LABEL_LITERAL _v ->
                              let _menhir_stack = MenhirCell0_LABEL_LITERAL (_menhir_stack, _v) in
                              let _menhir_s = MenhirState007 in
                              let _tok = _menhir_lexer _menhir_lexbuf in
                              (match (_tok : MenhirBasics.token) with
                              | AT ->
                                  _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
                              | _ ->
                                  _eRR ())
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | AT ->
                      let _menhir_stack = MenhirCell0_VARIABLE (_menhir_stack, _v) in
                      let _menhir_stack = MenhirCell0_TEXT_LITERAL (_menhir_stack, _v_0) in
                      _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState004
                  | END_NODE_BLOCK ->
                      let (_1, _3) = (_v, _v_0) in
                      let _v = _menhir_action_46 _1 _3 in
                      _menhir_goto_node_rules _menhir_stack _menhir_lexbuf _menhir_lexer _v
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_008 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TEXT_LITERAL _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | COMMA ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | NEXT ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | LABEL_LITERAL _v_0 ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      let (_2, _5) = (_v, _v_0) in
                      let _v = _menhir_action_52 _2 _5 in
                      _menhir_goto_option_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_option_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState027 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState026 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState016 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState014 ->
          _menhir_run_015 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState022 ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState025 ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState004 ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState007 ->
          _menhir_run_013 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_015 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_opt_list -> _ -> _ -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_opt_list (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _2 = _v in
      let _v = _menhir_action_51 _1 _2 in
      _menhir_goto_opt_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_opt_list : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState022 ->
          _menhir_run_027 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState025 ->
          _menhir_run_026 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState004 ->
          _menhir_run_016 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState007 ->
          _menhir_run_014 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_027 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_VARIABLE _menhir_cell0_TEXT_LITERAL as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | AT ->
          let _menhir_stack = MenhirCell1_opt_list (_menhir_stack, _menhir_s, _v) in
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState027
      | END_NODES_BLOCK | VARIABLE _ ->
          let MenhirCell0_TEXT_LITERAL (_menhir_stack, _3) = _menhir_stack in
          let MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _4 = _v in
          let _v = _menhir_action_41 _1 _3 _4 in
          _menhir_goto_node_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_node_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState019 ->
          _menhir_run_031 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState028 ->
          _menhir_run_030 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_031 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_NODES_BLOCK as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _1 = _v in
      let _v = _menhir_action_48 _1 in
      _menhir_goto_node_stream _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_node_stream : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_NODES_BLOCK as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v_0 ->
          let _menhir_stack = MenhirCell1_node_stream (_menhir_stack, _menhir_s, _v) in
          _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState028
      | END_NODES_BLOCK ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_NODES_BLOCK (_menhir_stack, _menhir_s) = _menhir_stack in
          let _2 = _v in
          let _v = _menhir_action_03 _2 in
          _menhir_goto_block _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_020 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | COLON ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | TEXT_LITERAL _v_0 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | COMMA ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | LABEL ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | LABEL_LITERAL _v_1 ->
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | AT ->
                              let _menhir_stack = MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _v) in
                              let _menhir_stack = MenhirCell0_TEXT_LITERAL (_menhir_stack, _v_0) in
                              let _menhir_stack = MenhirCell1_COMMA (_menhir_stack, MenhirState022) in
                              let _menhir_stack = MenhirCell0_LABEL_LITERAL (_menhir_stack, _v_1) in
                              _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState025
                          | END_NODES_BLOCK | VARIABLE _ ->
                              let (_1, _3, _6) = (_v, _v_0, _v_1) in
                              let _v = _menhir_action_43 _1 _3 _6 in
                              _menhir_goto_node_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | AT ->
                  let _menhir_stack = MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _v) in
                  let _menhir_stack = MenhirCell0_TEXT_LITERAL (_menhir_stack, _v_0) in
                  _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState022
              | END_NODES_BLOCK | VARIABLE _ ->
                  let (_1, _3) = (_v, _v_0) in
                  let _v = _menhir_action_42 _1 _3 in
                  _menhir_goto_node_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_goto_block : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState000 ->
          _menhir_run_142 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState140 ->
          _menhir_run_141 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_142 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _1 = _v in
      let _v = _menhir_action_04 _1 in
      _menhir_goto_blocks _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_blocks : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_blocks (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | NODE_BLOCK ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState140
      | NODES_BLOCK ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState140
      | CODE_BLOCK ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState140
      | _ ->
          _eRR ()
  
  and _menhir_run_019 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_NODES_BLOCK (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState019 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_020 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_032 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_CODE_BLOCK (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState032 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | TEXT_LITERAL _v ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL_LITERAL _v ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INT_LITERAL _v ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT_LITERAL _v ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL_LITERAL _v ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_033 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | EQ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | VARIABLE _v_0 ->
              let _menhir_stack = MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _v) in
              _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState034
          | TEXT_LITERAL _v_1 ->
              let _menhir_stack = MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _v) in
              _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState034
          | NOT ->
              let _menhir_stack = MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _v) in
              _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState034
          | NARRATIVE ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | LPAREN ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | TITLE ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | TEXT_LITERAL _v_2 ->
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | COMMA ->
                              let _tok = _menhir_lexer _menhir_lexbuf in
                              (match (_tok : MenhirBasics.token) with
                              | ROOT ->
                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                  (match (_tok : MenhirBasics.token) with
                                  | LABEL_LITERAL _v_3 ->
                                      let _tok = _menhir_lexer _menhir_lexbuf in
                                      (match (_tok : MenhirBasics.token) with
                                      | COMMA ->
                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                          (match (_tok : MenhirBasics.token) with
                                          | NARR_LABEL ->
                                              let _tok = _menhir_lexer _menhir_lexbuf in
                                              (match (_tok : MenhirBasics.token) with
                                              | LABEL_LITERAL _v_4 ->
                                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                                  (match (_tok : MenhirBasics.token) with
                                                  | RPAREN ->
                                                      let _tok = _menhir_lexer _menhir_lexbuf in
                                                      let (_6, _9, _12) = (_v_2, _v_3, _v_4) in
                                                      let _v = _menhir_action_27 _12 _6 _9 in
                                                      _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                                                  | _ ->
                                                      _eRR ())
                                              | _ ->
                                                  _eRR ())
                                          | LABEL_LITERAL _v_5 ->
                                              let _tok = _menhir_lexer _menhir_lexbuf in
                                              (match (_tok : MenhirBasics.token) with
                                              | RPAREN ->
                                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                                  let (_6, _9, _11) = (_v_2, _v_3, _v_5) in
                                                  let _v = _menhir_action_28 _11 _6 _9 in
                                                  _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                                              | _ ->
                                                  _eRR ())
                                          | _ ->
                                              _eRR ())
                                      | _ ->
                                          _eRR ())
                                  | _ ->
                                      _eRR ())
                              | LABEL_LITERAL _v_6 ->
                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                  (match (_tok : MenhirBasics.token) with
                                  | COMMA ->
                                      let _tok = _menhir_lexer _menhir_lexbuf in
                                      (match (_tok : MenhirBasics.token) with
                                      | NARR_LABEL ->
                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                          (match (_tok : MenhirBasics.token) with
                                          | LABEL_LITERAL _v_7 ->
                                              let _tok = _menhir_lexer _menhir_lexbuf in
                                              (match (_tok : MenhirBasics.token) with
                                              | RPAREN ->
                                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                                  let (_6, _8, _11) = (_v_2, _v_6, _v_7) in
                                                  let _v = _menhir_action_29 _11 _6 _8 in
                                                  _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                                              | _ ->
                                                  _eRR ())
                                          | _ ->
                                              _eRR ())
                                      | LABEL_LITERAL _v_8 ->
                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                          (match (_tok : MenhirBasics.token) with
                                          | RPAREN ->
                                              let _tok = _menhir_lexer _menhir_lexbuf in
                                              let (_6, _8, _10) = (_v_2, _v_6, _v_8) in
                                              let _v = _menhir_action_30 _10 _6 _8 in
                                              _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                                          | _ ->
                                              _eRR ())
                                      | _ ->
                                          _eRR ())
                                  | _ ->
                                      _eRR ())
                              | _ ->
                                  _eRR ())
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | TEXT_LITERAL _v_9 ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | COMMA ->
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | ROOT ->
                              let _tok = _menhir_lexer _menhir_lexbuf in
                              (match (_tok : MenhirBasics.token) with
                              | LABEL_LITERAL _v_10 ->
                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                  (match (_tok : MenhirBasics.token) with
                                  | COMMA ->
                                      let _tok = _menhir_lexer _menhir_lexbuf in
                                      (match (_tok : MenhirBasics.token) with
                                      | NARR_LABEL ->
                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                          (match (_tok : MenhirBasics.token) with
                                          | LABEL_LITERAL _v_11 ->
                                              let _tok = _menhir_lexer _menhir_lexbuf in
                                              (match (_tok : MenhirBasics.token) with
                                              | RPAREN ->
                                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                                  let (_5, _8, _11) = (_v_9, _v_10, _v_11) in
                                                  let _v = _menhir_action_31 _11 _5 _8 in
                                                  _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                                              | _ ->
                                                  _eRR ())
                                          | _ ->
                                              _eRR ())
                                      | LABEL_LITERAL _v_12 ->
                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                          (match (_tok : MenhirBasics.token) with
                                          | RPAREN ->
                                              let _tok = _menhir_lexer _menhir_lexbuf in
                                              let (_5, _8, _10) = (_v_9, _v_10, _v_12) in
                                              let _v = _menhir_action_32 _10 _5 _8 in
                                              _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                                          | _ ->
                                              _eRR ())
                                      | _ ->
                                          _eRR ())
                                  | _ ->
                                      _eRR ())
                              | _ ->
                                  _eRR ())
                          | LABEL_LITERAL _v_13 ->
                              let _tok = _menhir_lexer _menhir_lexbuf in
                              (match (_tok : MenhirBasics.token) with
                              | COMMA ->
                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                  (match (_tok : MenhirBasics.token) with
                                  | NARR_LABEL ->
                                      let _tok = _menhir_lexer _menhir_lexbuf in
                                      (match (_tok : MenhirBasics.token) with
                                      | LABEL_LITERAL _v_14 ->
                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                          (match (_tok : MenhirBasics.token) with
                                          | RPAREN ->
                                              let _tok = _menhir_lexer _menhir_lexbuf in
                                              let (_5, _7, _10) = (_v_9, _v_13, _v_14) in
                                              let _v = _menhir_action_33 _10 _5 _7 in
                                              _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                                          | _ ->
                                              _eRR ())
                                      | _ ->
                                          _eRR ())
                                  | LABEL_LITERAL _v_15 ->
                                      let _tok = _menhir_lexer _menhir_lexbuf in
                                      (match (_tok : MenhirBasics.token) with
                                      | RPAREN ->
                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                          let (_5, _7, _9) = (_v_9, _v_13, _v_15) in
                                          let _v = _menhir_action_34 _5 _7 _9 in
                                          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                                      | _ ->
                                          _eRR ())
                                  | _ ->
                                      _eRR ())
                              | _ ->
                                  _eRR ())
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | LPAREN ->
              let _menhir_stack = MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _v) in
              _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState034
          | LABEL_LITERAL _v_16 ->
              let _menhir_stack = MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _v) in
              _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v_16 MenhirState034
          | ITEM ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | LPAREN ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | TEXT_LITERAL _v_17 ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | COMMA ->
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | TEXT_LITERAL _v_18 ->
                              let _tok = _menhir_lexer _menhir_lexbuf in
                              (match (_tok : MenhirBasics.token) with
                              | COMMA ->
                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                  (match (_tok : MenhirBasics.token) with
                                  | INT_LITERAL _v_19 ->
                                      let _tok = _menhir_lexer _menhir_lexbuf in
                                      (match (_tok : MenhirBasics.token) with
                                      | COMMA ->
                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                          (match (_tok : MenhirBasics.token) with
                                          | BOOL_LITERAL _v_20 ->
                                              let _tok = _menhir_lexer _menhir_lexbuf in
                                              (match (_tok : MenhirBasics.token) with
                                              | COMMA ->
                                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                                  (match (_tok : MenhirBasics.token) with
                                                  | INT_LITERAL _v_21 ->
                                                      let _tok = _menhir_lexer _menhir_lexbuf in
                                                      (match (_tok : MenhirBasics.token) with
                                                      | COMMA ->
                                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                                          (match (_tok : MenhirBasics.token) with
                                                          | INT_LITERAL _v_22 ->
                                                              let _tok = _menhir_lexer _menhir_lexbuf in
                                                              (match (_tok : MenhirBasics.token) with
                                                              | COMMA ->
                                                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                                                  (match (_tok : MenhirBasics.token) with
                                                                  | BOOL_LITERAL _v_23 ->
                                                                      let _tok = _menhir_lexer _menhir_lexbuf in
                                                                      (match (_tok : MenhirBasics.token) with
                                                                      | RPAREN ->
                                                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                                                          let (_1, _5, _7, _9, _11, _13, _17, _15) = (_v, _v_17, _v_18, _v_19, _v_20, _v_21, _v_23, _v_22) in
                                                                          let _v = _menhir_action_35 _1 _11 _13 _15 _17 _5 _7 _9 in
                                                                          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                                                                      | _ ->
                                                                          _eRR ())
                                                                  | _ ->
                                                                      _eRR ())
                                                              | _ ->
                                                                  _eRR ())
                                                          | _ ->
                                                              _eRR ())
                                                      | _ ->
                                                          _eRR ())
                                                  | _ ->
                                                      _eRR ())
                                              | _ ->
                                                  _eRR ())
                                          | _ ->
                                              _eRR ())
                                      | _ ->
                                          _eRR ())
                                  | _ ->
                                      _eRR ())
                              | _ ->
                                  _eRR ())
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | INT_LITERAL _v_24 ->
              let _menhir_stack = MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _v) in
              _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v_24 MenhirState034
          | FLOAT_LITERAL _v_25 ->
              let _menhir_stack = MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _v) in
              _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v_25 MenhirState034
          | CHARACTER ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | LPAREN ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | TEXT_LITERAL _v_26 ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | COMMA ->
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | INT_LITERAL _v_27 ->
                              let _tok = _menhir_lexer _menhir_lexbuf in
                              (match (_tok : MenhirBasics.token) with
                              | COMMA ->
                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                  (match (_tok : MenhirBasics.token) with
                                  | INT_LITERAL _v_28 ->
                                      let _tok = _menhir_lexer _menhir_lexbuf in
                                      (match (_tok : MenhirBasics.token) with
                                      | RPAREN ->
                                          let _tok = _menhir_lexer _menhir_lexbuf in
                                          let (_1, _5, _7, _9) = (_v, _v_26, _v_27, _v_28) in
                                          let _v = _menhir_action_36 _1 _5 _7 _9 in
                                          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                                      | _ ->
                                          _eRR ())
                                  | _ ->
                                      _eRR ())
                              | _ ->
                                  _eRR ())
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | BOOL_LITERAL _v_29 ->
              let _menhir_stack = MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _v) in
              _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v_29 MenhirState034
          | _ ->
              _eRR ())
      | DOT ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | INVENTORY ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | DOT ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | ADD ->
                      let _tok = _menhir_lexer _menhir_lexbuf in
                      (match (_tok : MenhirBasics.token) with
                      | LPAREN ->
                          let _tok = _menhir_lexer _menhir_lexbuf in
                          (match (_tok : MenhirBasics.token) with
                          | VARIABLE _v_30 ->
                              let _tok = _menhir_lexer _menhir_lexbuf in
                              (match (_tok : MenhirBasics.token) with
                              | RPAREN ->
                                  let _tok = _menhir_lexer _menhir_lexbuf in
                                  let (_1, _7) = (_v, _v_30) in
                                  let _v = _menhir_action_26 _1 _7 in
                                  _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
                              | _ ->
                                  _eRR ())
                          | _ ->
                              _eRR ())
                      | _ ->
                          _eRR ())
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | BOOL_LITERAL _ | DIVIDE | END_CODE_BLOCK | EOL | FLOAT_LITERAL _ | GT | GTE | INT_LITERAL _ | IS | LABEL_LITERAL _ | LPAREN | LT | LTE | MINUS | MINUSMINUS | NOT | PLUS | PLUSPLUS | RPAREN | TEXT_LITERAL _ | TIMES | VARIABLE _ ->
          let _1 = _v in
          let _v = _menhir_action_11 _1 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_035 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = _v in
      let _v = _menhir_action_08 _1 in
      _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_expr_rule : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState032 ->
          _menhir_run_138 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState135 ->
          _menhir_run_137 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState034 ->
          _menhir_run_127 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState036 ->
          _menhir_run_065 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState062 ->
          _menhir_run_063 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState060 ->
          _menhir_run_061 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState058 ->
          _menhir_run_059 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState056 ->
          _menhir_run_057 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState054 ->
          _menhir_run_055 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState052 ->
          _menhir_run_053 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState050 ->
          _menhir_run_051 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState048 ->
          _menhir_run_049 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState043 ->
          _menhir_run_044 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState037 ->
          _menhir_run_042 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_138 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_CODE_BLOCK as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LTE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LT ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer
      | IS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GTE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GT ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EOL ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIVIDE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | END_CODE_BLOCK | FLOAT_LITERAL _ | INT_LITERAL _ | LABEL_LITERAL _ | LPAREN | NOT | TEXT_LITERAL _ | VARIABLE _ ->
          let _1 = _v in
          let _v = _menhir_action_39 _1 in
          _menhir_goto_exprs_seq _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_043 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState043 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | TEXT_LITERAL _v ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL_LITERAL _v ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INT_LITERAL _v ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT_LITERAL _v ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL_LITERAL _v ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_036 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_NOT (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState036 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | TEXT_LITERAL _v ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL_LITERAL _v ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INT_LITERAL _v ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT_LITERAL _v ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL_LITERAL _v ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_037 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LPAREN (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState037 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | TEXT_LITERAL _v ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL_LITERAL _v ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INT_LITERAL _v ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT_LITERAL _v ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL_LITERAL _v ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_038 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = _v in
      let _v = _menhir_action_09 _1 in
      _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_039 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = _v in
      let _v = _menhir_action_06 _1 in
      _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_040 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = _v in
      let _v = _menhir_action_10 _1 in
      _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_041 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let _1 = _v in
      let _v = _menhir_action_07 _1 in
      _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_045 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _v = _menhir_action_22 _1 in
      _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_048 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState048 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | TEXT_LITERAL _v ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL_LITERAL _v ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INT_LITERAL _v ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT_LITERAL _v ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL_LITERAL _v ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_046 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _v = _menhir_action_23 _1 in
      _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_052 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState052 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | TEXT_LITERAL _v ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL_LITERAL _v ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INT_LITERAL _v ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT_LITERAL _v ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL_LITERAL _v ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_054 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState054 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | TEXT_LITERAL _v ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL_LITERAL _v ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INT_LITERAL _v ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT_LITERAL _v ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL_LITERAL _v ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_056 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState056 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | TEXT_LITERAL _v ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL_LITERAL _v ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INT_LITERAL _v ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT_LITERAL _v ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL_LITERAL _v ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_058 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState058 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | TEXT_LITERAL _v ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL_LITERAL _v ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INT_LITERAL _v ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT_LITERAL _v ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL_LITERAL _v ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_060 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState060 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | TEXT_LITERAL _v ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL_LITERAL _v ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INT_LITERAL _v ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT_LITERAL _v ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL_LITERAL _v ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_062 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState062 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | TEXT_LITERAL _v ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL_LITERAL _v ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INT_LITERAL _v ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT_LITERAL _v ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL_LITERAL _v ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_064 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _v = _menhir_action_37 _1 in
      _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_050 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState050 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v ->
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | TEXT_LITERAL _v ->
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | NOT ->
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LPAREN ->
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | LABEL_LITERAL _v ->
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | INT_LITERAL _v ->
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | FLOAT_LITERAL _v ->
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | BOOL_LITERAL _v ->
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_exprs_seq : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_CODE_BLOCK as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | VARIABLE _v_0 ->
          let _menhir_stack = MenhirCell1_exprs_seq (_menhir_stack, _menhir_s, _v) in
          _menhir_run_033 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState135
      | TEXT_LITERAL _v_1 ->
          let _menhir_stack = MenhirCell1_exprs_seq (_menhir_stack, _menhir_s, _v) in
          _menhir_run_035 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState135
      | NOT ->
          let _menhir_stack = MenhirCell1_exprs_seq (_menhir_stack, _menhir_s, _v) in
          _menhir_run_036 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState135
      | LPAREN ->
          let _menhir_stack = MenhirCell1_exprs_seq (_menhir_stack, _menhir_s, _v) in
          _menhir_run_037 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState135
      | LABEL_LITERAL _v_2 ->
          let _menhir_stack = MenhirCell1_exprs_seq (_menhir_stack, _menhir_s, _v) in
          _menhir_run_038 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState135
      | INT_LITERAL _v_3 ->
          let _menhir_stack = MenhirCell1_exprs_seq (_menhir_stack, _menhir_s, _v) in
          _menhir_run_039 _menhir_stack _menhir_lexbuf _menhir_lexer _v_3 MenhirState135
      | FLOAT_LITERAL _v_4 ->
          let _menhir_stack = MenhirCell1_exprs_seq (_menhir_stack, _menhir_s, _v) in
          _menhir_run_040 _menhir_stack _menhir_lexbuf _menhir_lexer _v_4 MenhirState135
      | END_CODE_BLOCK ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_CODE_BLOCK (_menhir_stack, _menhir_s) = _menhir_stack in
          let _2 = _v in
          let _v = _menhir_action_01 _2 in
          _menhir_goto_block _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | BOOL_LITERAL _v_5 ->
          let _menhir_stack = MenhirCell1_exprs_seq (_menhir_stack, _menhir_s, _v) in
          _menhir_run_041 _menhir_stack _menhir_lexbuf _menhir_lexer _v_5 MenhirState135
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_137 : type  ttv_stack. (((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_CODE_BLOCK, _menhir_box_exprs_rule) _menhir_cell1_exprs_seq as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LTE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LT ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer
      | IS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GTE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GT ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EOL ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIVIDE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | END_CODE_BLOCK | FLOAT_LITERAL _ | INT_LITERAL _ | LABEL_LITERAL _ | LPAREN | NOT | TEXT_LITERAL _ | VARIABLE _ ->
          let MenhirCell1_exprs_seq (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _2 = _v in
          let _v = _menhir_action_40 _1 _2 in
          _menhir_goto_exprs_seq _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_127 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_VARIABLE as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LTE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LT ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer
      | IS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GTE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GT ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIVIDE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | END_CODE_BLOCK | EOL | FLOAT_LITERAL _ | INT_LITERAL _ | LABEL_LITERAL _ | LPAREN | NOT | RPAREN | TEXT_LITERAL _ | VARIABLE _ ->
          let MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_25 _1 _3 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_065 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_NOT as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIVIDE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | END_CODE_BLOCK | EOL | FLOAT_LITERAL _ | GT | GTE | INT_LITERAL _ | IS | LABEL_LITERAL _ | LPAREN | LT | LTE | NOT | RPAREN | TEXT_LITERAL _ | VARIABLE _ ->
          let MenhirCell1_NOT (_menhir_stack, _menhir_s) = _menhir_stack in
          let _2 = _v in
          let _v = _menhir_action_24 _2 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_063 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIVIDE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | END_CODE_BLOCK | EOL | FLOAT_LITERAL _ | GT | GTE | INT_LITERAL _ | IS | LABEL_LITERAL _ | LPAREN | LT | LTE | NOT | RPAREN | TEXT_LITERAL _ | VARIABLE _ ->
          let MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_17 _1 _3 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_061 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIVIDE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | END_CODE_BLOCK | EOL | FLOAT_LITERAL _ | GT | GTE | INT_LITERAL _ | IS | LABEL_LITERAL _ | LPAREN | LT | LTE | NOT | RPAREN | TEXT_LITERAL _ | VARIABLE _ ->
          let MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_20 _1 _3 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_059 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIVIDE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | END_CODE_BLOCK | EOL | FLOAT_LITERAL _ | GT | GTE | INT_LITERAL _ | IS | LABEL_LITERAL _ | LPAREN | LT | LTE | NOT | RPAREN | TEXT_LITERAL _ | VARIABLE _ ->
          let MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_21 _1 _3 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_057 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIVIDE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | END_CODE_BLOCK | EOL | FLOAT_LITERAL _ | GT | GTE | INT_LITERAL _ | IS | LABEL_LITERAL _ | LPAREN | LT | LTE | NOT | RPAREN | TEXT_LITERAL _ | VARIABLE _ ->
          let MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_18 _1 _3 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_055 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIVIDE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | END_CODE_BLOCK | EOL | FLOAT_LITERAL _ | GT | GTE | INT_LITERAL _ | IS | LABEL_LITERAL _ | LPAREN | LT | LTE | NOT | RPAREN | TEXT_LITERAL _ | VARIABLE _ ->
          let MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_19 _1 _3 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_053 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIVIDE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | END_CODE_BLOCK | EOL | FLOAT_LITERAL _ | GT | GTE | INT_LITERAL _ | IS | LABEL_LITERAL _ | LPAREN | LT | LTE | MINUS | NOT | PLUS | RPAREN | TEXT_LITERAL _ | VARIABLE _ ->
          let MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_14 _1 _3 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_051 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | DIVIDE | END_CODE_BLOCK | EOL | FLOAT_LITERAL _ | GT | GTE | INT_LITERAL _ | IS | LABEL_LITERAL _ | LPAREN | LT | LTE | MINUS | NOT | PLUS | RPAREN | TEXT_LITERAL _ | TIMES | VARIABLE _ ->
          let MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_16 _1 _3 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_049 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIVIDE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | END_CODE_BLOCK | EOL | FLOAT_LITERAL _ | GT | GTE | INT_LITERAL _ | IS | LABEL_LITERAL _ | LPAREN | LT | LTE | MINUS | NOT | PLUS | RPAREN | TEXT_LITERAL _ | VARIABLE _ ->
          let MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_13 _1 _3 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_044 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_expr_rule as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | BOOL_LITERAL _ | DIVIDE | END_CODE_BLOCK | EOL | FLOAT_LITERAL _ | GT | GTE | INT_LITERAL _ | IS | LABEL_LITERAL _ | LPAREN | LT | LTE | MINUS | NOT | PLUS | RPAREN | TEXT_LITERAL _ | TIMES | VARIABLE _ ->
          let MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _3 = _v in
          let _v = _menhir_action_15 _1 _3 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_042 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_LPAREN as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | TIMES ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_043 _menhir_stack _menhir_lexbuf _menhir_lexer
      | RPAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LPAREN (_menhir_stack, _menhir_s) = _menhir_stack in
          let _2 = _v in
          let _v = _menhir_action_12 _2 in
          _menhir_goto_expr_rule _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | PLUSPLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_045 _menhir_stack _menhir_lexbuf _menhir_lexer
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_048 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUSMINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_046 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_052 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LTE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_054 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LT ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_056 _menhir_stack _menhir_lexbuf _menhir_lexer
      | IS ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_058 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GTE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_060 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GT ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_062 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EOL ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_064 _menhir_stack _menhir_lexbuf _menhir_lexer
      | DIVIDE ->
          let _menhir_stack = MenhirCell1_expr_rule (_menhir_stack, _menhir_s, _v) in
          _menhir_run_050 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_141 : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_blocks -> _ -> _ -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_blocks (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _2 = _v in
      let _v = _menhir_action_05 _1 _2 in
      _menhir_goto_blocks _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_030 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_NODES_BLOCK, _menhir_box_exprs_rule) _menhir_cell1_node_stream -> _ -> _ -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_node_stream (_menhir_stack, _menhir_s, _1) = _menhir_stack in
      let _2 = _v in
      let _v = _menhir_action_49 _1 _2 in
      _menhir_goto_node_stream _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_026 : type  ttv_stack. (((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_VARIABLE _menhir_cell0_TEXT_LITERAL, _menhir_box_exprs_rule) _menhir_cell1_COMMA _menhir_cell0_LABEL_LITERAL as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | AT ->
          let _menhir_stack = MenhirCell1_opt_list (_menhir_stack, _menhir_s, _v) in
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState026
      | END_NODES_BLOCK | VARIABLE _ ->
          let MenhirCell0_LABEL_LITERAL (_menhir_stack, _6) = _menhir_stack in
          let MenhirCell1_COMMA (_menhir_stack, _) = _menhir_stack in
          let MenhirCell0_TEXT_LITERAL (_menhir_stack, _3) = _menhir_stack in
          let MenhirCell1_VARIABLE (_menhir_stack, _menhir_s, _1) = _menhir_stack in
          let _7 = _v in
          let _v = _menhir_action_44 _1 _3 _6 _7 in
          _menhir_goto_node_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_016 : type  ttv_stack. ((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_NODE_BLOCK _menhir_cell0_VARIABLE _menhir_cell0_TEXT_LITERAL as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | AT ->
          let _menhir_stack = MenhirCell1_opt_list (_menhir_stack, _menhir_s, _v) in
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState016
      | END_NODE_BLOCK ->
          let MenhirCell0_TEXT_LITERAL (_menhir_stack, _3) = _menhir_stack in
          let MenhirCell0_VARIABLE (_menhir_stack, _1) = _menhir_stack in
          let _4 = _v in
          let _v = _menhir_action_45 _1 _3 _4 in
          _menhir_goto_node_rules _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_goto_node_rules : type  ttv_stack. (ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_NODE_BLOCK -> _ -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_NODE_BLOCK (_menhir_stack, _menhir_s) = _menhir_stack in
      let _2 = _v in
      let _v = _menhir_action_02 _2 in
      _menhir_goto_block _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_014 : type  ttv_stack. (((ttv_stack, _menhir_box_exprs_rule) _menhir_cell1_NODE_BLOCK _menhir_cell0_VARIABLE _menhir_cell0_TEXT_LITERAL, _menhir_box_exprs_rule) _menhir_cell1_COMMA _menhir_cell0_LABEL_LITERAL as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | AT ->
          let _menhir_stack = MenhirCell1_opt_list (_menhir_stack, _menhir_s, _v) in
          _menhir_run_008 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState014
      | END_NODE_BLOCK ->
          let MenhirCell0_LABEL_LITERAL (_menhir_stack, _6) = _menhir_stack in
          let MenhirCell1_COMMA (_menhir_stack, _) = _menhir_stack in
          let MenhirCell0_TEXT_LITERAL (_menhir_stack, _3) = _menhir_stack in
          let MenhirCell0_VARIABLE (_menhir_stack, _1) = _menhir_stack in
          let _7 = _v in
          let _v = _menhir_action_47 _1 _3 _6 _7 in
          _menhir_goto_node_rules _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _eRR ()
  
  and _menhir_run_013 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_exprs_rule) _menhir_state -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _1 = _v in
      let _v = _menhir_action_50 _1 in
      _menhir_goto_opt_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  let _menhir_run_000 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_exprs_rule =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState000 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NODE_BLOCK ->
          _menhir_run_001 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | NODES_BLOCK ->
          _menhir_run_019 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | CODE_BLOCK ->
          _menhir_run_032 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | _ ->
          _eRR ()
  
end

let exprs_rule =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_exprs_rule v = _menhir_run_000 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
