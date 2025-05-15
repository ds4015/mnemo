(* IR generation: translate takes a semantically checked AST and
   produces LLVM IR

   LLVM tutorial: Make sure to read the OCaml version of the tutorial

   http://llvm.org/docs/tutorial/index.html

   Detailed documentation on the OCaml LLVM library:

   http://llvm.moe/
   http://llvm.moe/ocaml/

*)

module L = Llvm
module A = Ast
open Sast

module StringMap = Map.Make(String)

(* translate : Sast.program -> Llvm.module *)
let translate (globals, functions) =
  let context    = L.global_context () in

  (* Create the LLVM compilation module into which
     we will generate code *)
  let the_module = L.create_module context "Mnemo" in

  (* Get types from the context *)
  let i32_t      = L.i32_type    context  (* int, float *)
  and i8_t       = L.i8_type     context  (* char *) (* TODO: potentially erase this line*)
  and i1_t       = L.i1_type     context (* bool *)
  and void_t     = L.void_type   context
  and float_t    = L.double_type context 
  and str_t      = L.pointer_type (L.i8_type context) in
  (* TODO: add more types as needed*)

  let tuple_t    = L.struct_type context [| str_t; str_t |] in
  let tuple_ptr_t  = L.pointer_type tuple_t in

  (* Define struct types *)
  let item_t = L.named_struct_type context "item" in
  let _ = L.struct_set_body item_t
    [| str_t; str_t; str_t; i32_t; i1_t; i32_t; i32_t; i1_t |] false in
  
  let item_ptr_t = L.pointer_type item_t in

  let node_t = L.named_struct_type context "node" in
  let _ = L.struct_set_body node_t
    [| str_t; i32_t; str_t; str_t; tuple_ptr_t; i32_t |] false in

  let chrctr_t = L.named_struct_type context "chrctr" in
  let _ = L.struct_set_body chrctr_t
    [| str_t; str_t; i32_t; i32_t; item_ptr_t |] false in

  let narr_t = L.named_struct_type context "narr" in
  let _ = L.struct_set_body narr_t
    [| str_t; str_t; str_t |] false in

  (* TODO: complete below if any type is missing  *)
  let ltype_of_typ = function
      TInt -> i32_t
    | TBool -> i1_t 
    | TFloat -> float_t
    | TString -> str_t
    | TNode -> node_t
    | TNar -> narr_t
    | TItem ->  item_t
    | TChar -> i8_t
    | TUnit -> void_t (* TODO: figure out what TUnit does *)
    | TTup (t1, t2)  -> L.struct_type context [| ltype_of_typ t1; ltype_of_typ t2 |]
    | TList (t) -> L.pointer_type (ltype_of_typ t)
  in

  (* Create a map of global variables after creating each *)
  let global_vars : L.llvalue StringMap.t =
    let global_var m (t, n) =
      let init = L.const_int (ltype_of_typ t) 0
      in StringMap.add n (L.define_global n init the_module) m in
    List.fold_left global_var StringMap.empty globals in

  let printf_t : L.lltype =
    L.var_arg_function_type i32_t [| L.pointer_type i8_t |] in
  let printf_func : L.llvalue =
    L.declare_function "printf" printf_t the_module in


  (* TODO: figure out how to handle module Symbol in sast *)

  (* Define each function (arguments and return type) so we can
     call it even before we've created its body *)
  (* let function_decls : (L.llvalue * sfunc_def) StringMap.t =
    let function_decl m fdecl =
      let name = fdecl.sfname
      and formal_types =
        Array.of_list (List.map (fun (t,_) -> ltype_of_typ t) fdecl.sformals)
      in let ftype = L.function_type (ltype_of_typ fdecl.srtyp) formal_types in
      StringMap.add name (L.define_function name ftype the_module, fdecl) m in
    List.fold_left function_decl StringMap.empty functions in *)

  (* Fill in the body of the given function *)
  let build_function_body fdecl =
    let (the_function, _) = StringMap.find fdecl.sfname function_decls in
    let builder = L.builder_at_end context (L.entry_block the_function) in

    let int_format_str = L.build_global_stringptr "%d\n" "fmt" builder in

    (* Construct the function's "locals": formal arguments and locally
       declared variables.  Allocate each on the stack, initialize their
       value, if appropriate, and remember their values in the "locals" map *)
    let local_vars =
      let add_formal m (t, n) p =
        L.set_value_name n p;
        let local = L.build_alloca (ltype_of_typ t) n builder in
        ignore (L.build_store p local builder);
        StringMap.add n local m

      (* Allocate space for any locally declared variables and add the
       * resulting registers to our map *)
      and add_local m (t, n) =
        let local_var = L.build_alloca (ltype_of_typ t) n builder
        in StringMap.add n local_var m
      in

      let formals = List.fold_left2 add_formal StringMap.empty fdecl.sformals
          (Array.to_list (L.params the_function)) in
      List.fold_left add_local formals fdecl.slocals
    in

    (* Return the value for a variable or formal argument.
       Check local names first, then global names *)
    let lookup n = try StringMap.find n local_vars
      with Not_found -> StringMap.find n global_vars
    in

    (* Construct code for an expression; return its value *)
    let rec build_expr builder ((_, e) : sexpr) = match e with
      SBinop (e1, op, e2) ->
        let e1' = build_expr builder e1
        and e2' = build_expr builder e2 in
        (match op with
           A.Add     -> L.build_add
         | A.Sub     -> L.build_sub
         | A.Mul     -> L.build_mul     (* TODO: check this works *)
         | A.Div     -> L.build_sdiv    (* TODO: check this works *)
         | A.Eq      -> L.build_icmp L.Icmp.Eq
         | A.Geq      -> L.build_icmp L.Icmp.Sge (* TODO: check this works *)
         | A.Leq      -> L.build_icmp L.Icmp.Sle (* TODO: check this works *)
         | A.Lt      -> L.build_icmp L.Icmp.Slt
         | A.Gt      -> L.build_icmp L.Icmp.Sgt (* TODO: check this works *)
        ) e1' e2' "tmp" builder
      | SUnop (e1, op)    -> 
        let e1' = build_expr builder e1 in
        (match op with
           A.Incr     -> L.build_add e1' (L.const_int i32_t 1)  (* TODO: check this works *)
         | A.Decr     -> L.build_sub e1' (L.const_int i32_t 1)  (* TODO: check this works *)
         | A.Not      -> L.build_not e1' (* TODO: check this works *)
        ) "tmp" builder
      | SIntLit i         -> L.const_int i32_t i
      | STextLit s        -> L.build_global_stringptr s "str" builder (* TODO: check this works *)
      | SBoolLit b        -> L.const_int i1_t (if b then 1 else 0)
      | SLabelLit s       -> L.build_global_stringptr s "label" builder
      | SFloatLit f       -> L.const_float float_t f
      | SVar sym          -> L.build_load (lookup sym.name) sym.name builder
      | SSeq args         ->
          let rec eval_seq = function
          | [] -> L.const_int i32_t 0
          | [e] -> build_expr builder e
          | e :: rest -> ignore (build_expr builder e); eval_seq rest
          in eval_seq args
      | STup (e1, e2)     ->
          let v1 = build_expr builder e1 in
          let v2 = build_expr builder e2 in
          L.const_struct context [| v1; v2 |]
      | SProcOpt (args, nd) -> 
            L.const_int i32_t 0  (* Useless now, just Placeholder *)
      | SAsn (sym, e1)    -> 
          let e1' = build_expr builder e1 in
          ignore (L.build_store e1' (lookup sym.name) builder); e1'(* TODO: check this works *)
      | SNar (narr)        ->
          let title_val = L.build_global_stringptr narr.title "title" builder in
          let root_val = L.build_global_stringptr narr.root "root" builder in
          let label_val = L.build_global_stringptr narr.narr_label "label" builder in
          let struct_val = L.build_malloc narr_t "narr" builder in
          let f0 = L.build_struct_gep struct_val 0 "f0" builder in
          let f1 = L.build_struct_gep struct_val 1 "f1" builder in
          let f2 = L.build_struct_gep struct_val 2 "f2" builder in
          ignore (L.build_store title_val f0 builder);
          ignore (L.build_store root_val f1 builder);
          ignore (L.build_store label_val f2 builder);
          struct_val
      | SItm (itm)        ->
          let var_val = L.build_global_stringptr item.var_name "var" builder in
          let name_val = L.build_global_stringptr item.iname "name" builder in
          let usage_val = L.build_global_stringptr item.usage "usage" builder in
          let num_val = L.const_int i32_t item.num in
          let uniq_val = L.const_int i1_t (if item.unique then 1 else 0) in
          let dur_val = L.const_int i32_t item.dur in
          let cost_val = L.const_int i32_t item.cost in
          let cons_val = L.const_int i1_t (if item.cons then 1 else 0) in
          let struct_val = L.build_malloc item_t "item" builder in
          let fields = List.mapi (L.build_struct_gep struct_val) [0;1;2;3;4;5;6;7] in
          List.iter2 (fun ptr v -> ignore (L.build_store v ptr builder)) fields
            [var_val; name_val; usage_val; num_val; uniq_val; dur_val; cost_val; cons_val];
          struct_val
      | SNde (nd)         -> 
        let char_val = L.build_global_stringptr node.character "character" builder in
        let id_val = L.const_int i32_t node.id in
        let dlg_val = L.build_global_stringptr node.dialogue "dialogue" builder in
        let lbl_val = L.build_global_stringptr node.label "label" builder in
        let opt_str = String.concat ";" (List.map (fun (a,b) -> a ^ ":" ^ b) node.options) in
        let opt_val = L.build_global_stringptr opt_str "opts" builder in
        let next_val = L.const_int i32_t node.next in
        let struct_val = L.build_malloc node_t "node" builder in
        let fields = List.mapi (L.build_struct_gep struct_val) [0;1;2;3;4;5] in
        List.iter2 (fun ptr v -> ignore (L.build_store v ptr builder)) fields
          [char_val; id_val; dlg_val; lbl_val; opt_val; next_val];
        struct_val
      | SNodeStream (s1, args, s2) -> 
          List.iter (fun e1 -> ignore (build_expr builder e1)) args;
          L.const_int i32_t 0
      | SCodeBlock (s1, args, s2) ->
          List.iter (fun e1 -> ignore (build_expr builder e1)) args;
          L.const_int i32_t 0
      | SNodeBlock (s1, args, s2) ->
          List.iter (fun e1 -> ignore (build_expr builder e1)) args;
          L.const_int i32_t 0
      | SChrc (chrctr)      -> 
          let var_val = L.build_global_stringptr chr.var_name "var" builder in
          let name_val = L.build_global_stringptr chr.name "name" builder in
          let lvl_val = L.const_int i32_t chr.level in
          let hp_val = L.const_int i32_t chr.hp in
          let inv_count = L.const_int i32_t (List.length chr.inventory) in
          let struct_val = L.build_malloc chrctr_t "chr" builder in
          let fields = List.mapi (L.build_struct_gep struct_val) [0;1;2;3;4] in
          List.iter2 (fun ptr v -> ignore (L.build_store v ptr builder)) fields
            [var_val; name_val; lvl_val; hp_val; inv_count];
          struct_val
      | SAddItem (s1, s2)   ->
          let _ = L.build_global_stringptr s1 "item" builder in
          let _ = L.build_global_stringptr s2 "target" builder in
          L.const_int i32_t 0
      | SIfExpr (cond, then_blk, elifs, else_blk) ->
        let cond_val = build_expr builder cond in
        let bool_val = L.build_icmp L.Icmp.Ne cond_val (L.const_int i1_t 0) "ifcond" builder in
        let then_bb = L.append_block context "then" the_function in
        let else_bb = L.append_block context "else" the_function in
        let merge_bb = L.append_block context "ifcont" the_function in
        ignore (L.build_cond_br bool_val then_bb else_bb builder);
        let _ = build_expr (L.builder_at_end context then_bb) (SSeq then_blk) in
        ignore (L.build_br merge_bb (L.builder_at_end context then_bb));
        let _ =
          match elifs, else_blk with
          | [], None -> ()
          | _, _ ->
            let builder = L.builder_at_end context else_bb in
            let _ =
              match elifs with
              | (elif_cond, elif_blk) :: _ ->
                let elif_val = build_expr builder elif_cond in
                let elif_bool = L.build_icmp L.Icmp.Ne elif_val (L.const_int i1_t 0) "elifcond" builder in
                let elif_bb = L.append_block context "elif" the_function in
                let _ = build_expr (L.builder_at_end context elif_bb) (SSeq elif_blk) in
                ignore (L.build_cond_br elif_bool elif_bb merge_bb builder)
              | [] ->
                match else_blk with
                | Some blk -> ignore (build_expr builder (SSeq blk))
                | None -> ()
            in
            ignore (L.build_br merge_bb builder)
        in
        L.position_at_end merge_bb builder; L.const_int i32_t 0
    in

    (* NOTE: code below is copied from example, not examined yet!!*)

    (* LLVM insists each basic block end with exactly one "terminator"
       instruction that transfers control.  This function runs "instr builder"
       if the current block does not already have a terminator.  Used,
       e.g., to handle the "fall off the end of the function" case. *)
    let add_terminal builder instr =
      match L.block_terminator (L.insertion_block builder) with
        Some _ -> ()
      | None -> ignore (instr builder) in

    (* Build the code for the given statement; return the builder for
       the statement's successor (i.e., the next instruction will be built
       after the one generated by this call) *)
    let rec build_stmt builder = function
      | SExpr e -> ignore(build_expr builder e); builder
      | SIf (predicate, then_stmt, else_stmt) ->
        let bool_val = build_expr builder predicate in

        let then_bb = L.append_block context "then" the_function in
        ignore (build_stmt (L.builder_at_end context then_bb) then_stmt);
        let else_bb = L.append_block context "else" the_function in
        ignore (build_stmt (L.builder_at_end context else_bb) else_stmt);

        let end_bb = L.append_block context "if_end" the_function in
        let build_br_end = L.build_br end_bb in (* partial function *)
        add_terminal (L.builder_at_end context then_bb) build_br_end;
        add_terminal (L.builder_at_end context else_bb) build_br_end;

        ignore(L.build_cond_br bool_val then_bb else_bb builder);
        L.builder_at_end context end_bb
    in
    (* Build the code for each statement in the function *)
    (* let func_builder = build_stmt builder (SBlock fdecl.sbody) in *)

    (* Add a return if the last block falls off the end *)
    add_terminal func_builder (L.build_ret (L.const_int i32_t 0))

  in

  List.iter build_function_body functions;
  the_module

