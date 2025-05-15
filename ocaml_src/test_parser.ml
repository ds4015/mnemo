open Ast
(* 
st *)

let () =
  let filename = "example.mc" in
  let in_chan = open_in filename in
  let lexbuf = Lexing.from_channel in_chan in
  try
    let program = Parser.exprs_rule Scanner.token lexbuf in
    (* Replace this with actual processing logic *)
    print_endline (string_of_program program)
  with
  | Parsing.Parse_error ->
      let pos = lexbuf.lex_curr_p in
      Printf.eprintf "Syntax error at line %d, column %d\n"
        pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1);
      exit 1