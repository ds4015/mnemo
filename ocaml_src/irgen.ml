(* IR generation *)

module L = Llvm
module A = Ast
open Sast

module StringMap = Map.Make(String)

let max_entries = 256

let translate (globals, sprogram) =
  let ctx     = L.global_context () in
  let the_mod = L.create_module ctx "Mnemo" in

  let i32_t   = L.i32_type    ctx in
  let i1_t    = L.i1_type     ctx in
  let float_t = L.double_type ctx in
  let str_t   = L.pointer_type (L.i8_type ctx) in

  let rec process_expr m = function
    | SNde nd ->
        if nd.label <> "" then
          let clean_label = String.map (fun c -> if c = '!' then '_' else c) nd.label in
          StringMap.add clean_label nd.id m
        else
          m
    | SNodeBlock(_, exprs, _) ->
        List.fold_left (fun m (_, e) -> process_expr m e) m exprs
    | SNodeStream(_, exprs, _) ->
        List.fold_left (fun m (_, e) -> process_expr m e) m exprs
    | SSeq exprs ->
        List.fold_left (fun m (_, e) -> process_expr m e) m exprs
    | SCodeBlock(_, exprs, _) ->
        List.fold_left (fun m (_, e) -> process_expr m e) m exprs
    | _ -> m
  in

  let label_to_id =
  List.fold_left (fun m (_, sx) ->
      (match sx with
       | SNde _ -> "SNde"
       | SSeq _ -> "SSeq"
       | SCodeBlock _ -> "SCodeBlock"
       | SNodeBlock _ -> "SNodeBlock"
       | SNodeStream _ -> "SNodeStream"
       | _ -> "Other");
    process_expr m sx
  ) StringMap.empty sprogram
