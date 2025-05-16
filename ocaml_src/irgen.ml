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


  let max_entries = 256 in

  (* narrative table *)
  let narr_arr_ty  = L.array_type    (L.pointer_type narr_t) max_entries in
  let narr_array   = L.define_global "narr_arr" (L.const_null narr_arr_ty) the_mod in
  let narr_idx     = L.define_global "narr_idx" (L.const_int i32_t 0) the_mod in

  let narr_add_ft  = L.function_type (L.void_type ctx) [| L.pointer_type narr_t |] in
  let narr_add_fn  = L.define_function "NarrativeTable_add" narr_add_ft the_mod in
  let bldr_narr    = L.builder_at_end ctx (L.entry_block narr_add_fn) in

  (* Now use the bound `narr_idx` directly: *)
  let curr_n = L.build_load narr_idx "curr" bldr_narr in
  let slot_n = L.build_in_bounds_gep narr_array
                [| L.const_int i32_t 0; curr_n |]
                "slot" bldr_narr in
  let ptr_n  = L.param narr_add_fn 0 in
  ignore (L.build_store ptr_n slot_n bldr_narr);
  let next_n = L.build_add curr_n (L.const_int i32_t 1) "next" bldr_narr in
  ignore (L.build_store next_n narr_idx bldr_narr);
  ignore (L.build_ret_void bldr_narr);

  (* item table *)
  let item_arr_ty = L.array_type    (L.pointer_type item_t) max_entries in
  let item_array  = L.define_global "item_arr" (L.const_null item_arr_ty) the_mod in
  let item_idx    = L.define_global "item_idx" (L.const_int i32_t 0) the_mod in

  let item_add_ft = L.function_type (L.void_type ctx) [| L.pointer_type item_t |] in
  let item_add_fn = L.define_function "ItemTable_add" item_add_ft the_mod in
  let bldr_item   = L.builder_at_end ctx (L.entry_block item_add_fn) in
  let curr_i = L.build_load item_idx "curr_idx" bldr_item in
  let slot_i = L.build_in_bounds_gep item_array [| L.const_int i32_t 0; curr_i |] "slot" bldr_item in
  let ptr_i  = L.param item_add_fn 0 in
  ignore (L.build_store ptr_i slot_i bldr_item);
  let next_i = L.build_add curr_i (L.const_int i32_t 1) "next_idx" bldr_item in
  ignore (L.build_store next_i item_idx bldr_item);
  ignore (L.build_ret_void bldr_item);

  (* character table *)
  let chr_arr_ty = L.array_type    (L.pointer_type chrctr_t) max_entries in
  let chr_array  = L.define_global "chr_arr" (L.const_null chr_arr_ty) the_mod in
  let chr_idx    = L.define_global "chr_idx" (L.const_int i32_t 0) the_mod in

  let chr_add_ft = L.function_type (L.void_type ctx) [| L.pointer_type chrctr_t |] in
  let chr_add_fn = L.define_function "CharacterTable_add" chr_add_ft the_mod in
  let bldr_chr   = L.builder_at_end ctx (L.entry_block chr_add_fn) in
  let curr_c = L.build_load chr_idx "curr_idx" bldr_chr in
  let slot_c = L.build_in_bounds_gep chr_array [| L.const_int i32_t 0; curr_c |] "slot" bldr_chr in
  let ptr_c  = L.param chr_add_fn 0 in
  ignore (L.build_store ptr_c slot_c bldr_chr);
  let next_c = L.build_add curr_c (L.const_int i32_t 1) "next_idx" bldr_chr in
  ignore (L.build_store next_c chr_idx bldr_chr);
  ignore (L.build_ret_void bldr_chr);

  (* node table *)
  let node_arr_ty = L.array_type    (L.pointer_type node_t) max_entries in
  let node_array  = L.define_global "node_arr" (L.const_null node_arr_ty) the_mod in
  let node_idx    = L.define_global "node_idx" (L.const_int i32_t 0) the_mod in
  let node_add_ft       = L.function_type (L.void_type ctx) [| L.pointer_type node_t |] in
  let node_table_add_fn = L.define_function "NodeTable_add" node_add_ft the_mod in
  let bldr_node         = L.builder_at_end ctx (L.entry_block node_table_add_fn) in
  let curr_nod = L.build_load node_idx  "curr_idx" bldr_node in
  let slot_nod = L.build_in_bounds_gep
                    node_array
                    [| L.const_int i32_t 0; curr_nod |]
                    "slot" bldr_node in
  let ptr_nod  = L.param node_table_add_fn 0 in
  ignore (L.build_store ptr_nod slot_nod bldr_node);
  let next_nod = L.build_add curr_nod (L.const_int i32_t 1) "next_idx" bldr_node in
  ignore (L.build_store next_nod node_idx bldr_node);
  ignore (L.build_ret_void bldr_node);


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
    | SUnop(a,op) ->
        let a' = build_expr builder a in
        begin match op with
        | A.Incr -> L.build_add a' (L.const_int i32_t 1) "tmp" builder
        | A.Decr -> L.build_sub a' (L.const_int i32_t 1) "tmp" builder
        | A.Not  -> L.build_not a' "tmp" builder
        | _      -> failwith "unhandled unary op"
        end
    | SVar sym ->
        let ptr = try StringMap.find sym.name global_vars
                  with Not_found -> failwith ("unknown global "^sym.name) in
        L.build_load ptr sym.name builder
    | SAsn(sym,e) ->
        let v = build_expr builder e in
        let ptr = try StringMap.find sym.name global_vars
                  with Not_found -> failwith ("unknown global "^sym.name) in
        ignore(L.build_store v ptr builder); v
    | SSeq exprs
    | SCodeBlock(_,exprs,_) 
    | SNodeBlock(_,exprs,_) 
    | SNodeStream(_,exprs,_)->
        List.fold_left (fun _ e -> build_expr builder e) (L.const_int i32_t 0) exprs
