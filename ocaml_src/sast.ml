(* Semantically checked AST for mnemo *)

(* NB - Dallas: 'if' included here at expr and stmt levels
	but not in parser yet; still need elif and else
	both here, ast, and parser *)

open Ast

(* types *)
type typ = 
 | TInt
 | TString
 | TBool
 | TFloat
 | TNode
 | TNar
 | TChar
 | TUnit
 | TItem
 | TList of typ
 | TTup of typ * typ


(* for vars *)
module Symbol = struct
	type t = {
		id: int;
		name: string;
		typ: typ;
	}

	let count = ref 0
	let fresh ~name ~typ =
		let id = !count in
		count := id + 1;
		{ id; name; typ }
end

(* for vars and assignments *)
type symbol = Symbol.t

(* sexprs (sexy expressions)*)
type sexpr = typ * sx
and sx =
    SBinop of sexpr * operator * sexpr
    | SUnop of sexpr * unaryop
    | SIntLit of int
    | STextLit of string
    | SBoolLit of bool
    | SLabelLit of string
    | SFloatLit of float
    | SNode of Ast.node    
    | SVar of symbol
    | SSeq of sexpr list
    | STup of sexpr * sexpr
    | SProcOpt of ((string * string) list) * Ast.node
    | SAsn of symbol * sexpr
    | SNar of string * string * string * string
    | SItm of string * string * string * int * bool * int * int * bool
    | SNde of string * int * string * string * (string * string) list * int
    | SNodeStream of string * sexpr list * string
    | SCodeBlock of string * sexpr list * string
    | SNodeBlock of string * sexpr list * string
    | SChrc of string * string * int * int * item list
    | SAddItem of string * string
    | SIfExpr of sexpr * sexpr list * (sexpr * sexpr list) list * sexpr list option

type sstmt =
  | SIf of sexpr * sstmt * sstmt
  | SExpr of sexpr

type sfunc_def = {
  sfname: string;
  sformals: (typ * string) list;
  slocals: (typ * string) list;
  sbody: sstmt list;
  srtyp: typ;
}


(* Pretty-printing functions *)
let rec string_of_typ = function
    TInt -> "TInt"
    | TBool -> "TBool"
    | TFloat -> "TFloat"
    | TString -> "TString"
    | TNode -> "TNode"
    | TNar -> "TNar"
    | TItem -> "TItem"
    | TChar -> "TChar"
    | TUnit -> "TUnit"
    | TTup (t1, t2) -> "TTup(" ^ string_of_typ t1 ^ ", " ^ string_of_typ t2 ^")"
    | TList (t) -> "TList (" ^ string_of_typ t ^")"

let string_of_symbol (s: Symbol.t) = 
    "id: " ^ string_of_int s.id ^ ", name: " ^ s.name ^ ", typ: " ^ string_of_typ s.typ

let rec string_of_sexpr (t, e) = 
    "(" ^ string_of_typ t ^ " : " ^ (match e with
          SBinop (e1, o, e2) -> string_of_sexpr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_sexpr e2
        | SUnop (e, o) -> string_of_sexpr e ^ " " ^ string_of_unary_op o
        | SIntLit (i) -> string_of_int i
        | STextLit (s) -> s
        | SBoolLit (true) -> "true"
        | SBoolLit (false) -> "false"
        | SLabelLit (s) -> s
        | SFloatLit (f) -> string_of_float f
        (* | SNode (n) -> string_of_node n *)
        | SVar (s) -> string_of_symbol s
        | SSeq (l) -> String.concat ", " (List.map string_of_sexpr l)
        | STup (e1, e2) -> "(" ^ string_of_sexpr e1 ^ ", " ^ string_of_sexpr e2 ^ ")"
        | SAsn (s, e) -> "(" ^ string_of_symbol s ^ ", " ^ string_of_sexpr e ^ ")"

        | SNar (_var, title, root, narr_label) ->
            string_of_narrative { Ast.title; Ast.root; Ast.narr_label }

        | SItm (var_name, iname, usage, num, unique, dur, cost, cons) ->
            string_of_item { Ast.var_name; iname; usage; num; unique; dur; cost; cons }

        | SNde (character, id, dialogue, label, options, next) ->
            string_of_node { Ast.character; id; dialogue; label; options; next }

        | SChrc (var_name, name, level, hp, inventory) ->
            string_of_chrctr { Ast.var_name; name; level; hp; inventory }


        | SNodeStream (s1, l, s2) -> "(" ^ s1 ^ ", [" ^ String.concat ", " (List.map string_of_sexpr l) ^ "], " ^ s2 ^ ")"
        | SCodeBlock (s1, l, s2) -> "(" ^ s1 ^ ", [" ^ String.concat ", " (List.map string_of_sexpr l) ^ "], " ^ s2 ^ ")"
        | SNodeBlock (s1, l, s2) -> "(" ^ s1 ^ ", [" ^ String.concat ", " (List.map string_of_sexpr l) ^ "], " ^ s2 ^ ")"
        | SAddItem (s1, s2) -> "(" ^ s1 ^ ", " ^ s2 ^ ")"
        | SIfExpr (e1, l1, l2, l3) -> 
            let option_string ll = 
            match ll with
            | Some l -> "[" ^ String.concat ", " (List.map string_of_sexpr l) ^ "]"
            | None -> "None"
            in

            let l2_string (e1, l) = "(" ^ string_of_sexpr e1 ^ ", [" ^
                                    String.concat ", " (List.map string_of_sexpr l) ^ "])"
            in
            
            "(" ^ string_of_sexpr e1 ^ ", [" ^ 
            String.concat ", " (List.map string_of_sexpr l1) ^ "], " ^
            String.concat ", " (List.map l2_string l2) ^ "], " ^
            option_string l3 ^ ")"
    ) ^ ")"