in

  

  let tuple_t   = L.struct_type ctx [| str_t; i32_t |] in
  let tuple_ptr = L.pointer_type tuple_t in

  let item_t = L.named_struct_type ctx "item" in
  let _ = L.struct_set_body item_t
    [| str_t; str_t; str_t; i32_t; i1_t; i32_t; i32_t; i1_t |] false in

  let node_t = L.named_struct_type ctx "node" in
  let _ = L.struct_set_body node_t
    [| str_t;       (* character *)
      i32_t;       (* id *)
      str_t;       (* dialogue *)
      str_t;       (* label *)
      L.pointer_type (L.array_type tuple_t max_entries);  
      i32_t;       (* num_options *)
      i32_t        (* next_id *)
    |] false in

  let chrctr_t = L.named_struct_type ctx "chrctr" in
  let _ = L.struct_set_body chrctr_t
    [| str_t; str_t; i32_t; i32_t; L.pointer_type item_t |] false in

  let narr_t = L.named_struct_type ctx "narr" in
  let _ = L.struct_set_body narr_t
    [| str_t; str_t; str_t |] false in


  (* narrative table *)
  let narr_arr_ty  = L.array_type    (L.pointer_type narr_t) max_entries in
  let narr_array   = L.define_global "narr_arr" (L.const_null narr_arr_ty) the_mod in
  let narr_idx     = L.define_global "narr_idx" (L.const_int i32_t 0) the_mod in

  let narr_add_ft  = L.function_type (L.void_type ctx) [| L.pointer_type narr_t |] in
  let narr_add_fn  = L.define_function "NarrativeTable_add" narr_add_ft the_mod in
  let bldr_narr    = L.builder_at_end ctx (L.entry_block narr_add_fn) in

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

  let empty_str = L.build_global_stringptr "" "empty_str" builder in

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
    | SCodeBlock(_, exprs, _) ->
        List.fold_left (fun _ e -> build_expr builder e) (L.const_int i32_t 0) exprs
    | SNodeBlock(_, exprs, _) ->
        List.fold_left (fun _ e -> build_expr builder e) (L.const_int i32_t 0) exprs
    | SNodeStream(_, exprs, _) ->
        List.fold_left (fun _ e -> build_expr builder e) (L.const_int i32_t 0) exprs
    | SNde nd ->
        let ch       = L.build_global_stringptr nd.character "ch" builder in
        let nid      = L.const_int             i32_t nd.id in
        let dlg      = L.build_global_stringptr nd.dialogue  "dlg" builder in
        let lbl      = L.build_global_stringptr nd.label     "lbl" builder in

        let opts = nd.options in
        let num_opts = List.length opts in
        let num_opts_const = L.const_int i32_t num_opts in

        let array_ty = L.array_type tuple_t max_entries in
        let raw_opts_ptr = L.build_malloc array_ty "opts_arr" builder in

        let memset_ty = L.function_type (L.void_type ctx) 
                        [| L.pointer_type (L.i8_type ctx); L.i8_type ctx; L.i64_type ctx; L.i1_type ctx |] in
        let memset_fn = L.declare_function "llvm.memset.p0i8.i64" memset_ty the_mod in
        
        let array_size = L.const_int (L.i64_type ctx) (max_entries * 16) in  (* 16 = size of tuple_t *)
        let array_ptr = L.build_bitcast raw_opts_ptr (L.pointer_type (L.i8_type ctx)) "array_ptr" builder in
        ignore (L.build_call memset_fn [| array_ptr; L.const_int (L.i8_type ctx) 0; array_size; L.const_int (L.i1_type ctx) 0 |] "" builder);

        List.iteri (fun i (opt_text, next_lbl) ->
          let idx = L.const_int i32_t i in
          let elem_ptr = L.build_in_bounds_gep raw_opts_ptr [| L.const_int i32_t 0; idx |] ("opt_elem" ^ string_of_int i) builder in
          let text_val = L.build_global_stringptr opt_text "opt_txt" builder in
          let fld0 = L.build_in_bounds_gep elem_ptr [| L.const_int i32_t 0; L.const_int i32_t 0 |] "f0" builder in
          ignore (L.build_store text_val fld0 builder);

          let next_id =
            try 
              let clean_label = String.map (fun c -> if c = '!' then '_' else c) next_lbl in
              let id = StringMap.find clean_label label_to_id in
              id
            with Not_found -> 
              Printf.printf "    Failed to find label '%s' in map. Available labels:\n" next_lbl;
              StringMap.iter (fun label id -> Printf.printf "      %s -> %d\n" label id) label_to_id;
              failwith (Printf.sprintf "Unknown label: '%s' (cleaned: '%s'). Available labels: %s" 
                next_lbl 
                (String.map (fun c -> if c = '!' then '_' else c) next_lbl)
                (String.concat ", " (List.map fst (StringMap.bindings label_to_id))))
          in
          let fld1 = L.build_in_bounds_gep elem_ptr [| L.const_int i32_t 0; L.const_int i32_t 1 |] "f1" builder in
          ignore (L.build_store (L.const_int i32_t next_id) fld1 builder)
        ) opts;

        let opts_ptr = raw_opts_ptr in
        let num_opts_val = num_opts_const in

        let node_ptr = L.build_malloc node_t "node" builder in
        let store_field idx value = 
          let field_ptr = L.build_in_bounds_gep node_ptr [| L.const_int i32_t 0; L.const_int i32_t idx |] "field" builder in
          ignore (L.build_store value field_ptr builder)
        in
        store_field 0 ch;
        store_field 1 nid;
        store_field 2 dlg;
        store_field 3 lbl;
        store_field 4 opts_ptr;   
        store_field 5 num_opts_val; 
        store_field 6 (L.const_int i32_t nd.next);
      
        ignore (L.build_call node_table_add_fn [| node_ptr |] "" builder);
        L.const_int i32_t 0
    | _              -> L.const_int i32_t 0
  in

  List.iter (fun sexpr -> ignore(build_expr builder sexpr)) sprogram;


let printf_ty = L.var_arg_function_type i32_t [| L.pointer_type (L.i8_type ctx) |] in
let printf_fn = L.declare_function "printf" printf_ty the_mod in
let scanf_ty  = L.var_arg_function_type i32_t [| L.pointer_type (L.i8_type ctx) |] in
let scanf_fn  = L.declare_function "scanf" scanf_ty the_mod in
let getchar_ty = L.function_type i32_t [||] in
let getchar_fn = L.declare_function "getchar" getchar_ty the_mod in

