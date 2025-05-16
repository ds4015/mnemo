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
(* TODO: should it be (globals, functions) or something else? Is semantics.ml returning (globals, functions)? *)
let translate sexprs =
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
  let rec ltype_of_typ = function
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

  (* TODO: convert to semantic output, for now let's assume semantics.ml returns a list of sexprs (typ, sx) *)
  let builder = L.builder context in



  (* Let's create CHARACTER MAP - e.g alice : llvm_addr *)
  let global_chars : L.llvalue StringMap.t =
    (* helper to generate llvm value of character *)
    let gen_llvm_chr (builder : L.llbuilder) (charac : Ast.chrctr) =
      let var_name_val = L.build_global_stringptr charac.var_name "chr_var" builder in
      let name_val = L.build_global_stringptr charac.name "chr_name" builder in
      let level_val = L.const_int i32_t charac.level in
      let hp_val = L.const_int i32_t charac.hp in
      let inventory_val = L.const_null item_ptr_t in
      L.const_named_struct chrctr_t [| var_name_val; name_val; level_val; hp_val; inventory_val |]
  in
    (* function to allocate and load character from sexpr *)
    let rec collect_character_vars map (typ, sx) =
      match sx with
      | SAsn (symbol, (_, SChrc (var_name, name, level, hp, inventory))) ->
        let charac : Ast.chrctr = {
          var_name;
          name;
          level;
          hp;
          inventory;
        } in
        let llvm_chr = gen_llvm_chr builder charac in
        (* Allocate space for the character *)
        let addr = L.build_alloca (ltype_of_typ symbol.typ) symbol.name builder in
        (* Store llvm of char *)
        ignore (L.build_store llvm_chr addr builder);
        StringMap.add symbol.name addr map
    
      | SSeq exprs ->
          List.fold_left collect_character_vars map exprs
    
      | _ -> map
    in List.fold_left collect_character_vars StringMap.empty sexprs    (* TODO: don't know what how sast is returned, assuming you are given a list of sexprs  *)

  
  in

    (* Let's create NODE MAP of nodes that have labels - e.g label : llvm_addr *)
  let global_nodes : L.llvalue StringMap.t =
    (* helper to generate llvm value of a node *)
    let gen_llvm_node (builder : L.llbuilder) (node : Ast.node) =
      let character_val = L.build_global_stringptr node.character "node_char" builder in
      let id_val = L.const_int i32_t node.id in
      let dialogue_val = L.build_global_stringptr node.dialogue "node_dialogue" builder in
      let label_val = L.build_global_stringptr node.label "node_label" builder in
  
      (* Build option list: array of { i8*, i8* } tuples *)
      let option_vals = List.map (fun (s1, s2) ->
        let s1_val = L.build_global_stringptr s1 "opt1" builder in
        let s2_val = L.build_global_stringptr s2 "opt2" builder in
        L.const_struct context [| s1_val; s2_val |]
      ) node.options in
      

      let array_type = L.array_type tuple_t (List.length option_vals) in 
      let option_array = L.const_array tuple_t (Array.of_list option_vals) in (* generate llvm of options list *)
      let option_alloc = L.build_alloca array_type "option_arr" builder in  (* allocate space for options *)
      ignore (L.build_store option_array option_alloc builder);  (* store value of options onto stack *)
      let option_ptr = L.build_bitcast option_alloc tuple_ptr_t "opt_ptr" builder in
  
      let next_val = L.const_int i32_t node.next in
  
      L.const_named_struct node_t [|
        character_val;
        id_val;
        dialogue_val;
        label_val;
        option_ptr;
        next_val
      |]
    in
  
    (* function to allocate and load node from sexpr *)
    let rec collect_label_nodes map (typ, sx) =
      match sx with
      | SNde (character, id, dialogue, label, options, next) ->
        let node : Ast.node = {
          character;
          id;
          dialogue;
          label;
          options;
          next;
        } in
          let llvm_node = gen_llvm_node builder node in (* generate llvm of labeled node *)
          let addr = L.build_alloca node_t node.label builder in (* allocate space *)
          ignore (L.build_store llvm_node addr builder); (* store value of labeled node onto stack *)
          StringMap.add node.label addr map
  
      | SSeq exprs ->
          List.fold_left collect_label_nodes map exprs
  
      | _ -> map
    in
    List.fold_left collect_label_nodes StringMap.empty sexprs (* TODO: don't know what how sast is returned, assuming you are given a list of sexprs  *)
  

  in

  (* Functions for printing and scanning *)
  let printf_t : L.lltype =
    L.var_arg_function_type i32_t [| L.pointer_type i8_t |] in
  let printf_func : L.llvalue =
    L.declare_function "printf" printf_t the_module in

  let scanf_t = L.var_arg_function_type i32_t [| str_t |] in
  let scanf_func = L.declare_function "__isoc99_scanf" scanf_t the_module in


  (*  Functions to build instructions to print a node's dialogue *)
  let print_node_dialogue (builder : L.llbuilder) (node : Ast.node) =
      (* 1. Print dialogue *)
      let fmt_dialogue = L.build_global_stringptr "%s\n" "fmt_dialogue" builder in (* format of dialogue *)
      let dialogue_str = L.build_global_stringptr node.dialogue "dialogue_str" builder in  (* generate llvm code for node.dialogue *)
      ignore (L.build_call printf_func [| fmt_dialogue; dialogue_str |] "print_dialogue" builder); (* call printf to print out the dialogue*)

      (* If there are options, print and handle input *)
      if node.options <> [] then (
        (* 2. Print each option: "Option: <label>" *)
        List.iter (fun (label, _) ->
          let fmt_opt = L.build_global_stringptr "Option: %s\n" "fmt_opt" builder in
          let label_str = L.build_global_stringptr label "opt_label" builder in
          ignore (L.build_call printf_func [| fmt_opt; label_str |] "print_option" builder)
        ) node.options;

        (* 3. Prompt user for input *)
        let prompt_str = L.build_global_stringptr "Choose an option: " "prompt" builder in
        ignore (L.build_call printf_func [| prompt_str |] "print_prompt" builder);
      
        (* 4. Allocate a buffer for input (char[8]) *)
        let input_buf = L.build_alloca (L.array_type i8_t 8) "input_buf" builder in
        let input_ptr = L.build_gep input_buf [| L.const_int i32_t 0; L.const_int i32_t 0 |] "input_ptr" builder in
      
        (* 5. wait for user input *)
        let fmt_scanf = L.build_global_stringptr "%s" "scanf_fmt" builder in
        ignore (L.build_call scanf_func [| fmt_scanf; input_ptr |] "scanf_call" builder);      (* input_ptr now holds the user's input (e.g., "A") *)

        (* 6. Use the input to print the matching node from global_nodes *)
        (* Because input is compiled at runtime, we can't use StringMap.find *)
        (* We need to compare input_ptr with each label key in GLOBAL_NODES *)
        let strcmp_t = L.function_type i32_t [| str_t; str_t |] in
        let strcmp_func = L.declare_function "strcmp" strcmp_t the_module in

        (* Find and print the matched node *)
        StringMap.iter (fun label node_ptr ->
          let label_str = L.build_global_stringptr label "label_str" builder in 
          let cmp = L.build_call strcmp_func [| input_ptr; label_str |] "cmp" builder in  (* generate llvm code to cmp values *)
          let is_match = L.build_icmp L.Icmp.Eq cmp (L.const_int i32_t 0) "match" builder in (* cmp input_ptr and label *)

          let parent = L.block_parent (L.insertion_block builder) in
          let then_bb = L.append_block context "then_print" parent in (* create a then block for when they match *)
          let cont_bb = L.append_block context "cont" parent in

          ignore (L.build_cond_br is_match then_bb cont_bb builder);

          let then_builder = L.builder_at_end context then_bb in  (* create a builder for then_block *)
          let dialogue_ptr = L.build_struct_gep node_ptr 2 "dialogue_ptr" then_builder in (* getting the dialogue (index 2) of node struct *)
          let dialogue_val = L.build_load dialogue_ptr "dialogue_val" then_builder in
          let fmt = L.build_global_stringptr "%s\n" "fmt_str" then_builder in
          ignore (L.build_call printf_func [| fmt; dialogue_val |] "printf_call" then_builder);
          ignore (L.build_br cont_bb then_builder); (* have then_block jump to cont_bb block after printing *)

          ignore (L.position_at_end cont_bb builder) (* move main builder's cursor to the end of cont_bb block *)
        ) global_nodes;
      ) in
    
  
  (* function to iterate over list of sexpr *)
  let rec emit_dialogues builder sexprs =
    List.iter (fun (_, sx) ->
      match sx with
      | SNde (character, id, dialogue, label, options, next) ->
          let node : Ast.node = {
            character;
            id;
            dialogue;
            label;
            options;
            next;
          } in
          print_node_dialogue builder node
  
      | SSeq exprs ->
          emit_dialogues builder exprs
  
      | _ -> ()
    ) sexprs in
  
  emit_dialogues builder sexprs; (* generate ir_code over all the nodes in sexprs *)

  the_module