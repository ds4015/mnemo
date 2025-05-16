(* IR generation *)

module L = Llvm
module A = Ast
open Sast

module StringMap = Map.Make(String)


let translate (globals, sprogram) =
  let ctx     = L.global_context () in
  let the_mod = L.create_module ctx "Mnemo" in

  let i32_t   = L.i32_type    ctx in
  let i1_t    = L.i1_type     ctx in
  let float_t = L.double_type ctx in
  let str_t   = L.pointer_type (L.i8_type ctx) in

  let tuple_t   = L.struct_type ctx [| str_t; str_t |] in
  let tuple_ptr = L.pointer_type tuple_t in

  let item_t = L.named_struct_type ctx "item" in
  let _ = L.struct_set_body item_t
    [| str_t; str_t; str_t; i32_t; i1_t; i32_t; i32_t; i1_t |] false in

  let node_t = L.named_struct_type ctx "node" in
  let _ = L.struct_set_body node_t
    [| str_t; i32_t; str_t; str_t; tuple_ptr; i32_t |] false in

  let chrctr_t = L.named_struct_type ctx "chrctr" in
  let _ = L.struct_set_body chrctr_t
    [| str_t; str_t; i32_t; i32_t; L.pointer_type item_t |] false in

  let narr_t = L.named_struct_type ctx "narr" in
  let _ = L.struct_set_body narr_t
    [| str_t; str_t; str_t |] false in

  let rec ltype_of_typ = function
    | TInt        -> i32_t
    | TBool       -> i1_t
    | TFloat      -> float_t
    | TString     -> str_t
    | TNode       -> node_t
    | TNar        -> narr_t
    | TItem       -> item_t
    | TChar       -> L.i8_type ctx
    | TUnit       -> L.void_type ctx
    | TTup(t1,t2) -> L.struct_type ctx [| ltype_of_typ t1; ltype_of_typ t2 |]
    | TList t     -> L.pointer_type (ltype_of_typ t)
  in

  let global_vars =
    List.fold_left (fun m (t,n) ->
      let init = L.const_int (ltype_of_typ t) 0 in
      StringMap.add n (L.define_global n init the_mod) m
    ) StringMap.empty globals
  in

  let main_ty = L.function_type i32_t [||] in
  let main_fn = L.define_function "main" main_ty the_mod in
  let builder = L.builder_at_end ctx (L.entry_block main_fn) in

  let rec build_expr builder ((_, e) : sexpr) = match e with
    | SIntLit i      -> L.const_int i32_t i
    | SBoolLit b     -> L.const_int i1_t (if b then 1 else 0)
    | STextLit s
    | SLabelLit s    -> L.build_global_stringptr s "str" builder
    | SBinop(a,op,b) ->
        let a' = build_expr builder a in
        let b' = build_expr builder b in
        let instr = match op with
          | A.Add -> L.build_add
          | A.Sub -> L.build_sub
          | A.Mul -> L.build_mul
          | A.Div -> L.build_sdiv
          | A.Eq  -> L.build_icmp L.Icmp.Eq
          | A.Lt  -> L.build_icmp L.Icmp.Slt
          | _    -> failwith "unhandled binary op"
        in instr a' b' "tmp" builder
    | SUnop(a,op)    ->
        let a' = build_expr builder a in
        begin match op with
        | A.Incr -> L.build_add a' (L.const_int i32_t 1) "tmp" builder
        | A.Decr -> L.build_sub a' (L.const_int i32_t 1) "tmp" builder
        | A.Not  -> L.build_not a' "tmp" builder
        | _      -> failwith "unhandled unary op"
        end
    | SVar sym       ->
        let ptr = try StringMap.find sym.name global_vars
                  with Not_found -> failwith ("unknown global "^sym.name) in
        L.build_load ptr sym.name builder
    | SAsn(sym,e)    ->
        let v = build_expr builder e in
        let ptr = try StringMap.find sym.name global_vars
                  with Not_found -> failwith ("unknown global "^sym.name) in
        ignore(L.build_store v ptr builder); v
    | SSeq exprs
    | SCodeBlock(_,exprs,_) 
    | SNodeBlock(_,exprs,_) 
    | SNodeStream(_,exprs,_)->
        List.fold_left (fun _ e -> build_expr builder e) (L.const_int i32_t 0) exprs
    | _              -> L.const_int i32_t 0
  in

  List.iter (fun sexpr -> ignore(build_expr builder sexpr)) sprogram;

  ignore(L.build_ret (L.const_int i32_t 0) builder);

  the_mod