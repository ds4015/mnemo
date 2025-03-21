(* Mnemo Interpreter *)
(* Dallas - NB: This is functional; updates coming *)

open Ast
open Scanner

(* variable tables: var_name, object *)
module NarrativeTable = Hashtbl.Make(struct
  type t = string
  let equal = String.equal
  let hash = Hashtbl.hash
end)

module ItemTable = Hashtbl.Make(struct
  type t = string
  let equal = String.equal
  let hash = Hashtbl.hash
end)

module CharacterTable = Hashtbl.Make(struct
  type t = string
  let equal = String.equal
  let hash = Hashtbl.hash
end)

(* node table: node_id, node_object *)
module NodeTable = Hashtbl.Make(struct
  type t = int
  let equal = Int.equal
  let hash = Hashtbl.hash
end)

let narrative_variables = NarrativeTable.create 10
let item_variables = ItemTable.create 10
let character_variables = CharacterTable.create 10
let nodes = NodeTable.create 10

let rec eval expr =
  match expr with
  | IntLit(i) -> Int(i)
  | BoolLit(b) -> Bool(b)
  | LabelLit(l) -> Label(l)
  | FloatLit(f) -> Float(f)
  | TextLit(t) -> Text(t)
  | CodeBlock (_, exprs, _) -> 
    (match List.rev_map eval exprs with
     | [] -> failwith "Empty block"
     | last :: _ -> last)
  | NodeBlock (_, node, _) -> 
      (match List.rev_map eval node with
     | [] -> failwith "Empty block"
     | last :: _ -> last)
  | NodeStream (_, nodes, _) -> 
      (match List.rev_map eval nodes with
     | [] -> failwith "Empty block"
     | last :: _ -> last)
  | Nar (var_name, title, root, narr_label) -> 
      let narr = { title; root; narr_label } in
      NarrativeTable.add narrative_variables var_name narr; 
      Narrative(narr)
  | Itm (var_name, iname, usage, num, unique, dur, cost, cons) -> 
      Printf.printf "Creating Item: Name=%s, Usage=%s\n" iname usage;
      let it = { iname; usage; num; unique; dur; cost; cons } in
      ItemTable.add item_variables var_name it; 
      Item(it)
  | Chrc (var_name, name, level, hp, inventory) -> 
      let chr = { name; level; hp; inventory } in
      CharacterTable.add character_variables var_name chr;
      Character(chr) 
  | Nde (character, id, dialogue, label, options, next) ->
     let true_name = ref character in
      CharacterTable.iter (fun var char ->
            if var = character then 
              true_name := char.name else ()
          ) character_variables;
      let nd = { character = !true_name; id; dialogue; label; options; next } in
      NodeTable.add nodes id nd;
      ProcOpt (options, nd);
      Node(nd)
  | Var(v) -> 
    (try 
      let i = ItemTable.find item_variables v in
      Item i
    with Not_found -> 
      try 
        let c = CharacterTable.find character_variables v in
        Character c
      with Not_found -> 
        try 
          let n = NarrativeTable.find narrative_variables v in
          Narrative n
        with Not_found -> 
          failwith ("Variable not found in any table: " ^ v))
  | Asn (e1, e2) -> let v2 = eval e2 in v2
  | Seq(exprs) ->
      let rec eval_seq = function
        | [] -> failwith "Empty sequence has no value"
        | [e] -> eval e
        | e :: rest -> 
            let _ = eval e in
            eval_seq rest
      in
      eval_seq exprs
  | Tup (e1, e2) -> let v1 = eval e1 and v2 = eval e2 in 
     (match v1, v2 with
     | Text s1, Label s2 -> Tuple(s1, s2)
     | _ -> failwith "Invalid types for Tup")
  | Binop (e1, op, e2) ->
      let v1 = eval e1 and v2 = eval e2 in
      (match op with
      | Add -> (match v1, v2 with
                | Int i1, Int i2 -> Int(i1 + i2)
                | _ -> failwith "Invalid types for addition")
      | Sub -> (match v1, v2 with
                | Int i1, Int i2 -> Int(i1 - i2)
                | _ -> failwith "Invalid types for subtraction")
      | Mul -> (match v1, v2 with
                | Int i1, Int i2 -> Int(i1 * i2)
                | _ -> failwith "Invalid types for multiplication")
      | Div ->  if v2 == Int(0) then failwith "Cannot divide by zero" else
                (match v1, v2 with
                | Int i1, Int i2 -> Int(i1 / i2)
                | _ -> failwith "Invalid types for division")
      | Eq -> (match v1, v2 with
                | Int i1, Int i2 -> Bool(i1 == i2)
                | Float f1, Float f2 -> Bool(f1 == f2)
                | Int i1,  Float f2 -> Bool(float_of_int i1 == f2)
                | Float f1, Int i2 -> Bool(f1 == float_of_int i2)
                | _ -> failwith "Invalid types for comparison")
      | Gt -> (match v1, v2 with
                | Int i1, Int i2 -> Bool(i1 > i2)
                | Float f1, Float f2 -> Bool(f1 > f2)
                | Int i1,  Float f2 -> Bool(float_of_int i1 > f2)
                | Float f1, Int i2 -> Bool(f1 > float_of_int i2)
                | _ -> failwith "Invalid types for comparison")
      | Lt -> (match v1, v2 with
                | Int i1, Int i2 -> Bool(i1 < i2)
                | Float f1, Float f2 -> Bool(f1 < f2)
                | Int i1,  Float f2 -> Bool(float_of_int i1 < f2)
                | Float f1, Int i2 -> Bool(f1 < float_of_int i2)
                | _ -> failwith "Invalid types for comparison")
      | Geq -> (match v1, v2 with
                | Int i1, Int i2 -> Bool(i1 >= i2)
                | Float f1, Float f2 -> Bool(f1 >= f2)
                | Int i1,  Float f2 -> Bool(float_of_int i1 >= f2)
                | Float f1, Int i2 -> Bool(f1 >= float_of_int i2)
                | _ -> failwith "Invalid types for comparison")
      | Leq -> (match v1, v2 with
                | Int i1, Int i2 -> Bool(i1 <= i2)
                | Float f1, Float f2 -> Bool(f1 <= f2)
                | Int i1,  Float f2 -> Bool(float_of_int i1 <= f2)
                | Float f1, Int i2 -> Bool(f1 <= float_of_int i2)
                | _ -> failwith "Invalid types for comparison"))
  | Unop (e, op) ->
      let v = eval e in
      (match op with
      | Incr -> (match v with
         | Int i -> Int(i + 1)
         | _ -> failwith "Can only increment ints")
      | Decr -> (match v with
         | Int i -> Int(i - 1)
         | _ -> failwith "Can only decrement ints and floats")
      | Not -> (match v with
        | Bool b -> Bool(not b)
        | Int i -> Bool(i = 0)
        | Float f -> Bool(f = 0.0)
        | Text t -> Bool(t = "")
        | Label l -> Bool(l = "")
        | _ -> failwith "Invalid type for negation"))
  | AddItem(v, item) -> 
      let c = try CharacterTable.find character_variables v 
        with Not_found -> failwith ("Character not found: " ^ v) in
      let i = try ItemTable.find item_variables item 
        with Not_found -> failwith ("Item not found: " ^ item) in 
      let item_data = match i with 
          | item_data -> item_data
          | _ -> failwith (item ^ " is not an item; cannot add it to inventory.") 
      in
      (match c with 
       | c -> 
            c.inventory <- item_data :: c.inventory;
            Printf.printf "%s was added to %s's inventory" item_data.iname c.name;
            Inventory(c.inventory)
       | _ -> failwith (v ^ " is not a character; cannot add item."))

  (* kill all branches not chosen for option *)
  let kill_dead_branch l =
    NodeTable.iter (fun _ node ->
        if node.label = l then (
          Printf.printf "Killing branch with label %s\n" l;
          NodeTable.remove nodes node.id;
          node.id <- -1;
          NodeTable.add nodes node.id node
        )
      ) nodes

  (* process options after a branch *)       
  let process_options options n =
        Printf.printf "Options:\n";
        List.mapi (fun idx (option_text, next_label) ->
            Printf.printf "\t%d. %s\n" (idx + 1) option_text
        ) options;

        Printf.printf "\nChoose: ";
        let choice = read_int() in

        if choice < 1 || choice > List.length options then
            failwith "Invalid choice." else

        let next_label = snd (List.nth options (choice - 1)) in
        
        let found = 
            NodeTable.fold (fun _ node acc ->
                if node.label = next_label then Some node else acc
            ) nodes None in
        match found with
            | Some node -> 
                n.next <- node.id;
                List.iteri (fun idx opt ->
                  let label = snd opt in
                  if idx <> (choice - 1) then kill_dead_branch label else ()
                ) options;
               Int node.id
            | None -> failwith ("Node with label " ^ next_label ^ " not found.")

(* open game file and parse it *)
let parse_file filename =
  let ic = open_in filename in
  let lexbuf = Lexing.from_channel ic in
  try
    let parsed = Parser.exprs_rule Scanner.token lexbuf in
    close_in ic;
    let result = eval parsed in result
  with e ->
    close_in ic;
    raise e

(* pause between dialogues *)
let pause () =
	print_endline "Press any key to continue...";
	ignore (read_line ())

(* process nodes sequentially *)
let rec game_loop node_id =
	match NodeTable.find_opt nodes node_id with
	| None -> print_endline "Game over."
	| Some node ->
		print_endline "+==========================================================+\n";
    print_string "\t";
    print_string node.character;
    print_string ":\n";
    print_string "\t\t";
    print_endline node.dialogue;
		print_endline "\n+==========================================================+\n\n";    
  if node.options <> [] then begin
    process_options node.options node;
    game_loop node.next
  end else begin
    pause ();
    game_loop node.next
  end

let start_game () =
	let code_file = Sys.argv.(1) in
	parse_file code_file;
	game_loop 0

(* start game if not in utop *)
let _ = if not !Sys.interactive then
    start_game ()