let fmt_node = L.build_global_stringptr "%s: %s\n\n"    "fmt_node" builder in
let fmt_int  = L.build_global_stringptr "%d"            "fmt_int"  builder in

let run_fn    = L.define_function "run" (L.function_type i32_t [||]) the_mod in
let entry_bb  = L.entry_block run_fn in
let head_bb   = L.append_block ctx "loop.head" run_fn in
let body_bb   = L.append_block ctx "loop.body" run_fn in
let exit_bb   = L.append_block ctx "loop.exit" run_fn in

let b_entry = L.builder_at_end ctx entry_bb in
let count   = L.build_load node_idx "count" b_entry in
let cur_ptr = L.build_alloca i32_t "cur" b_entry in
ignore (L.build_store (L.const_int i32_t 0) cur_ptr b_entry);
ignore (L.build_br head_bb b_entry);

let b_head = L.builder_at_end ctx head_bb in
let cur    = L.build_load cur_ptr "cur" b_head in
let cond   = L.build_icmp L.Icmp.Slt cur count "cond" b_head in
ignore (L.build_cond_br cond body_bb exit_bb b_head);

let b_body      = L.builder_at_end ctx body_bb in
let gep         = L.build_in_bounds_gep node_array [| L.const_int i32_t 0; cur |] "node_ptr_ptr" b_body in
let node_ptr    = L.build_load gep "node_ptr" b_body in

let ch_ptr   = L.build_in_bounds_gep node_ptr [| L.const_int i32_t 0; L.const_int i32_t 0 |] "ch_ptr" b_body in
let ch       = L.build_load ch_ptr "ch" b_body in
let dlg_ptr  = L.build_in_bounds_gep node_ptr [| L.const_int i32_t 0; L.const_int i32_t 2 |] "dlg_ptr" b_body in
let dlg      = L.build_load dlg_ptr "dlg" b_body in


let num_opts_ptr = L.build_in_bounds_gep node_ptr [| L.const_int i32_t 0; L.const_int i32_t 5 |] "num_opts_ptr" b_body in
let num_opts = L.build_load num_opts_ptr "num_opts" b_body in


let fmt_bar = L.build_global_stringptr "----------------------------------------\n" "fmt_bar" b_body in
let fmt_dialogue = L.build_global_stringptr "%s: %s\n" "fmt_dialogue" b_body in
ignore (L.build_call printf_fn [| fmt_bar |] "" b_body);
ignore (L.build_call printf_fn [| fmt_dialogue; ch; dlg |] "" b_body);
ignore (L.build_call printf_fn [| fmt_bar |] "" b_body);


let fmt_pause = L.build_global_stringptr "Press any key to continue...\n" "fmt_pause" b_body in
ignore (L.build_call printf_fn [| fmt_pause |] "" b_body);
ignore (L.build_call getchar_fn [||] "" b_body);


let has_opts = L.build_icmp L.Icmp.Sgt num_opts (L.const_int i32_t 0) "has_opts" b_body in
let opts_bb = L.append_block ctx "opts" run_fn in
let no_opts_bb = L.append_block ctx "no_opts" run_fn in
ignore (L.build_cond_br has_opts opts_bb no_opts_bb b_body);


let b_opts = L.builder_at_end ctx opts_bb in
let opts_ptr = L.build_in_bounds_gep node_ptr [| L.const_int i32_t 0; L.const_int i32_t 4 |] "opts_ptr" b_opts in
let opts = L.build_load opts_ptr "opts" b_opts in


let fmt_opt_bar = L.build_global_stringptr "----------------------------------------\n" "fmt_opt_bar" b_opts in
let fmt_opt = L.build_global_stringptr "%d: %s\n" "fmt_opt" b_opts in
ignore (L.build_call printf_fn [| fmt_opt_bar |] "" b_opts);
let i_ptr = L.build_alloca i32_t "i" b_opts in
ignore (L.build_store (L.const_int i32_t 0) i_ptr b_opts);

