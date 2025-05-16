

open Ast
open Sast

module StringMap = Map.Make(String)


let check_binds kind binds =
  let rec dups = function
    | [] -> ()
    | (_, n1) :: (_, n2) :: _ when n1 = n2 ->
        raise (Failure ("duplicate " ^ kind ^ " " ^ n1))
    | _ :: t -> dups t
  in
  dups (List.sort (fun (_,a) (_,b) -> compare a b) binds)

module SymbolTable = struct
  let tbl = Hashtbl.create 32
  let fresh name typ =
    let sym = Symbol.fresh ~name ~typ in
    Hashtbl.replace tbl name sym;
    sym
  let find name =
    try Some (Hashtbl.find tbl name)
    with Not_found -> None
end

let check (globals, program : (typ * string) list * Ast.expr list)
    : (typ * string) list * (Sast.typ * Sast.sx) list =

  check_binds "global" globals;

  let global_env =
    List.fold_left
      (fun env (ty, name) -> StringMap.add name ty env)
      StringMap.empty
      globals
  in


  let rec check_expr env = function
    | IntLit l     -> (TInt,  SIntLit l)
    | TextLit l    -> (TString, STextLit l)
    | BoolLit l    -> (TBool, SBoolLit l)
    | LabelLit l   -> (TString, SLabelLit l)
    | FloatLit l   -> (TFloat, SFloatLit l)

    | Var v        ->
      begin match SymbolTable.find v with
      | Some sym -> (sym.typ, SVar sym)
      | None     ->
        let ty =
          try StringMap.find v env
          with Not_found ->
            raise (Failure ("undeclared identifier " ^ v))
        in
        let sym = SymbolTable.fresh v ty in
        (ty, SVar sym)
      end

    | Asn (v, e)   ->
      let (rt, e') = check_expr env e in
      let lt =
        match SymbolTable.find v with
        | Some sym -> sym.typ
        | None ->
          (* if not already in locals, pull it as a global *)
          let ty =
            try StringMap.find v env
            with Not_found ->
              raise (Failure ("undeclared identifier " ^ v))
          in
          ty
      in
      let _ = SymbolTable.fresh v rt in
      let _ = if lt <> rt then
                raise (Failure ("Type error: " ^ string_of_typ lt ^
                                " = " ^ string_of_typ rt))
              else ()
      in
      (rt, SAsn(SymbolTable.fresh v rt, (rt, e')))

    | Binop (e1, op, e2) as e ->
      let (t1, v1) = check_expr env e1
      and (t2, v2) = check_expr env e2 in
      let err = "illegal binary operator " ^
                string_of_typ t1 ^ " " ^ string_of_op op ^ " " ^
                string_of_typ t2 ^ " in " ^ string_of_expr e
      in
      let t = match op, t1, t2 with
        | (Add|Sub|Mul|Div), TInt,  TInt  -> TInt
        | (Add|Sub|Mul|Div), TFloat,TFloat-> TFloat
        | Eq,         x, y  when x = y   -> TBool
        | (Lt|Leq|Gt|Geq), TInt,TInt     -> TBool
        | (Lt|Leq|Gt|Geq), TFloat,TFloat -> TBool
        | _ -> raise (Failure err)
      in
      (t, SBinop((t1,v1), op, (t2,v2)))

    | Unop (e1, op) as e ->
      let (t1, v1) = check_expr env e1 in
      let err = "illegal unary operator " ^
                string_of_unary_op op ^ " in " ^ string_of_expr e in
      let t = match op, t1 with
        | (Incr|Decr), TInt   -> TInt
        | (Incr|Decr), TFloat -> TFloat
        | Not, TBool          -> TBool
        | _ -> raise (Failure err)
      in
      (t, SUnop((t1, v1), op))

    | CodeBlock(start_kw, exprs, end_kw) ->
        let ch = List.map (check_expr env) exprs in
        (TUnit, SCodeBlock(start_kw, ch, end_kw))

    | NodeBlock(start_kw, exprs, end_kw) ->
        let ch = List.map (check_expr env) exprs in
        (TUnit, SNodeBlock(start_kw, ch, end_kw))

    | NodeStream(start_kw, exprs, end_kw) ->
        let ch = List.map (check_expr env) exprs in
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

  in

  let sprogram = List.map (check_expr global_env) program in
  (globals, sprogram)
