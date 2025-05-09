(* Mnemo Abstract Syntax Tree (AST) *)
(* Dallas - NB: this is functional; updates coming *)

type operator = Add | Sub | Mul | Div | Eq | Geq | Leq | Lt | Gt
type unaryop = Incr | Decr | Not

(* records *)
type item = {
    var_name: string;
    iname: string;
    usage: string;
    mutable num: int;
    unique: bool;
    mutable dur: int;
    cost: int;
    cons: bool;
}

type node = {
    character: string;
    mutable id: int;
    dialogue: string;
    label: string;
    options: (string * string) list;
    mutable next: int
}

type chrctr = {
    var_name: string;
    mutable name: string;
    mutable level: int;
    mutable hp: int;
    mutable inventory: item list;
}

type narr = {
    title: string;
    root: string;
    narr_label: string;
}

(* expressions *)
type expr =
    Binop of expr * operator * expr
    | Unop of expr * unaryop
    | IntLit of int
    | TextLit of string
    | BoolLit of bool
    | LabelLit of string
    | FloatLit of float
    (* | Node of node     *)
    | Var of string
    | Seq of expr list
    | Tup of expr * expr
    | ProcOpt of (expr list) * node
    | Asn of string * expr
    | Nar of narr
    | Itm of item
    | Nde of node
    | NodeStream of string * expr list * string
    | CodeBlock of string * expr list * string
    | NodeBlock of string * expr list * string
    | Chrc of chrctr
    | AddItem of string * string
    | IfExpr of expr * expr list * (expr * expr list) list * expr list option

type program = {
    var_name: string;
    node_blocks: node;
    nodes_blocks: node list;
    expr: expr option;
}

type stmt =
    | If of expr * stmt * stmt
    | Expr of expr

(* values *)
type value =
  | Int of int
  | Bool of bool
  | Float of float
  | Text of string
  | String of expr
  | Empty of string * string
  | Label of string
  | Narrative of narr
  | Block of expr list
  | Inventory of item list
  | Options of (string * string) list
  | Item of item
  | Character of chrctr
  | Node of node
  | Tuple of string * string
  | ItemAdd of value * value
  | ItemTup of value * value
  | ValUnit

(* printout for narrative eval - debug *)