let opt_loop_head = L.append_block ctx "opt_loop_head" run_fn in
let opt_loop_body = L.append_block ctx "opt_loop_body" run_fn in
let opt_loop_exit = L.append_block ctx "opt_loop_exit" run_fn in

ignore (L.build_br opt_loop_head b_opts);

let b_opt_head = L.builder_at_end ctx opt_loop_head in
let i = L.build_load i_ptr "i" b_opt_head in
let opt_cond = L.build_icmp L.Icmp.Slt i num_opts "opt_cond" b_opt_head in
ignore (L.build_cond_br opt_cond opt_loop_body opt_loop_exit b_opt_head);

let b_opt_body = L.builder_at_end ctx opt_loop_body in
let opt_elem = L.build_in_bounds_gep opts [| L.const_int i32_t 0; i |] "opt_elem" b_opt_body in
let opt_text_ptr = L.build_in_bounds_gep opt_elem [| L.const_int i32_t 0; L.const_int i32_t 0 |] "opt_text_ptr" b_opt_body in
let opt_text = L.build_load opt_text_ptr "opt_text" b_opt_body in
ignore (L.build_call printf_fn [| fmt_opt; i; opt_text |] "" b_opt_body);
let next_i = L.build_add i (L.const_int i32_t 1) "next_i" b_opt_body in
ignore (L.build_store next_i i_ptr b_opt_body);
ignore (L.build_br opt_loop_head b_opt_body);

let b_opt_exit = L.builder_at_end ctx opt_loop_exit in
ignore (L.build_call printf_fn [| fmt_opt_bar |] "" b_opt_exit);
let choice_ptr = L.build_alloca i32_t "choice_ptr" b_opt_exit in
let fmt_int = L.build_global_stringptr "%d" "fmt_int" b_opt_exit in
ignore (L.build_call scanf_fn [| fmt_int; choice_ptr |] "" b_opt_exit);
let choice = L.build_load choice_ptr "choice" b_opt_exit in


let valid_choice = L.build_icmp L.Icmp.Slt choice num_opts "valid_choice" b_opt_exit in
let invalid_bb = L.append_block ctx "invalid_choice" run_fn in
let valid_bb = L.append_block ctx "valid_choice" run_fn in
ignore (L.build_cond_br valid_choice valid_bb invalid_bb b_opt_exit);


let b_invalid = L.builder_at_end ctx invalid_bb in
let fmt_invalid = L.build_global_stringptr "Invalid choice. Please try again.\n" "fmt_invalid" b_invalid in
ignore (L.build_call printf_fn [| fmt_invalid |] "" b_invalid);
ignore (L.build_br opt_loop_head b_invalid);


let b_valid = L.builder_at_end ctx valid_bb in
let chosen_opt = L.build_in_bounds_gep opts [| L.const_int i32_t 0; choice |] "chosen_opt" b_valid in
let next_id_ptr = L.build_in_bounds_gep chosen_opt [| L.const_int i32_t 0; L.const_int i32_t 1 |] "next_id_ptr" b_valid in
let next_id = L.build_load next_id_ptr "next_id" b_valid in
ignore (L.build_store next_id cur_ptr b_valid);
ignore (L.build_br head_bb b_valid);


let b_no_opts = L.builder_at_end ctx no_opts_bb in
let next_ptr = L.build_in_bounds_gep node_ptr [| L.const_int i32_t 0; L.const_int i32_t 6 |] "next_ptr" b_no_opts in
let next_id = L.build_load next_ptr "next_id" b_no_opts in
ignore (L.build_store next_id cur_ptr b_no_opts);
ignore (L.build_br head_bb b_no_opts);

let b_exit = L.builder_at_end ctx exit_bb in
ignore (L.build_ret (L.const_int i32_t 0) b_exit);

let main_builder = L.builder_at_end ctx (L.entry_block main_fn) in

let _ = L.build_call run_fn [||] "runcall" main_builder in

ignore (L.build_ret (L.const_int i32_t 0) main_builder);
the_mod