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

(* sexprs (sexy expressions) *)
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
