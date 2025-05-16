(* Mnemo Interpreter *)
(* Dallas - NB: This is functional; updates coming *)

open Ast
open Scanner
exception Quit


(*      
*********************************************
                Data Structures 
*********************************************
*)
module Q = Queue
let action_queue : (string * string) Queue.t = Q.create ()

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

(* EVAL FUNCTION REDACTED - SEE SEMANT.ML *)



(* push Add Item to Inventory onto action queue *)
and add_item_to_queue queue v i =
      Queue.push (v,i) queue; 
         Printf.printf "Queue size: %d\n" (Queue.length action_queue);
      ValUnit

(*      
*********************************************
           Interactive Terminal
*********************************************
*)
  
(* Display option node to terminal *)
let rec terminal_proc_opt cname options =
  List.iteri (fun i (opt_text, _) ->
    Printf.printf "Option %d: %s\n" (i + 1) opt_text
  ) options;
  Printf.printf "\nPlease enter a number (1-%d): " (List.length options);
  try
    let choice = read_line () |> int_of_string in
    if choice >= 1 && choice <= List.length options then choice - 1
    else (
      Printf.printf "Invalid choice, try again.\n";
      terminal_proc_opt cname options
    )
  with _ ->
    Printf.printf "Invalid input, try again.\n";
    terminal_proc_opt cname options
    
(* Display dialogue node to terminal *)
let terminal_print_node cname dial =
  Printf.printf "\n%s: %s\n\n" cname dial

let terminal_pause () =
  Printf.printf "(Press ENTER to continue...)\n";
  ignore (read_line ())

(*      
*********************************************
                 Game Logic 
*********************************************
*)

(* kill all branches not chosen for option *)
let kill_dead_branch l =
  NodeTable.iter (fun _ node ->
      if node.label = l then (
        NodeTable.remove nodes node.id;
        node.id <- -1;
        NodeTable.add nodes node.id node
      )
    ) nodes

(* process options after a branch *)       
let process_options options n cname =
  let opts = List.mapi (fun idx (option_text, _) -> option_text) options in
  let choice = terminal_proc_opt cname opts + 1 in

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

(* add an item to character's inventory *)
let add_to_inv char item =
  let c = try CharacterTable.find character_variables char 
    with Not_found -> failwith ("Character not found: " ^ char) in
  let i = try ItemTable.find item_variables item 
    with Not_found -> failwith ("Item not found: " ^ item) in
  c.inventory <- i :: c.inventory;
  Printf.printf "\n%s has acquired %s.\n\n" c.name i.iname;
  Inventory(c.inventory)

(* process nodes sequentially *)
let rec game_loop node_id =
  while not (Queue.is_empty action_queue) do
    let char_var, item_var = Queue.take action_queue in
    if char_var = "" then begin
      match NodeTable.find_opt nodes node_id with
      | None -> terminal_print_node "" "Game Over"
      | Some node -> terminal_print_node node.character node.dialogue; 
        if node.options <> [] then begin
          process_options node.options node node.character;
          game_loop node.next
        end else begin
          terminal_pause ();
          game_loop node.next
        end
      end else begin
        let _ = add_to_inv char_var item_var in
        ()
      end
    done


let start_game () =
  let code_file = Sys.argv.(1) in
  parse_file code_file;
  (* extra action after all actions processed for Game Over print *)
  add_item_to_queue action_queue "" "";  
  game_loop 0

(* start game if not in utop *)
let _ = if not !Sys.interactive then
    start_game ();
