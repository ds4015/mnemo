(* Mnemo Interpreter *)
(* Dallas - NB: This is functional; updates coming *)

open Ast
open Scanner
open Graphics

exception Quit

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
    in
    (match c with 
     | c -> 
       c.inventory <- item_data :: c.inventory;
       Printf.printf "%s was added to %s's inventory" item_data.iname c.name;
       Inventory(c.inventory))


type box_config =
  { 
    x: int;
    y: int;
    w: int;
    h: int;
    bw: int;
  }

type align =
  | Left
  | Center
  | Right

let gui_draw_rect x0 y0 w h bc fc =
  let bcolor = bc in
  set_color bcolor;
  set_line_width 3;
  let (a,b) = current_point() in
  let x1 = x0 + w in
  let y1 = y0 + h in
  moveto x0 y0;
  lineto x0 y1; lineto x1 y1;
  lineto x1 y0; lineto x0 y0;
  moveto a b;
  let fcolor = fc in
  set_color fcolor;
  fill_rect (x0+1) (y0+1) (w-2) (h-2);
  synchronize ()

let delay seconds =
  let start = Sys.time () in
  while Sys.time () -. start < seconds do () done

let gui_pause () =
  Printf.printf "pause called\n";
  let rec flash count =
    moveto (size_x () - 50) 50;
    if not (key_pressed ()) then (
      if count mod 2 = 0 then (
        let bc = rgb 171 166 121 in
        let fc = rgb 171 166 121 in
        gui_draw_rect (size_x() - 70) 40 10 20 bc fc     
      ) else (
        let bc = rgb 242 232 203 in
        let fc = rgb 242 232 203 in
        gui_draw_rect (size_x() - 70) 40 10 20 bc fc
      );
      delay 0.3;
      flash (count + 1)) else (
      let bc = rgb 242 232 203 in
      let fc = rgb 242 232 203 in
      gui_draw_rect (size_x() - 70) 40 10 20 bc fc
    )
  in
  flash 0

let gui_print_node cname dial =
  Printf.printf "Print node called\n";
  Printf.printf "Name: %s\n" cname;
  let bc = rgb 214 198 154 in
  let fc = rgb 242 232 203 in
  gui_draw_rect 20 20 (size_x () - 51) 125 bc fc;
  set_text_size 3;
  let bconfig = { x = 20; y = 20; w = (size_x () - 51); h = 125; bw = 2 } in
  let color = black in
  let align = Center in
  let lines = String.split_on_char '\n' dial in
  let line_height = snd (text_size "Ay") in

  moveto (bconfig.x + 110) (bconfig.y + 80);
  set_color black;
  draw_string cname;

  List.iteri (fun i line ->
      let (w, h) = text_size line in
      let text_y = bconfig.y + (((bconfig.h - h)/2) - i * line_height) in
      (match align with
         Center -> let text_x = (bconfig.x + (bconfig.w - w)/2) in moveto text_x text_y
       | Right -> let text_x = (bconfig.x - 20) + bconfig.w - w - bconfig.bw - 1 in moveto text_x text_y
       | Left -> let text_x = (bconfig.x + 20) + bconfig.bw + 1 in moveto text_x text_y);
      set_color color;
      let rec typewrite i =
        let char_x = (bconfig.x + (bconfig.w - w)/2) in
        if i < String.length line then (                
          moveto (char_x + (i * fst(text_size "a"))) text_y;
          draw_char line.[i];
          delay 0.05;
          typewrite (i + 1)
        ) in typewrite 0) lines

let gui_clear_option x y w h i =
  let fc = rgb 240 219 161 in
  set_color fc;  
  fill_rect x (y - (i + 1) * 30) w 30;
  set_color black  

let gui_draw_option x y option index is_selected =
  let option_y = y - (index + 1) * 30 in
  if is_selected then (
    set_color blue;
    fill_rect x option_y 200 30;
    set_color white
  ) else (
    set_color black
  );
  moveto (x + 10) (option_y + 10);
  draw_string option            

let gui_draw_options_box w h =
  let bc = rgb 214 198 154 in
  let fc = rgb 240 219 161 in
  gui_draw_rect (size_x() - 51 - size_x() / 4) (size_y() - 255) w h bc fc

let gui_clear_options_box w h =
  let bc = rgb 255 255 255 in
  let fc = rgb 255 255 255 in
  gui_draw_rect (size_x() - 51 - size_x() / 4) (size_y() - 255) w h bc fc

let gui_check_key () =
  if key_pressed () then
    Some (read_key ())
  else
    None

(* options menu loop *)
let gui_options_menu options =
  Printf.printf "Called gui_options_menu\n";
  let selected_index = ref 0 in
  let x =  (size_x() - 51 - size_x() / 4) in
  let y = (size_y() - 255) in
  let box_width = 200 in
  let box_height = 30 * List.length options in

  set_color black;
  gui_draw_options_box box_width box_height;

  List.iteri (fun i option ->
      gui_draw_option x (y + box_height) option i (i = !selected_index)
    ) options;
  synchronize ();

  let rec loop () =
    match gui_check_key () with
    | Some 'q' | Some '\027' -> raise Quit
    | Some '\013' -> gui_clear_options_box box_width box_height; !selected_index
    | Some 'w' | Some 'W' ->  
      gui_clear_option x (y + box_height) box_width box_height !selected_index;
      gui_draw_option x (y + box_height) (List.nth options !selected_index) !selected_index false;
      selected_index := (!selected_index - 1 + List.length options) mod List.length options;
      gui_draw_option x (y + box_height) (List.nth options !selected_index) !selected_index true;
      synchronize ();
      loop ()
    | Some 's' | Some 'S' ->  
      gui_clear_option x (y + box_height) box_width box_height !selected_index;
      gui_draw_option x (y + box_height) (List.nth options !selected_index) !selected_index false;        
      selected_index := (!selected_index + 1) mod List.length options;
      gui_draw_option x (y + box_height) (List.nth options !selected_index) !selected_index true;
      synchronize ();
      loop ()
    | _ ->
      delay 0.01;
      loop ()
  in
  loop ()

let rec gui_proc_opt cname options =
  while key_pressed () do ignore (read_key ()) done;
  try
    let selected_index = gui_options_menu options in
    selected_index
  with
  | Quit ->
    gui_print_node cname "You didn't choose anything!";
    gui_proc_opt cname options


let gui_init () = 
  open_graph ""


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
let process_options options n cname =
  let opts = List.mapi (fun idx (option_text, _) -> option_text) options in
  let choice = gui_proc_opt cname opts + 1 in

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


(* process nodes sequentially *)
let rec game_loop node_id =
  match NodeTable.find_opt nodes node_id with
  | None -> gui_print_node "" "Game Over"
  | Some node -> gui_print_node node.character node.dialogue; 
    if node.options <> [] then begin
      process_options node.options node node.character;
      game_loop node.next
    end else begin
      while key_pressed () do ignore (read_key ()) done;
      gui_pause ();
      game_loop node.next
    end

let start_game () =
  let code_file = Sys.argv.(1) in
  parse_file code_file;
  gui_init();
  game_loop 0

(* start game if not in utop *)
let _ = if not !Sys.interactive then
    start_game ();

  ignore (wait_next_event [Button_down]);
  close_graph ()