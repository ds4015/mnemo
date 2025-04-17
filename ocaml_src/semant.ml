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
    let it = { iname; usage; num; unique; dur; cost; cons } in
    ItemTable.add item_variables var_name it; 
    Item(it)
  | Chrc (var_name, name, level, hp, inventory) -> 
    let chr = { name; level; hp; inventory } in
    CharacterTable.add character_variables var_name chr;
    Character(chr) 
  | Nde (character, id, dialogue, label, options, next) ->
    add_item_to_queue action_queue "" "";
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
     | AddItem (v, item_expr) ->
        add_item_to_queue action_queue v item_expr