| SNde nd ->
        let ch   = L.build_global_stringptr nd.character "who" builder in
        let nid  = L.const_int             i32_t nd.id in
        let dlg  = L.build_global_stringptr nd.dialogue "dlg" builder in
        let lbl  = L.build_global_stringptr nd.label    "lbl" builder in
        let opts = L.const_null                         tuple_ptr in
        let nxt  = L.const_int             i32_t nd.next in

        let node_ptr = L.build_malloc node_t "node" builder in

        let f0 = L.build_in_bounds_gep node_ptr
                   [| L.const_int i32_t 0; L.const_int i32_t 0 |]
                   "f0" builder in
        ignore (L.build_store ch  f0 builder);

        let f1 = L.build_in_bounds_gep node_ptr
                   [| L.const_int i32_t 0; L.const_int i32_t 1 |]
                   "f1" builder in
        ignore (L.build_store nid f1 builder);

        let f2 = L.build_in_bounds_gep node_ptr
                   [| L.const_int i32_t 0; L.const_int i32_t 2 |]
                   "f2" builder in
        ignore (L.build_store dlg f2 builder);

        let f3 = L.build_in_bounds_gep node_ptr
                   [| L.const_int i32_t 0; L.const_int i32_t 3 |]
                   "f3" builder in
        ignore (L.build_store lbl f3 builder);

        let f4 = L.build_in_bounds_gep node_ptr
                   [| L.const_int i32_t 0; L.const_int i32_t 4 |]
                   "f4" builder in
        ignore (L.build_store opts f4 builder);

        let f5 = L.build_in_bounds_gep node_ptr
                   [| L.const_int i32_t 0; L.const_int i32_t 5 |]
                   "f5" builder in
        ignore (L.build_store nxt f5 builder);

        ignore (L.build_call node_table_add_fn [| node_ptr |] "" builder);

        L.const_int i32_t 0
    | _              -> L.const_int i32_t 0
  in

  List.iter (fun sexpr -> ignore(build_expr builder sexpr)) sprogram;

  ignore(L.build_ret (L.const_int i32_t 0) builder);

  the_mod