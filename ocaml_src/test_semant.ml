(* test_semant.ml *)

open Ast
open Sast
open Semant2

let () =
  let code_ast = CodeBlock (
    "CODE_BLOCK",
    [ IntLit 1; Binop (IntLit 2, Add, IntLit 3) ],
    "END_CODE_BLOCK"
  ) in
  let (t_cb, sx_cb) = Semant2.check_expr code_ast in
  print_endline "=== CodeBlock test ===";
  print_endline (Sast.string_of_sexpr (t_cb, sx_cb));

  let sample_node : Ast.node = {
    character = "Alice";
    id        = 42;
    dialogue  = "Hello, world!";
    label     = "start";
    options   = [("Go", "next")];
    next      = 43
  } in
  let node_ast = NodeBlock (
    "NODE_BLOCK",
    [ Nde sample_node ],
    "END_NODE_BLOCK"
  ) in
  let (t_nb, sx_nb) = Semant2.check_expr node_ast in
  print_endline "\n=== NodeBlock test ===";
  print_endline (Sast.string_of_sexpr (t_nb, sx_nb));

  let stream_ast = NodeStream (
    "NODES_BLOCK",
    [ Nde sample_node; Nde { sample_node with id = 43; next = 44 } ],
    "END_NODES_BLOCK"
  ) in
  let (t_ns, sx_ns) = Semant2.check_expr stream_ast in
  print_endline "\n=== NodeStream test ===";
  print_endline (Sast.string_of_sexpr (t_ns, sx_ns))
