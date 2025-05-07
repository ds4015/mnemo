
/* menemo smenatic checking */

open Ast
open Sast

module StringMap = Map.Make(String)


let check_assignment leftVType rightVType =
	if leftVType = rightVType then
		leftVType
	else
		raise (Failure ("Type error: left and right types do not match"))


let symbols = List.fold_left (fun m (ty, name) -> StringMap.add name ty m)
    StringMap.add()
    (* append symbols here *)


let ident_type s =
      try StringMap.find s symbols
      with Not_found -> raise (Failure ("Unknown identifier " ^ s))
    in

let rec check_expr = function
    IntLit l -> (TInt, SIntLit l)
    | TextLit l -> (TString, STextLit l)
    | BoolLit l -> (TBool, SBoolLit l)
    | LabelLit l -> (TLabel, SLabelLit l)
    | FloatLit l -> (TFloat, SFloatLit l)
    | Node l -> (TNode, SNode l)
    | Asn(var, e) as ex ->
        let lt = ident_type var
        and (rt, e') = check_expr e in
        let err = "Cannot assign " ^ string_of_typ lt ^ " = " ^
                  string_of_typ rt ^ " in " ^ string_of_expr ex
        in
        (check_assign lt rt err, SAsn(var, (rt, e')))

    | Binop(e1, op, e2) as e ->
            let (t1, e1') = check_expr e1
            and (t2, e2') = check_expr e2 in
            let err = "illegal binary operator " ^
                    string_of_typ t1 ^ " " ^ string_of_op op ^ " " ^
                    string_of_typ t2 ^ " in " ^ string_of_expr e
            in
            (* All binary operators require operands of the same type*)
            if t1 = t2 then
            (* Determine expression type based on operator and operand types *)
            let t = match op with
                Add | Sub | Mul | Div when t1 = Int -> Int
                | Eq -> Bool
                | Lt | Gt | Leq | Geq when t1 = Int -> Bool
                | _ -> raise (Failure err)
            in
            (t, SBinop((t1, e1'), op, (t2, e2')))
            else raise (Failure err)


(* more to come *)