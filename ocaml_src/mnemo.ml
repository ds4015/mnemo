(* Mnemo Interpreter *)
(* Dallas - NB: This is functional; updates coming *)

open Ast
open Scanner
open Graphics

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

(*      
*********************************************
              Graphcis Functions 
*********************************************
*)

(* OCaml graphics - draw a rectangle *)
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

(* OCaml graphics - draw top status box *)
let gui_draw_status_box w h =
  Printf.printf "Called draw status box";
  let bc = rgb 108 88 76 in
  let fc = rgb 169 132 103 in
  gui_draw_rect 40 (size_y() - 70) w h bc fc

let delay seconds =
  let start = Sys.time () in
  while Sys.time () -. start < seconds do () done

(* OCaml graphics - fade status box *)
let gui_fade_rect x y w h steps fade_time =
  let bg_color = rgb 255 255 255 in 
  for i = 0 to steps do
    let color = rgb 
      (int_of_float (108. +. (float_of_int (255 - 108) /. float_of_int steps) *. float_of_int i))
      (int_of_float (88.  +. (float_of_int (255 - 88) /. float_of_int steps) *. float_of_int i))
      (int_of_float (76.  +. (float_of_int (255 - 76) /. float_of_int steps) *. float_of_int i)) in
    set_color color;
    fill_rect (x-1) (y-1) (w+4) (h+4);
    delay (fade_time /. float_of_int steps);
  done;
  set_color bg_color;
  fill_rect x y w h  



(* EVAL FUNCTION REDACTED - SEE SEMANT.ML *)



(* push Add Item to Inventory onto action queue *)
and add_item_to_queue queue v i =
      Queue.push (v,i) queue; 
         Printf.printf "Queue size: %d\n" (Queue.length action_queue);
      ValUnit



(*      
*********************************************
           More Graphics Functions 
*********************************************
*)

(* OCaml graphics - parameters for drawing boxes *)
type box_config =
  { 
    x: int;
    y: int;
    w: int;
    h: int;
    bw: int;
  }

(* OCaml graphics - alignment of text in boxes *)
type align =
  | Left
  | Center
  | Right

(* OCaml graphics - pause after a node prints: wait for input *)
let gui_pause () =
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

(* OCaml graphics - print text *)
let gui_print_text align s bcf col type_it_or_not =
  let lines = String.split_on_char '\n' s in
  let line_height = snd (text_size "Ay") in
  set_color col;
  List.iteri (fun i line ->
      let (w, h) = text_size line in

      let text_y = bcf.y + (((bcf.h - h)/2) - i * line_height) in

      let text_x = match align with
       | Center -> (bcf.x + (bcf.w - w)/2)
       | Right -> (bcf.x - 20) + bcf.w - w - bcf.bw - 1
       | Left -> (bcf.x + 20) + bcf.bw + 1
       in

       moveto text_x text_y;
       if type_it_or_not then 
         let rec typewrite i =

          let char_x = (bcf.x + (bcf.w - w)/2) in

          if i < String.length line then (
            moveto (char_x + (i * fst(text_size "a"))) text_y;
            draw_char line.[i];
            delay 0.05;
            typewrite (i + 1)
          )

         in
         typewrite 0

        else
          draw_string line
      ) lines

(* OCaml graphics - print node in dialogue box *)
let gui_print_node cname dial =
  let bc = rgb 214 198 154 in
  let fc = rgb 242 232 203 in
  gui_draw_rect 20 20 (size_x () - 51) 125 bc fc;
  set_text_size 3;
  let align = Center in
  let bconfig = { x = 20; y = 20; w = (size_x () - 51); h = 125; bw = 2 } in

  moveto (bconfig.x + 110) (bconfig.y + 80);
  set_color black;
  draw_string cname;
  let col = black in
  gui_print_text align dial bconfig col (1 + 1 = 2)


(* OCalm graphics - clear option when selection moved *)
let gui_clear_option x y w h i =
  let fc = rgb 240 219 161 in
  set_color fc;  
  fill_rect x (y - (i + 1) * 30) w 30;
  set_color black  

(* OCaml graphics - redraw option when selection moved *)
let gui_draw_option x y option index is_selected =
  let option_y = y - (index + 1) * 30 in
  if is_selected then (
    set_color (rgb 108 88 76);
    fill_rect x option_y 200 30;
    set_color white
  ) else (
    set_color black
  );
  moveto (x + 10) (option_y + 10);
  draw_string option

(* OCaml graphics - draw the box that holds options *)
let gui_draw_options_box w h =
  let bc = rgb 214 198 154 in
  let fc = rgb 240 219 161 in
  gui_draw_rect (size_x() - 51 - size_x() / 4) (size_y() - 255) w h bc fc

(* OCaml graphics - clear the box that holds options *)
let gui_clear_options_box w h =
  let bc = rgb 255 255 255 in
  let fc = rgb 255 255 255 in
  gui_draw_rect (size_x() - 51 - size_x() / 4) (size_y() - 255) w h bc fc

(* OCaml graphics - wait for input *)
let gui_check_key () =
  if key_pressed () then
    Some (read_key ())
  else
    None

(* OCaml graphics - options menu: wait for input *)
let gui_options_menu options =
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

(* OCaml graphics - return selected option [or quit] *)
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

(* add an item to character's inventory *)
let add_to_inv char item =
       let align = Center in
       let bconfig = { x = 40; y = (size_y() - 70); w = (size_x() - 100); h = 40; bw = 2 } in
    let c = try CharacterTable.find character_variables char 
      with Not_found -> failwith ("Character not found: " ^ char) in
    let i = try ItemTable.find item_variables item 
      with Not_found -> failwith ("Item not found: " ^ item) in 
    let item_data = match i with 
      | item_data -> item_data
    in
    (match c with 
     | c -> 
       c.inventory <- item_data :: c.inventory;
       gui_draw_status_box (size_x() - 100) 40;
       let s = c.name ^ " has acquired " ^ item_data.iname in
       let col = white in
       gui_print_text align s bconfig col (1 + 1 = 3);
       delay 2.;
       gui_fade_rect 40 (size_y() - 70) (size_x() - 100) 40 50 0.3;
       Inventory(c.inventory))

(* process nodes sequentially *)
let rec game_loop node_id =
  while not (Queue.is_empty action_queue) do
    let char_var, item_var = Queue.take action_queue in
    if char_var = "" then begin
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
      end else begin
        let _ = add_to_inv char_var item_var in
        ()
      end
    done


let start_game () =
  gui_init();
  let code_file = Sys.argv.(1) in
  parse_file code_file;
  (* extra action after all actions processed for Game Over print *)
  add_item_to_queue action_queue "" "";  
  game_loop 0

(* start game if not in utop *)
let _ = if not !Sys.interactive then
    start_game ();

  ignore (wait_next_event [Button_down]);
  close_graph ()