(* NOTE: the function below should be deleted as it doesn't work*)
(* let string_of_typ = function
  | chrctr -> "character"
  | narr -> "narrative"
  | item -> "item" *)

let string_of_op = function
    Add -> "+"
  | Sub -> "-"
  | Mul -> "*"
  | Div -> "/"
  | Eq -> "is"
  | Geq -> ">="
  | Leq -> "<="
  | Lt -> "<"  
  | Gt -> ">"

let string_of_unary_op = function
  | Incr -> "++"
  | Decr -> "--"
  | Not -> "~"

let string_of_narrative narr =
  "Title: " ^ narr.title ^ ", Root: " ^ narr.root ^ ", Label: " ^ narr.narr_label

(* printout for item eval - debug *)
let string_of_item it =
  "Name: " ^ it.iname ^ ", Usage: " ^ it.usage ^ ", Number: " ^ string_of_int it.num ^
  ", Unique: " ^ string_of_bool it.unique ^ ", Duration: " ^ string_of_int it.dur ^
  ", Cost: " ^ string_of_int it.cost ^ ", Consumable: " ^ string_of_bool it.cons

(* printout for inventory eval - debug *)
let string_of_item_list items =
  String.concat ", " (List.map string_of_item items)

(* printout for options eval - debug *)
let string_of_options opts =
  String.concat ", " (List.map (fun (key, value) -> "(" ^ key ^ ", " ^ value ^ ")") opts)

(* printout for character eval - debug *)
let string_of_chrctr chr =
  "Name: " ^ chr.name ^ ", Level: " ^ string_of_int chr.level ^ ", HP: " ^ string_of_int chr.hp ^
  ", Inventory: [" ^ string_of_item_list chr.inventory ^ "]"

(* printout for node eval - debug *)
let string_of_node nd =
  "Character: " ^ nd.character ^ ", ID: " ^ string_of_int nd.id ^ ", Dialogue: " ^ nd.dialogue ^
  ", Label: " ^ nd.label ^ ", Options: [" ^ string_of_options nd.options ^ "], Next: " ^ string_of_int nd.next

let rec string_of_expr = function
   Binop (e1, o, e2) -> string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
 | Unop (e, o) -> string_of_expr e ^ " " ^ string_of_unary_op o
 | IntLit (i) -> string_of_int i
 | TextLit (s) -> s
 | BoolLit (true) -> "true"
 | BoolLit (false) -> "false"
 | LabelLit (s) -> s
 | FloatLit (f) -> string_of_float f
 (* | Node (n) -> string_of_node n *)
 | Var (s) -> s
 | Seq (l) -> String.concat ", " (List.map string_of_expr l)
 | Tup (e1, e2) -> "(" ^ string_of_expr e1 ^ ", " ^ string_of_expr e2 ^ ")"
 | ProcOpt (l, n) -> 
    "([" ^ String.concat ", " (List.map string_of_expr l) ^ "], " ^ string_of_node n ^ ")"
 | Asn (s, e) -> "(" ^ s ^ ", " ^ string_of_expr e ^ ")"
 | Nar (nar) -> string_of_narrative nar 
 | Itm (itm) -> string_of_item itm
 | Nde (n) -> string_of_node n
 | NodeStream (s1, l, s2) -> "(" ^ s1 ^ ", [" ^ String.concat ", " (List.map string_of_expr l) ^ "], " ^ s2 ^ ")"
 | CodeBlock (s1, l, s2) -> "(" ^ s1 ^ ", [" ^ String.concat ", " (List.map string_of_expr l) ^ "], " ^ s2 ^ ")"
 | NodeBlock (s1, l, s2) -> "(" ^ s1 ^ ", [" ^ String.concat ", " (List.map string_of_expr l) ^ "], " ^ s2 ^ ")"
 | Chrc (chrc) -> string_of_chrctr chrc
 | AddItem (s1, s2) -> "(" ^ s1 ^ ", " ^ s2 ^ ")"
 | IfExpr (e1, l1, l2, l3) -> 
      let option_string ll = 
      match ll with
      | Some l -> "[" ^ String.concat ", " (List.map string_of_expr l) ^ "]"
      | None -> "None"
      in

      let l2_string (e1, l) = "(" ^ string_of_expr e1 ^ ", [" ^
                              String.concat ", " (List.map string_of_expr l) ^ "])"
      in
      
      "(" ^ string_of_expr e1 ^ ", [" ^ 
      String.concat ", " (List.map string_of_expr l1) ^ "], " ^
      String.concat ", " (List.map l2_string l2) ^ "], " ^
      option_string l3 ^ ")"
                              


(* printout for values - debug *)
let string_of_value v =
  match v with
  | Int(i) -> string_of_int i
  | Bool(b) -> string_of_bool b
  | Float(f) -> string_of_float f
  | Text(t) -> t
  | String (s) -> string_of_expr s
  | Label(l) -> l
  | Narrative(narr) -> "Narrative: " ^ string_of_narrative narr
  | Inventory(items) -> "Inventory: " ^ string_of_item_list items
  | Options(opts) -> "Options: " ^ string_of_options opts
  | Item(it) -> "Item: " ^ string_of_item it
  | Character(chr) -> "Character: " ^ string_of_chrctr chr
  | Node(nd) -> "Node: " ^ string_of_node nd
  | Node(ns) -> "Nodes: Stream of nodes created"
  | Tuple(s1, s2) -> "Tuple: (" ^ s1 ^ ", " ^ s2 ^ ")"


  (* node id counter - auto increment *)
  let node_counter = ref 0