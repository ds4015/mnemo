(* main.ml *)
open Ast
open Sast
open Semant 
open Scanner
module Ir = Irgen

let () =
  if Array.length Sys.argv <> 3 then begin
    prerr_endline "Usage: mnemo <input.mnemo> <output.ll>";
    exit 1
  end;
  let in_file  = Sys.argv.(1) in
  let out_file = Sys.argv.(2) in


  let ic = open_in in_file in

  let lexbuf = Lexing.from_channel ic in
	let ast_expr =
	try Parser.exprs_rule Scanner.token lexbuf
	with Parser.Error ->
		let pos   = lexbuf.Lexing.lex_curr_p in
		let tok   = Lexing.lexeme lexbuf in
		let line  = pos.Lexing.pos_lnum in
		let col   = pos.Lexing.pos_cnum - pos.Lexing.pos_bol in
		Printf.eprintf
		"Parse error at line %d, char %d: unexpected token `%s`\n%!"
		line col tok;
		exit 1
	in

  close_in ic;

  let program =
    match ast_expr with
    | Seq exprs -> exprs
    | _ -> failwith "expected Seq at top level"
  in

  let globals = [] in
  let (_g, sprogram) = Semant.check (globals, program) in

  let llmod = Ir.translate (globals, sprogram) in

  let oc = open_out out_file in
  output_string oc (Llvm.string_of_llmodule llmod);
  close_out oc