(* Mnemo Scanner *)
(* Dallas - NB: This is functional *)

{
open Buffer
open Parser

let buffer = Buffer.create 256

let bool_of_string s =
 match String.lowercase_ascii s with
    | "true" -> true
    | "false" -> false
    | "True" -> true
    | "False" -> false
    | _ -> failwith "Invalid boolean string"

(* convert tokens to string for printout - debug *)
let string_of_token = function
    | PLUS -> "PLUS"
    | MINUS -> "MINUS"
    | TIMES -> "TIMES"
    | DIVIDE -> "DIVIDE"
    | PLUSEQ -> "PLUSEQ"
    | MINUSEQ -> "MINUSEQ"
    | MULTEQ -> "MULTEQ"
    | DIVEQ -> "DIVEQ"
    | PLUSPLUS -> "PLUSPLUS"
    | MINUSMINUS -> "MINUSMINUS"
    | NOT -> "NOT"
    | OR -> "OR"
    | AND -> "AND"
    | TRUE -> "TRUE"
    | FALSE -> "FALSE"
    | COLON -> "COLON"
    | DOT -> "DOT"
    | QUESTMARK -> "QUESTMARK"
    | COMMA -> "COMMA"
    | LPAREN -> "LPAREN"
    | RPAREN -> "RPAREN"
    | LBRACKET -> "LBRACKET"
    | RBRACKET -> "RBRACKET"
    | EQ -> "EQ"
    | IS -> "IS"
    | LT -> "LT"
    | GT -> "GT"
    | LTE -> "LTE"
    | GTE -> "GTE"
    | IF -> "IF"
    | ELSE -> "ELSE"
    | ELIF -> "ELIF"
    | RETURN -> "RETURN"
    | NARRATIVE -> "NARRATIVE"
    | CHARACTER -> "CHARACTER"
    | ITEM -> "ITEM"
    | NODE_BLOCK -> "NODE_BLOCK"
    | NODES_BLOCK -> "NODES_BLOCK"
    | END_NODE_BLOCK -> "END_NODE_BLOCK"
    | END_NODES_BLOCK -> "END_NODES_BLOCK"
    | NEXT -> "NEXT"
    | LABEL -> "LABEL"
    | HP -> "HP"
    | LEVEL -> "LEVEL"
    | INVENTORY -> "INVENTORY"
    | ROOT -> "ROOT" 
    | NARR_LABEL -> "NARR_LABEL" 
    | TITLE -> "TITLE"
    | CODE_BLOCK -> "CODE_BLOCK"
    | END_CODE_BLOCK -> "END_CODE_BLOCK"
    | VARIABLE s -> "VARIABLE(" ^ s ^ ")"
    | INT_LITERAL i -> "INT_LITERAL(" ^ string_of_int i ^ ")"
    | FLOAT_LITERAL f -> "FLOAT_LITERAL(" ^ string_of_float f ^ ")"
    | TEXT_LITERAL t -> "TEXT_LITERAL(" ^ t ^ ")"
    | LABEL_LITERAL l -> "LABEL_LITERAL(" ^ l ^ ")"
    | BOOL_LITERAL b -> "BOOL_LITERAL(" ^ string_of_bool b ^ ")"
    | ADD -> "ADD"
    | REMOVE -> "REMOVE"
    | AT -> "AT"
    | OPTION -> "OPTION"
    | EOF -> "EOF"
    | EOL -> "EOL"
    | EXCLMPT -> "EXCLMPT"
}

