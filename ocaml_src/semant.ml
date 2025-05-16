
(* menemo smenatic checking *)

open Ast
open Sast

module StringMap = Map.Make(String)


let check_assignment leftVType rightVType =
	if leftVType = rightVType then
		leftVType
	else
		raise (Failure ("Type error: left and right types do not match"))


let bindings = [
  (TNode, "node");
  (TChar, "character");
  (TItem, "item");
  (TNar, "narrative");
]

let symbols =
  List.fold_left
    (fun acc (ty, name) -> StringMap.add name ty acc)
    StringMap.empty
    bindings


module SymbolTable = struct
  let tbl = Hashtbl.create 32
  let fresh name typ =
    let s = Symbol.fresh ~name ~typ in
    Hashtbl.replace tbl name s;
    s
  let find name =
    try Some (Hashtbl.find tbl name) with Not_found -> None
end


let rec check_expr = function
    IntLit l -> (TInt, SIntLit l)
    | TextLit l -> (TString, STextLit l)
    | BoolLit l -> (TBool, SBoolLit l)
    | LabelLit l -> (TString, SLabelLit l)
    | FloatLit l -> (TFloat, SFloatLit l)
    | Binop (e1, op, e2) as e ->
      let (t1, v1) = check_expr e1 and (t2, v2) = check_expr e2 in
      let err = (
        "illegal binary operator " ^
        string_of_typ t1 ^ " " ^ string_of_op op ^ " " ^
        string_of_typ t2 ^ " in " ^ string_of_expr e
      ) in
      let t = match (op, t1, t2) with
      | (Add | Sub | Mul | Div), TInt, TInt -> TInt
      | (Add | Sub | Mul | Div), TFloat, TFloat -> TFloat
      | Eq, t1', t2' when t1' = t2' -> TBool
      | (Lt | Leq | Gt | Geq), TInt, TInt -> TBool
      | (Lt | Leq | Gt | Geq), TFloat, TFloat -> TBool
      | _ -> raise (Failure err)
    in
    (t, SBinop((t1, v1), op, (t2, v2)))
    | Unop (e1, op) as e ->
      let (t1, v1) = check_expr e1 in
      let err = (
        "illegal unop operator " ^
        string_of_typ t1 ^ " " ^ string_of_unary_op op ^ " in " ^ string_of_expr e
      ) in
      let t = match (op, t1) with
        | (Incr | Decr), TInt -> TInt
        | (Incr | Decr), TFloat -> TFloat
        | Not, TBool -> TBool
        | Not, TString -> TString
        | Not, TInt -> TInt
        | Not, TFloat -> TFloat
        | _ -> raise (Failure err)
      in
      (t, SUnop((t1, v1), op))
    | Seq exprs ->
      let checked = List.map check_expr exprs in
      (TList TUnit, SSeq checked)

    | Tup (e1,e2) ->
        let (t1,sx1) = check_expr e1
        and (t2,sx2) = check_expr e2 in
        (TTup(t1,t2), STup((t1,sx1),(t2,sx2)))

    | Asn (v,e) ->
        let (t2,sx2) = check_expr e in
        let t1 = 
          match SymbolTable.find v with
          | Some sym -> check_assignment sym.typ t2
          | None ->
              t2
        in
        let sym = SymbolTable.fresh v t2 in
        (t2, SAsn(sym,(t2,sx2)))

    | Var v ->
        begin match SymbolTable.find v with
        | Some sym -> (sym.typ, SVar sym)
        | None ->
            let t = StringMap.find v symbols in
            let sym = SymbolTable.fresh v t in
            (t, SVar sym)
        end


    | CodeBlock(start_kw, exprs, end_kw) ->
        let ch = List.map check_expr exprs in
        (TUnit, SCodeBlock(start_kw, ch, end_kw))

    | NodeBlock(start_kw, exprs, end_kw) ->
        let ch = List.map check_expr exprs in
        (TUnit, SNodeBlock(start_kw, ch, end_kw))

    | NodeStream(start_kw, exprs, end_kw) ->
        let ch = List.map check_expr exprs in
        (TUnit, SNodeStream(start_kw, ch, end_kw))
    | Nar n ->
        (TNar, SNar n)

    | Itm i ->
        (TItem, SItm i)

    | Chrc c ->
        (TChar, SChrc c)

    | Nde nd ->
        (TNode, SNde nd)

    | AddItem (v1,v2) ->
        (TUnit, SAddItem(v1,v2))