rule token =
    parse
    (* whitespace *)
    | [' ' '\n' '\r']                        { token lexbuf }
    | "eol"                                  { EOL }

    (* literals *)
    | ['1'-'9']['0'-'9']* as i              { INT_LITERAL (int_of_string i)}
    | ('0' | ['1'-'9']['0'-'9']*) '.' 
      ['0'-'9']+ as f                       { FLOAT_LITERAL (float_of_string f) }
    | ('0' | ['1'-'9']['0'-'9']*) 
      '.' as f                              { FLOAT_LITERAL (float_of_string f) }   
    | '.' ['0'-'9']+ as f                   { FLOAT_LITERAL (float_of_string f) }
    | ['!'](['a'-'z' 'A'-'Z'] | 
      ['0'-'9'] | '_')* as id               { LABEL_LITERAL (id) }
    | "true" as b                           { BOOL_LITERAL (bool_of_string b) }
    | "false" as b                          { BOOL_LITERAL (bool_of_string b) }
    | "True" as b                           { BOOL_LITERAL (bool_of_string b) }
    | "False" as b                          { BOOL_LITERAL (bool_of_string b) }

    (* arithmetic operators *)
    | "+"                                   { PLUS } 
    | "−"                                   { MINUS }
    | "*"                                   { TIMES }
    | "/"                                   { DIVIDE }
    | "+="                                  { PLUSEQ }
    | "-="                                  { MINUSEQ }
    | "*="                                  { MULTEQ }
    | "/="                                  { DIVEQ }
    | "."                                   { DOT }

    (* keywords *)
    | "Narrative"                           { NARRATIVE }
    | "Character"                           { CHARACTER }
    | "Item"                                { ITEM }
    | "/node"                               { NODE_BLOCK }
    | "/end_node"                           { END_NODE_BLOCK }
    | "/nodes"                              { NODES_BLOCK }
    | "/end_nodes"                          { END_NODES_BLOCK }
    | "next="                               { NEXT }
    | "label="                              { LABEL }
    | "="                                   { EQ }
    | "hp="                                 { HP }
    | "level="                              { LEVEL }
    | "inventory"                           { INVENTORY }
    | "root="                               { ROOT }
    | "narr_label="                         { NARR_LABEL }
    | "title="                              { TITLE }
    | "/code"                               { CODE_BLOCK }
    | "/end_code"                           { END_CODE_BLOCK }
    | "option"                              { OPTION }
    | "add"                                 { ADD }
    | "remove"                              { REMOVE }

    (* separators *)
    | "@"                                   { AT }
    | "!"                                   { EXCLMPT }
    | ":"                                   { COLON }
    | "?"                                   { QUESTMARK }
    | ","                                   { COMMA }
    | "("                                   { LPAREN }
    | ")"                                   { RPAREN }
    | "["                                   { LBRACKET }
    | "]"                                   { RBRACKET }

    (* flow control *)
    | "if"                                  { IF }
    | "else"                                { ELSE }
    | "elif"                                { ELIF }
    | "return"                              { RETURN }    

    (* boolean operators *)
    | "^"                                   { AND }
    | "<>"                                  { OR }
    | "true"                                { TRUE }
    | "false"                               { FALSE }
    
    (* unary operators *)
    | "++"                                  { PLUSPLUS }
    | "--"                                  { MINUSMINUS }
    | "~"                                   { NOT }
    
    (* equivalence operators *)
    | "is"                                  { IS }
    | "<"                                   { LT }
    | ">"                                   { GT }
    | ">="                                  { GTE }
    | "<="                                  { LTE }

    (* ignore markers *)
      (* comment: one line *)
    | "#" [^'\n']*                          { token lexbuf }
      (* comment: multiline *)
    | "`"                                   { comment_ml lexbuf }
      (* text: quotation *)
    | '"'                                   { scan_text lexbuf }
    
    (* identifier *)
    | ['a'-'z' 'A'-'Z']
      (['a'-'z' 'A'-'Z'] | 
      ['0'-'9'] | '_')* as id               { VARIABLE (id) }

    | eof                                   { EOF }

(* inside comment *)
and comment_ml = parse
    |"`"                                    { token lexbuf }
    | _                                     { comment_ml lexbuf }

(* inside text *)
and scan_text = parse
    | '"'   { let result = Buffer.contents buffer in
          
            (* new and tab replace *)
            let newline_count = ref 0 in

            let len = String.length result in
            let repl_str = ref "" in

            let i = ref 0 in
            let j = ref 0 in
            String.iter (fun c ->
              if !i < len then
                begin
                  if c = '\\' && !i + 4 < len then
                    let next_four = String.sub result !i 4 in
                    if next_four = "\\new" then
                      begin
                        repl_str := !repl_str ^ "\n";
                        i := !i + 4;
                        j := !j + 1;
                        newline_count := !newline_count + 1
                      end
                    else if next_four = "\\tab" then
                      begin
                        repl_str := !repl_str ^ "\t";
                          i := !i + 4;
                          j := !j + 1;
                      end
                    else
                      begin
                        repl_str := !repl_str ^ "\\" ^ (String.make 1 result.[!i]);
                          i := !i + 1;
                          j := !j + 1;
                        end
                  else
                    begin
                      if !i = !j then
                        begin
                          repl_str := !repl_str ^ (String.make 1 result.[!i]);
                            i := !i + 1;
                            j := !j + 1;
                        end
                      else
                        begin
                          j := !j + 1;
                        end
                      end
                    end
                ) result;
                let result = !repl_str in
            (* check if more than 3 \new in text literal *)
            if !newline_count > 3 then
              failwith "Error: More than 3 occurrences of \\new in the Text Literal";

            Buffer.clear buffer;
            TEXT_LITERAL result }
    | [^'"']+ as str {
        Buffer.add_string buffer str;
        scan_text lexbuf
      }
    | eof { failwith "String not closed" }