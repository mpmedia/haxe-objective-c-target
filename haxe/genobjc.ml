(*
 *  Haxe/Objective-C Compiler
 *  Copyright (c)2012 Băluță Cristian
 *  Based on and including code by (c)2005-2008 Nicolas Cannasse and Hugh Sanderson
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *)
open Ast
open Type
open Common

let join_class_path path separator =
	let result = match fst path, snd path with
	| [], s -> s
	| el, s -> String.concat separator el ^ separator ^ s in
	if (String.contains result '+') then begin
		let idx = String.index result '+' in
		(String.sub result 0 idx) ^ (String.sub result (idx+1) ((String.length result) - idx -1 ) )
	end else
		result
;;

(* This packages are cocoa frameworks, do not include this classes but include the framework *)
let getFrameworkOfPath class_path = 
	let pack = fst class_path in
	if List.length pack < 1 then "" else
	match List.nth pack ((List.length pack) -1) with
	| "addressbook" -> "AddressBook"
	| "av" -> "AVFoundation"
	| "network" -> "CFNetwork"
	| "coredata" -> "CoreData"
	| "coregraphics" -> "CoreGraphics"
	| "coreimage" -> "CoreImage"
	| "corelocation" -> "CoreLocation"
	| "gamekit" -> "GameKit"
	| "iad" -> "iAd"
	| "map" -> "MapKit"
	| "mediaplayer" -> "MediaPlayer"
	| "message" -> "MessageUI"
	| "openal" -> "OpenAL"
	| "opengles" -> "OpenGLES"
	| "quartz" -> "QuartzCore"
	| "social" -> "Social"
	| "store" -> "StoreKit"
	| "twitter" -> "Twitter"
	| "ui" -> "UIKit"
	| _ -> ""
;;

let processFunctionName name = 
	match name with
	| "applicationWillFinishLaunchingWithOptions" -> "application"
	| "applicationDidFinishLaunchingWithOptions" -> "application"
	| "applicationHandleOpenURL" -> "application"
	| _ -> name
;;

class importsManager =
	object(this)
	val mutable imports : (string,string list list) Hashtbl.t = Hashtbl.create 0;
	val mutable all_frameworks : string list = []
	val mutable class_frameworks : string list = []
	method add_class_path class_path =
		let f_name = getFrameworkOfPath class_path in
		if f_name <> "" then begin
			if not (List.mem f_name all_frameworks) then all_frameworks <- List.append all_frameworks [f_name];
			if not (List.mem f_name class_frameworks) then class_frameworks <- List.append class_frameworks [f_name];
		end else begin
			let pack = fst class_path in
			let name = snd class_path in
			let packs = (try Hashtbl.find imports name with Not_found -> []) in
			if not (List.mem pack packs) then Hashtbl.replace imports name (pack :: packs);
		end
	method get_all_frameworks = all_frameworks
	method get_class_frameworks = class_frameworks
	method get_imports = imports
	method reset = class_frameworks <- []
end;;

class sourceWriter write_func close_func =
	object(this)
	val indent_str = "\t"
	val mutable indent = ""
	val mutable indents = []
	val mutable just_finished_block = false
	method close = close_func(); ()
	
	method indent_one = this#write indent_str
	method push_indent = indents <- indent_str::indents; indent <- String.concat "" indents
	method pop_indent = match indents with
							| h::tail -> indents <- tail; indent <- String.concat "" indents
							| [] -> indent <- "/*?*/";
	method get_indent = indent
	
	method write str = write_func str; just_finished_block <- false
	method write_i x = this#write (indent ^ x)
	
	method begin_block = this#write ("{\n"); this#push_indent
	method end_block = this#pop_indent; this#write_i "}\n"; just_finished_block <- true
	method end_block_line = this#pop_indent; this#write_i "}"; just_finished_block <- true
	method terminate_line = this#write (if just_finished_block then "" else ";\n")
	
	method import_header path = this#write ("#import \"" ^ (join_class_path path "/") ^ ".h\"\n")
	method import_headers class_paths = 
		Hashtbl.iter (fun name paths ->
			List.iter (fun pack ->
				let path = pack, name in
				this#import_header path
				(* if path <> ctx.class_def.cl_path then  *)
			) paths
		) class_paths
	method import_frameworks f_list = 
		List.iter (fun name ->
			this#write ("#import <" ^ name ^ "/" ^ name ^ ".h>\n")
		) f_list;
	end
;;


let fileSourceWriter filename =
	let out_file = open_out filename in
	new sourceWriter (output_string out_file) (fun ()-> close_out out_file)
	(* output_string (channel) (string) *)
;;

let readWholeFile chan = Std.input_all chan;;

let rec makeClassDirectories base dir_list =
	( match dir_list with
	| [] -> ()
	| dir :: remaining ->
		let path = match base with
                   | "" ->  dir
                   | "/" -> "/" ^ dir
                   | _ -> base ^ "/" ^ dir  in
         if ( not ( (path="") ||
           ( ((String.length path)=2) && ((String.sub path 1 1)=":") ) ) ) then
		         if not (Sys.file_exists path) then
			          Unix.mkdir path 0o755;
		makeClassDirectories (if (path="") then "/" else path) remaining
	)
;;

let cachedSourceWriter filename =
	try
		let in_file = open_in filename in
		let old_contents = readWholeFile in_file in
		close_in in_file;
		let buffer = Buffer.create 0 in
		let add_buf str = Buffer.add_string buffer str in
		let close = fun () ->
			let contents = Buffer.contents buffer in
			if (not (contents=old_contents) ) then begin
				let out_file = open_out filename in
				output_string out_file contents;
				close_out out_file;
			end;
		in
		new sourceWriter (add_buf) (close);
	with _ ->
		fileSourceWriter filename
;;

let newSourceFile base_dir class_path extension =
	makeClassDirectories base_dir ("" :: (fst class_path));
	cachedSourceWriter (base_dir ^ "/" ^ ( String.concat "/" (fst class_path) ) ^ "/" ^ (snd class_path) ^ extension)
;;

let makeBaseDirectory file = makeClassDirectories "" ( ( Str.split_delim (Str.regexp "[\\/]+") file ) );;


(* Objective-C code generation context *)

type context = {
	com : Common.context;
	mutable ctx_file_info : (string,string) PMap.t ref;
	mutable writer : sourceWriter;
	mutable imports_manager : importsManager;
	mutable get_sets : (string * bool,string) Hashtbl.t;
	mutable class_def : tclass;
	mutable in_value : tvar option;
	mutable in_static : bool;
	mutable handleBreak : bool;
	mutable generating_header : bool;
	mutable generating_call : bool;
	mutable gen_uid : int;
	mutable local_types : t list;
}
let newContext common_ctx writer imports_manager file_info = {
	com = common_ctx;
	ctx_file_info = file_info;
	writer = writer;
	imports_manager = imports_manager;
	get_sets = Hashtbl.create 0;
	class_def = null_class;
	in_value = None;
	in_static = false;
	handleBreak = false;
	generating_header = false;
	generating_call = false;
	gen_uid = 0;
	local_types = [];
}

let isVarField e v =
	match e.eexpr, follow e.etype with
	| TTypeExpr (TClassDecl c),_
	| _,TInst(c,_) ->
		(try
			let f = try PMap.find v c.cl_fields	with Not_found -> PMap.find v c.cl_statics in
			(match f.cf_kind with Var _ -> true | _ -> false)
		with Not_found -> false)
	| _ -> false
;;

let isSpecialCompare e1 e2 =
	match e1.eexpr, e2.eexpr with
	| TConst TNull, _  | _ , TConst TNull -> None
	| _ ->
	match follow e1.etype, follow e2.etype with
	| TInst ({ cl_path = [],"Xml" } as c,_) , _ | _ , TInst ({ cl_path = [],"Xml" } as c,_) -> Some c
	| _ -> None
;;

let protect name =
	match name with
	| "Error" | "Namespace" -> "_" ^ name
	| _ -> name
;;

let isPointer t =
	match t with
	| "void" | "id" | "BOOL" | "int" | "uint" | "float" -> false
	| _ -> true
;;
let addPointerIfNeeded t =
	if (isPointer t) then "*" else ""
;;

(* Generating correct type *)
let processClassPath ctx is_static path pos =
	match path with
	| ([],name) ->
		(match name with
		| "Int" -> "int"
		| "Float" -> "float"
		| "Dynamic" -> "NSDictionary"
		| "Bool" -> "BOOL"
		| "String" -> "NSString"
		| "Array" -> "NSMutableArray"
		| _ -> name)
	| (["objc"],"FlashXml__") -> "Xml"
	| (["flash";"errors"],"Error") -> "Error"
	| (["flash"],"Vector") -> "Vector"
	| (["objc";"ios"],"XML") -> "XML"
	| (["haxe"],"Int32") when not is_static -> "int"
	| (pack,name) ->
		ctx.imports_manager#add_class_path path;
		name
;;
	
let srcDir ctx =
	let base_dir = ctx.file in
	let sub_dir = match ctx.main_class with
		| Some path -> (snd path)
		| _ -> "Application" in
	(base_dir ^ "/" ^ sub_dir)
;;

(* let isNativeClass class_name = 
	match class_name
	| "NS" | "UI" | ""
	;; *)

let rec createDirectory acc = function
	| [] -> ()
	| d :: l ->
		let dir = String.concat "/" (List.rev (d :: acc)) in
		if not (Sys.file_exists dir) then Unix.mkdir dir 0o755;
		createDirectory (d :: acc) l
;;

let saveLocals ctx =
	(fun() -> ())
		
let genLocal ctx l =
	ctx.gen_uid <- ctx.gen_uid + 1;
	if ctx.gen_uid = 1 then l else l ^ string_of_int ctx.gen_uid
;;

let unsupported p = error "This expression cannot be generated to Objective-C" p

let newLine ctx = ctx.writer#write_i "\n"

let rec concat ctx s f = function
	| [] -> ()
	| [x] -> f x
	| x :: l ->
		f x;
		ctx.writer#write s;
		concat ctx s f l
;;

let parent e =
	match e.eexpr with
	| TParenthesis _ -> e
	| _ -> mk (TParenthesis e) e.etype e.epos
;;

let rec typeToString ctx t p =
	match t with
	| TEnum _ | TInst _ when List.memq t ctx.local_types ->
		"*"
	| TAbstract (a,_) ->
		(match a.a_path with
		| [], "Void" -> "void"
		| [], "UInt" -> "int"(* "NSNumber" *)
		| [], "Int" -> "int"(* "NSNumber" *)
		| [], "Float" -> "float"(* "NSNumber" *)
		| [], "Bool" -> "BOOL"
		| _ -> processClassPath ctx true a.a_path p)
	| TEnum (e,_) ->
		if e.e_extern then (match e.e_path with
			| [], "Void" -> "void"
			| [], "Bool" -> "BOOL"
			| _ ->
				let rec loop = function
					| [] -> "Object"
					| (":fakeEnum",[Ast.EConst (Ast.Ident n),_],_) :: _ ->
						(match n with
						| "Int" -> "int"
						| "UInt" -> "uint"
						| _ -> n)
					| _ :: l -> loop l
				in
				loop e.e_meta
		) else
			processClassPath ctx true e.e_path p
	| TInst (c,_) ->
		(match c.cl_kind with
		| KNormal | KGeneric | KGenericInstance _ -> processClassPath ctx false c.cl_path p
		| KTypeParameter _ | KExtension _ | KExpr _ | KMacroType -> "*")
	| TFun _ ->
		"Function"
	| TMono r ->
		(match !r with None -> "*" | Some t -> typeToString ctx t p)
	| TAnon _ | TDynamic _ ->
		"id"
	| TType (t,args) ->
		(match t.t_path with
		| [], "UInt" -> "uint"
		| [] , "Null" ->
			(match args with
			| [t] ->
				(match follow t with
				| TAbstract ({ a_path = [],"UInt" },_)
				| TAbstract ({ a_path = [],"Int" },_)
				| TAbstract ({ a_path = [],"Float" },_)
				| TAbstract ({ a_path = [],"Bool" },_)
				| TInst ({ cl_path = [],"Int" },_)
				| TInst ({ cl_path = [],"Float" },_)
				| TEnum ({ e_path = [],"Bool" },_) -> "*"
				| _ -> typeToString ctx t p)
			| _ -> assert false);
		| _ -> typeToString ctx (apply_params t.t_types args t.t_type) p)
	| TLazy f ->
		typeToString ctx ((!f)()) p
;;

let rec iterSwitchBreak in_switch e =
	match e.eexpr with
	| TFunction _ | TWhile _ | TFor _ -> ()
	| TSwitch _ | TMatch _ when not in_switch -> iterSwitchBreak true e
	| TBreak when in_switch -> raise Exit
	| _ -> iter (iterSwitchBreak in_switch) e
;;

let handleBreak ctx e =
	let old_handle = ctx.handleBreak in
	try
		iterSwitchBreak false e;
		ctx.handleBreak <- false;
		(fun() -> ctx.handleBreak <- old_handle)
	with
		Exit ->
			ctx.writer#write "try {";
			newLine ctx;
			ctx.handleBreak <- true;
			(fun() ->
				ctx.writer#begin_block;
				ctx.handleBreak <- old_handle;
				newLine ctx;
				ctx.writer#write "} catch( e : * ) { if( e != \"__break__\" ) throw e; }";
			)
;;
		
let this ctx = if ctx.in_value <> None then "$this" else "self"

let escapeBin s =
	let b = Buffer.create 0 in
	for i = 0 to String.length s - 1 do
		match Char.code (String.unsafe_get s i) with
		| c when c < 32 -> Buffer.add_string b (Printf.sprintf "\\x%.2X" c)
		| c -> Buffer.add_char b (Char.chr c)
	done;
	Buffer.contents b
;;

(* TODO: Generate resources that Objective-C can understand *)
(* Put texts in a .plist file
Put images in the resources directory *)

let generateResources common_ctx =
	if Hashtbl.length common_ctx.resources <> 0 then begin
		let dir = (common_ctx.file :: ["Resources"]) in
		createDirectory [] dir;
		
		let resource_file = newSourceFile common_ctx.file ([],"Resources") ".plist" in
		resource_file#write "#include <xxx.h>\n\n";
		
		(* let add_resource name data =
			let ch = open_out_bin (String.concat "/" (dir @ [name])) in
			output_string ch data;
			close_out ch
		in
		Hashtbl.iter (fun name data -> add_resource name data) infos.com.resources;
		let ctx = init infos ([],"__resources__") in
		ctx.writer#write "\timport flash.utils.Dictionary;\n";
		ctx.writer#write "\tpublic class __resources__ {\n";
		ctx.writer#write "\t\tpublic static var list:Dictionary;\n";
		let inits = ref [] in
		let k = ref 0 in
		Hashtbl.iter (fun name _ ->
			let varname = ("v" ^ (string_of_int !k)) in
			k := !k + 1;
			ctx.writer#write (Printf.sprintf "\t\t[Embed(source = \"__res/%s\", mimeType = \"application/octet-stream\")]\n" name;
			ctx.writer#write (Printf.sprintf "\t\tpublic static var %s:Class;\n" varname;
			inits := ("list[\"" ^name^ "\"] = " ^ varname ^ ";") :: !inits;
		) infos.com.resources;
		ctx.writer#write "\t\tstatic public function __init__():void {\n";
		ctx.writer#write "\t\t\tlist = new Dictionary();\n";
		List.iter (fun init ->
			ctx.writer#write (Printf.sprintf "\t\t\t%s\n" init
		) !inits;
		ctx.writer#write "\t\t}\n";
		ctx.writer#write "\t}\n";
		ctx.writer#write "}"; *)
		(* close ctx; *)
	end
;;

let generateConstant ctx p = function
	| TInt i -> ctx.writer#write (Printf.sprintf "%ld" i)(* "[NSNumber numberWithInt:%ld]" i) *) (* %ld = int32 *)(* (Int32.to_string i) *)
	| TFloat f -> ctx.writer#write f
	| TString s -> ctx.writer#write (Printf.sprintf "@\"%s\"" (Ast.s_escape s)) (* "@\"" ^ (escapeBin (Ast.s_escape s)) ^ "\"" *)
	| TBool b -> ctx.writer#write (if b then "YES" else "NO")
	| TNull -> ctx.writer#write "nil"
	| TThis -> ctx.writer#write "self"
	(* | TThis -> ctx.writer#write (Printf.sprintf this ctx) *)
	| TSuper -> ctx.writer#write "super"
;;

(* A function header in objc is a message *)
(* We need to follow some strict rules *)
let generateFunctionHeader ctx name f params p =
	let old = ctx.in_value in
	let locals = saveLocals ctx in
	let old_t = ctx.local_types in
	ctx.in_value <- None;
	ctx.local_types <- List.map snd params @ ctx.local_types;
	let return_type = typeToString ctx f.tf_type p in
	ctx.writer#write (Printf.sprintf "(%s%s)" return_type (addPointerIfNeeded return_type));(* Print the return type of the function *)
	(* Generate function name. Some of them will need a rename, check with the database *)
	ctx.writer#write (Printf.sprintf "%s" (match name with None -> "" | Some (n,meta) ->
		let rec loop = function
			| [] -> processFunctionName n
			| _ :: l -> loop l
		in
		" " ^ loop meta
	));
	(* Generate the arguments of the function. Ignore the message name of the first arg *)
	let first_arg = ref true in
	concat ctx " " (fun (v,c) ->
		let type_name = typeToString ctx v.v_type p in
		let arg_name = v.v_name in
		let message_name = if !first_arg then "" else arg_name in
		(* let message_name = if List.length f.tf_args > 1 then arg_name else "" in *)
		ctx.writer#write (Printf.sprintf "%s:(%s%s)%s" message_name type_name (addPointerIfNeeded type_name) arg_name);
		first_arg := false;
		(* TODO: init args that have default values in the body of the function *)
		(* Match default values *)
		(* match c with
		| None ->
			if ctx.constructor_block then ctx.writer#write (Printf.sprintf " = %s" (defaultValue tstr));
		| Some c ->
			ctx.writer#write " = ";
			generateConstant ctx p c *)
	) f.tf_args;
	(fun () ->
		ctx.in_value <- old;
		locals();
		ctx.local_types <- old_t;
	)
;;

let rec generateMethodCall ctx e el r =
	(* ctx.writer#write ("GEN_M_CALL>"^(Type.s_expr_kind e)^">"); *)
	match e.eexpr , el with
	| TCall (x,_) , el ->
		ctx.writer#write "generateCall TCAll";
		generateValue ctx e;
		ctx.writer#write "-GCE-";
		ctx.writer#write " ";
		concat ctx " " (generateValue ctx) el;
		ctx.writer#write "-GCE2-"
	| TField(ee,v),args when isVarField ee v ->
		ctx.writer#write "generateCall TField (";
		generateValue ctx e;
		ctx.writer#write ")";
		ctx.writer#write "(";
		concat ctx "," (generateValue ctx) el;
		ctx.writer#write ")"
	| _ ->
		(* Generate a call to a method *)
		generateValue ctx e;
		ctx.writer#write ":";
		concat ctx " otherArgName:" (generateValue ctx) el
		(* ctx.writer#write "]" *)
	
and generateValueOp ctx e =
	match e.eexpr with
	| TBinop (op,_,_) when op = Ast.OpAnd || op = Ast.OpOr || op = Ast.OpXor ->
		ctx.writer#write "(";
		generateValue ctx e;
		ctx.writer#write ")";
	| _ ->
		generateValue ctx e

and generateFieldAccess ctx etype s to_method =
	(* ctx.writer#write (Printf.sprintf ">%s<" t); *)
	let field c = match fst c.cl_path, snd c.cl_path, s with
		| [], "Math", "NaN"
		| [], "Math", "NEGATIVE_INFINITY"
		| [], "Math", "POSITIVE_INFINITY"
		| [], "Math", "isFinite"
		| [], "Math", "isNaN"
		| [], "Date", "now"
		| [], "Date", "fromTime"
		| [], "Date", "fromString" -> ctx.writer#write (Printf.sprintf "[\"%s\"]" s)
		| [], "String", "charCodeAt" -> ctx.writer#write "[\"charCodeAtHX\"]"
		| [], "Date", "toString" -> ctx.writer#write "[\"toStringHX\"]"
		| [], "String", "cca" -> ctx.writer#write ".charCodeAt"
		| ["flash";"xml"], "XML", "namespace" -> ctx.writer#write (Printf.sprintf ".namespace")
		| _ -> ctx.writer#write (Printf.sprintf "%s%s" (if to_method or ctx.generating_call then " " else ".") s)
		(* Generating dot notation for property and space for methods *)
	in
	match follow etype with
	| TInst (c,_) -> field c
	| TAnon a ->
		(match !(a.a_status) with
			(* Generate a static field access *)
			| Statics c -> field c
			| _ -> ctx.writer#write (Printf.sprintf " GFA2 .%s" (s)))
	| _ ->
		ctx.writer#write (Printf.sprintf " GFA3 .%s" (s))
	
and generateExpression ctx e =
	(* ctx.writer#write ("GEN_EXPR>"^(Type.s_expr_kind e)^">"); *)
	match e.eexpr with
	| TConst c ->
		generateConstant ctx e.epos c
	| TLocal v ->
		ctx.writer#write (v.v_name)
	| TEnumField (en,s) ->
		ctx.writer#write_i (Printf.sprintf "%s.%s" (processClassPath ctx true en.e_path e.epos) (s))
	| TArray ({ eexpr = TLocal { v_name = "__global__" } },{ eexpr = TConst (TString s) }) ->
		let path = Ast.parse_path s in
		ctx.writer#write (processClassPath ctx false path e.epos)
	| TArray (e1,e2) ->
		(* Accesing an array element *)
		ctx.writer#write "[";
		generateValue ctx e1;
		ctx.writer#write " objectAtIndex:";
		generateValue ctx e2;
		ctx.writer#write "]";
	| TBinop (Ast.OpEq,e1,e2) when (match isSpecialCompare e1 e2 with Some c -> true | None -> false) ->
		let c = match isSpecialCompare e1 e2 with Some c -> c | None -> assert false in
		generateExpression ctx (mk (TCall (mk (TField (mk (TTypeExpr (TClassDecl c)) t_dynamic e.epos,"compare")) t_dynamic e.epos,[e1;e2])) ctx.com.basic.tbool e.epos);
	(* what is this used for? *)
(* 	| TBinop (op,{ eexpr = TField (e1,s) },e2) ->
		generateValueOp ctx e1;
		generateFieldAccess ctx e1.etype s;
		ctx.writer#write (Printf.sprintf " %s " (Ast.s_binop op);
		generateValueOp ctx e2; *)
	| TBinop (op,e1,e2) ->
		generateValueOp ctx e1;
		ctx.writer#write (Printf.sprintf " %s " (Ast.s_binop op));
		generateValueOp ctx e2;
	(* variable fields on interfaces are generated as (class["field"] as class) *)
	| TField ({etype = TInst({cl_interface = true} as c,_)} as e,s)
	| TClosure ({etype = TInst({cl_interface = true} as c,_)} as e,s)
		when (try (match (PMap.find s c.cl_fields).cf_kind with Var _ -> true | _ -> false) with Not_found -> false) ->
		ctx.writer#write "(";
		generateValue ctx e;
		ctx.writer#write (Printf.sprintf "[\"%s\"]" s);
		ctx.writer#write (Printf.sprintf " as %s)" (typeToString ctx e.etype e.epos));		
	| TField (e,s) ->
		(* This is important, is generating a field access . *)
   		generateValue ctx e;
		generateFieldAccess ctx e.etype s false;
	| TClosure (e,s) ->
		ctx.writer#write "TClosure(e,s) ";
   		generateValue ctx e;
		generateFieldAccess ctx e.etype s true
	| TTypeExpr t ->
		ctx.writer#write (processClassPath ctx true (t_path t) e.epos)
	| TParenthesis e ->
		ctx.writer#write "(";
		generateValue ctx e;
		ctx.writer#write ")";
	| TReturn eo ->
		if ctx.in_value <> None then unsupported e.epos;
		(match eo with
		| None ->
			ctx.writer#write_i "return"
		| Some e when (match follow e.etype with TEnum({ e_path = [],"Void" },[]) | TAbstract ({ a_path = [],"Void" },[]) -> true | _ -> false) ->
			ctx.writer#write_i "{";
			newLine ctx;
			generateValue ctx e;
			newLine ctx;
			ctx.writer#write_i "return";
			ctx.writer#begin_block;
			newLine ctx;
			ctx.writer#write_i "}";
		| Some e ->
			ctx.writer#write_i "return ";
			generateValue ctx e);
	| TBreak ->
		if ctx.in_value <> None then unsupported e.epos;
		if ctx.handleBreak then ctx.writer#write "throw \"__break__\"" else ctx.writer#write "break"
	| TContinue ->
		if ctx.in_value <> None then unsupported e.epos;
		ctx.writer#write_i "continue"
	| TBlock expr_list ->
		ctx.writer#begin_block;
		List.iter (fun e ->
			generateExpression ctx e;
			ctx.writer#terminate_line
		) expr_list;
		ctx.writer#end_block;
	| TFunction f ->
		let h = generateFunctionHeader ctx None f [] e.epos in
		let old = ctx.in_static in
		ctx.in_static <- true;
		generateExpression ctx f.tf_expr;
		ctx.in_static <- old;
		h();
	(* Generate a call to a function *)
	(* | TCall (func, arg_list) -> ctx.writer#write "GENERATE call (func, arg_list)"; *)
	| TCall (func, arg_list) when (match func.eexpr with
		| TLocal { v_name = "__objc__" } -> true
		| _ -> false) ->
			( match arg_list with
			| [{ eexpr = TConst (TString code) }] -> ctx.writer#write_i code;
			| _ -> error "__objc__ accepts only one string as an argument" func.epos;)
			(* TODO: this is generating a method aceess. We need to add indentation before the first call *)
	| TCall (func, arg_list) ->
		ctx.writer#write_i "[";
		ctx.generating_call <- true;
		generateMethodCall ctx func arg_list e.etype;
		ctx.generating_call <- false;
		ctx.writer#write "]"
	| TArrayDecl el ->
		ctx.writer#write "[[NSMutableArray alloc] initWithObjects: ";
		concat ctx ", " (generateValue ctx) el;
		ctx.writer#write ", nil]"
	| TThrow e ->
		ctx.writer#write "throw ";
		generateValue ctx e;
	| TVars [] ->
		()
	| TVars vl ->
		(* Vars inside methods only *)
		concat ctx "; " (fun (v,eo) ->
			ctx.writer#write_i (Printf.sprintf "%s %s%s" (typeToString ctx v.v_type e.epos) (addPointerIfNeeded (typeToString ctx v.v_type e.epos)) (v.v_name));
			match eo with
			| None -> ()
			| Some e ->
				ctx.writer#write " = ";
				generateValue ctx e
		) vl;
	| TNew (c,params,el) ->
		(match c.cl_path, params with
		| (["flash"],"Vector"), [pt] -> ctx.writer#write (Printf.sprintf "new Vector.<%s>(" (typeToString ctx pt e.epos))
		| _ -> ctx.writer#write (Printf.sprintf "[[%s alloc] init]" (snd c.cl_path) (*processClassPath ctx true c.cl_path e.epos) *));
		concat ctx "," (generateValue ctx) el)
	| TIf (cond,e,eelse) ->
		ctx.writer#write_i "if";
		generateValue ctx (parent cond);
		ctx.writer#write " ";
		generateExpression ctx e;
		(match eelse with
		| None -> ()
		| Some e ->
			newLine ctx;
			ctx.writer#write_i "else ";
			generateExpression ctx e);
	| TUnop (op,Ast.Prefix,e) ->
		ctx.writer#write (Ast.s_unop op);
		generateValue ctx e
	| TUnop (op,Ast.Postfix,e) ->
		generateValue ctx e;
		ctx.writer#write (Ast.s_unop op)
	| TWhile (cond,e,Ast.NormalWhile) ->
		let handleBreak = handleBreak ctx e in
		ctx.writer#write_i "while695";
		generateValue ctx (parent cond);
		ctx.writer#write " ";
		generateExpression ctx e;
		handleBreak();
	| TWhile (cond,e,Ast.DoWhile) ->
		let handleBreak = handleBreak ctx e in
		ctx.writer#write_i "do ";
		generateExpression ctx e;
		ctx.writer#write_i " while704";
		generateValue ctx (parent cond);
		handleBreak();
	| TObjectDecl fields ->
		ctx.writer#write_i "{";
		concat ctx " ," (fun (f,e) -> ctx.writer#write_i (Printf.sprintf "%s:" (f)); generateValue ctx e) fields;
		ctx.writer#write_i "}"
	| TFor (v,it,e) ->
		ctx.writer#begin_block;
		let handleBreak = handleBreak ctx e in
		let tmp = genLocal ctx "$it" in
		ctx.writer#write (Printf.sprintf "{ var %s : * = " tmp);
		generateValue ctx it;
		newLine ctx;
		ctx.writer#write_i (Printf.sprintf "for ( %s.hasNext() ) { var %s : %s = %s.next()" tmp (v.v_name) (typeToString ctx v.v_type e.epos) tmp);
		newLine ctx;
		generateExpression ctx e;
		newLine ctx;
		ctx.writer#end_block;
		handleBreak();
	| TTry (e,catchs) ->
		ctx.writer#write_i "try ";
		generateExpression ctx e;
		List.iter (fun (v,e) ->
			newLine ctx;
			ctx.writer#write_i (Printf.sprintf "catch( %s : %s )" (v.v_name) (typeToString ctx v.v_type e.epos));
			generateExpression ctx e;
		) catchs;
	| TMatch (e,_,cases,def) ->
		ctx.writer#begin_block;
		newLine ctx;
		let tmp = genLocal ctx "$e" in
		ctx.writer#write_i (Printf.sprintf "var %s : enum = " tmp);
		generateValue ctx e;
		newLine ctx;
		ctx.writer#write_i (Printf.sprintf "switch( %s.index ) {" tmp);
		List.iter (fun (cl,params,e) ->
			List.iter (fun c ->
				newLine ctx;
				ctx.writer#write_i (Printf.sprintf "case %d:" c);
			) cl;
			(match params with
			| None | Some [] -> ()
			| Some l ->
				let n = ref (-1) in
				let l = List.fold_left (fun acc v -> incr n; match v with None -> acc | Some v -> (v,!n) :: acc) [] l in
				match l with
				| [] -> ()
				| l ->
					newLine ctx;
					ctx.writer#write "var ";
					concat ctx ", " (fun (v,n) ->
						ctx.writer#write (Printf.sprintf "%s : %s = %s.params[%d]" (v.v_name) (typeToString ctx v.v_type e.epos) tmp n);
					) l);
			generateBlock ctx e;
			ctx.writer#write_i "break";
		) cases;
		(match def with
		| None -> ()
		| Some e ->
			newLine ctx;
			ctx.writer#write_i "default:";
			generateBlock ctx e;
			ctx.writer#write_i "break";
		);
		newLine ctx;
		ctx.writer#write_i "}";
		(* bend(); *)
		newLine ctx;
		ctx.writer#write_i "}";
	| TSwitch (e,cases,def) ->
		ctx.writer#write_i "switch"; generateValue ctx (parent e); ctx.writer#write " {";
		newLine ctx;
		List.iter (fun (el,e2) ->
			List.iter (fun e ->
				ctx.writer#write_i "case "; generateValue ctx e; ctx.writer#write ":";
			) el;
			generateBlock ctx e2;
			ctx.writer#write_i "break;";
			newLine ctx;
		) cases;
		(match def with
		| None -> ()
		| Some e ->
			ctx.writer#write_i "default:";
			generateBlock ctx e;
			ctx.writer#write_i "break";
			newLine ctx;
		);
		ctx.writer#write "}"
	| TCast (e1,None) ->
		ctx.writer#write "((";
		generateExpression ctx e1;
		ctx.writer#write (Printf.sprintf ") as %s)" (typeToString ctx e.etype e.epos));
	| TCast (e1,Some t) -> ()
		(* generateExpression ctx (Codegen.default_cast ctx.com e1 t e.etype e.epos) *)

and generateBlock ctx e =
	(* newLine ctx; *)
	ctx.writer#begin_block;
	match e.eexpr with
	| TBlock [] -> ()
	| _ ->
		generateExpression ctx e;
		ctx.writer#end_block
	
and generateValue ctx e =
	(* ctx.writer#write ("GEN_VAL>"^(Type.s_expr_kind e)^">"); *)
	let assign e =
		mk (TBinop (Ast.OpAssign,
			mk (TLocal (match ctx.in_value with None -> assert false | Some r -> r)) t_dynamic e.epos,
			e
		)) e.etype e.epos
	in
	let block e =
		mk (TBlock [e]) e.etype e.epos
	in
	let value block =
		let old = ctx.in_value in
		let t = typeToString ctx e.etype e.epos in
		let r = alloc_var (genLocal ctx "$r") e.etype in
		ctx.in_value <- Some r;
		if ctx.in_static then
			ctx.writer#write (Printf.sprintf "- (%s*) " t)
		else
			ctx.writer#write (Printf.sprintf "((%s)($this:%s) " t "(snd ctx.path)");
		(fun() ->
			if block then begin
				newLine ctx;
				ctx.writer#write_i (Printf.sprintf "return %s" r.v_name);
				
				ctx.writer#begin_block;
				newLine ctx;
				ctx.writer#write (Printf.sprintf "%s* %s" t r.v_name);
				ctx.writer#end_block;
						
				newLine ctx;
				ctx.writer#write_i "}";
			end;
			ctx.in_value <- old;
			if ctx.in_static then
				ctx.writer#write "()"
			else
				ctx.writer#write (Printf.sprintf "(%s))" (this ctx))
		)
	in
	match e.eexpr with
	| TCall ({ eexpr = TLocal { v_name = "__keys__" } },_) 
	| TCall ({ eexpr = TLocal { v_name = "__hkeys__" } },_) ->
		ctx.writer#write "GENERATE_CALL_0 ";
		let v = value true in
		generateExpression ctx e;
		v()
	| TTypeExpr _ ->
		generateExpression ctx e
	| TConst _
	| TLocal _
	| TEnumField _
	| TArray _
	| TBinop _
	| TField _
	| TClosure _
	| TParenthesis _
	| TObjectDecl _
	| TArrayDecl _
	| TCall _
	| TNew _
	| TUnop _
	| TFunction _ ->
		generateExpression ctx e
	| TCast (e1,t) ->
		ctx.writer#write (Printf.sprintf "(%s*)" (typeToString ctx e.etype e.epos))
		(* generateValue ctx (match t with None -> e1 | Some t -> Codegen.default_cast ctx.com e1 t e.etype e.epos) *)
	| TReturn _
	| TBreak
	| TContinue ->
		unsupported e.epos
	| TVars _
	| TFor _ -> ctx.writer#write "generate for"
	| TWhile _
	| TThrow _ ->
		(* value is discarded anyway *)
		let v = value true in
		generateExpression ctx e;
		v()
	| TBlock [] ->
		ctx.writer#write "nil"
	| TBlock [e] ->
		generateValue ctx e
	| TBlock el ->
		let v = value true in
		let rec loop = function
			| [] ->
				ctx.writer#write "return nil";
			| [e] ->
				generateExpression ctx (assign e);
			| e :: l ->
				generateExpression ctx e;
				newLine ctx;
				loop l
		in
		loop el;
		v();
	| TIf (cond,e,eo) ->
		ctx.writer#write "(";
		generateValue ctx cond;
		ctx.writer#write "?";
		generateValue ctx e;
		ctx.writer#write ":";
		(match eo with
		| None -> ctx.writer#write "nil"
		| Some e -> generateValue ctx e);
		ctx.writer#write ")"
	| TSwitch (cond,cases,def) ->
		let v = value true in
		generateExpression ctx (mk (TSwitch (cond,
			List.map (fun (e1,e2) -> (e1,assign e2)) cases,
			match def with None -> None | Some e -> Some (assign e)
		)) e.etype e.epos);
		v()
	| TMatch (cond,enum,cases,def) ->
		let v = value true in
		generateExpression ctx (mk (TMatch (cond,enum,
			List.map (fun (constr,params,e) -> (constr,params,assign e)) cases,
			match def with None -> None | Some e -> Some (assign e)
		)) e.etype e.epos);
		v()
	| TTry (b,catchs) ->
		let v = value true in
		generateExpression ctx (mk (TTry (block (assign b),
			List.map (fun (v,e) -> v, block (assign e)) catchs
		)) e.etype e.epos);
		v()

let final m = if has_meta ":final" m then "final " else ""

let generateField ctx is_static field =
	newLine ctx;
	ctx.in_static <- is_static;
	ctx.gen_uid <- 0;
	
	(* List.iter (fun(m,pl,_) ->
		match m,pl with
		| ":meta", [Ast.ECall ((Ast.EConst (Ast.Ident n),_),args),_] ->
			let mk_arg (a,p) =
				match a with
				| Ast.EConst (Ast.String s) -> (None, s)
				| Ast.EBinop (Ast.OpAssign,(Ast.EConst (Ast.Ident n),_),(Ast.EConst (Ast.String s),_)) -> (Some n, s)
				| _ -> error "Invalid meta definition" p
			in
			ctx.writer#write (Printf.sprintf ">>>[%s" n);
			(match args with
			| [] -> ()
			| _ ->
				ctx.writer#write "---";
				concat ctx "," (fun a ->
					match mk_arg a with
					| None, s -> generateConstant ctx (snd a) (TString s)
					| Some s, e -> ctx.writer#write (Printf.sprintf "%s=" s); generateConstant ctx (snd a) (TString e)
				) args;
				ctx.writer#write ")");
			ctx.writer#write "]";
		| _ -> ()
	) field.cf_meta; *)
	
	(* let public = f.cf_public || Hashtbl.mem ctx.get_sets (f.cf_name,static) || (f.cf_name = "main" && static) || f.cf_name = "resolve" || has_meta ":public" f.cf_meta in *)
	let p = ctx.class_def.cl_pos in
	match field.cf_expr, field.cf_kind with
	| Some { eexpr = TFunction fd }, Method (MethNormal | MethInline) ->
		ctx.writer#write (Printf.sprintf "%s " (if is_static then "+" else "-"));
		(* Generate function header *)
		let h = generateFunctionHeader ctx (Some (field.cf_name, field.cf_meta)) fd field.cf_params p in
		(* Generate function content if is not a header file *)
		if not ctx.generating_header then generateExpression ctx fd.tf_expr else ctx.writer#write ";";
		h();
		newLine ctx
	| _ ->
		let is_getset = (match field.cf_kind with Var { v_read = AccCall _ } | Var { v_write = AccCall _ } -> true | _ -> false) in
		match follow field.cf_type with
		| TFun (args,r) -> ()
			(* Generate functions located in the hx interfaces *)
			(* let rec loop = function
				| [] -> field.cf_name
				| (":getter",[Ast.EConst (Ast.String name),_],_) :: _ -> "get " ^ name
				| (":setter",[Ast.EConst (Ast.String name),_],_) :: _ -> "set " ^ name
				| _ :: l -> loop l
			in
			ctx.writer#write (Printf.sprintf "(%s*) %s_" (typeToString ctx r p) (loop field.cf_meta));
			concat ctx " " (fun (arg,o,t) ->
				let tstr = typeToString ctx t p in
				ctx.writer#write (Printf.sprintf "%s:(%s*)%s" arg tstr arg);
				(* if o then ctx.writer#write (Printf.sprintf " = %s" (defaultValue tstr)); *)
			) args;
			ctx.writer#write ";"; *)
			(* let return_type = typeToString ctx r p in
			ctx.writer#write (Printf.sprintf "(%s%s)" return_type (addPointerIfNeeded return_type));(* Print the return type of the function *)
			(* Generate function name *)
			ctx.writer#write (Printf.sprintf "%s" (match name with None -> "" | Some (n,meta) ->
				let rec loop = function
					| [] -> n
					| _ :: l -> loop l
				in
				" " ^ loop meta
			));
			(* Generate the arguments of the function. Ignore the message name of the first arg *)
			let first_arg = ref true in
			concat ctx " " (fun (v,c) ->
				let type_name = typeToString ctx v.v_type p in
				let arg_name = v.v_name in
				let message_name = if !first_arg then "" else arg_name in
				ctx.writer#write (Printf.sprintf "%s:(%s%s)%s" message_name type_name (addPointerIfNeeded type_name) arg_name);
				first_arg := false;
			) args; *)
				
		| _ when is_getset ->
			if ctx.generating_header then begin
				let t = typeToString ctx field.cf_type p in
				let id = field.cf_name in
				let getter = match field.cf_kind with
					| Var v -> (match v.v_read with
						| AccCall s -> Printf.sprintf ", getter=%s" s;
						| _ -> "")
					| _ -> "" in
				let setter = match field.cf_kind with
					| Var v -> (match v.v_write with
						| AccCall s -> Printf.sprintf ", setter=%s" s;
						| _ -> "")
					| _ -> "" in
				let strong = if (isPointer t) then ", strong" else "" in
				let readonly = if false then ", readonly" else "" in
				ctx.writer#write (Printf.sprintf "@property (nonatomic%s%s%s%s) %s %s%s;" strong readonly getter setter t (addPointerIfNeeded t) id);
			end
		| _ -> ();
		
		let gen_init () = match field.cf_expr with
			| None -> ()
			| Some e ->
				ctx.writer#write " = ";
				generateValue ctx e
		in
		if is_getset then begin
			(* let t = typeToString ctx f.cf_type p in *)
			let id = field.cf_name in
			(* let v = (match f.cf_kind with Var v -> v | _ -> assert false) in *)
			ctx.writer#write (Printf.sprintf "@synthesize %s;\n" id);
			(* (match v.v_read with
			| AccNormal -> ""
			| AccCall m ->
				ctx.writer#write (Printf.sprintf "%s function get %s() : %s { return %s(); }" rights id t m);
				newLine ctx
			| AccNo | AccNever ->
				ctx.writer#write (Printf.sprintf "%s function get %s() : %s { return $%s; }" (if v.v_read = AccNo then "protected" else "private") id t id);
				newLine ctx
			| _ ->
				()); *)
			(* (match v.v_write with
			| AccNormal | AccCall m -> ""
			| AccNo | AccNever -> "readonly"
			| _ -> ()); *)
			gen_init()
		end
		else if ctx.generating_header then begin
			(* This is generating implementation class properties declarations *)
			let t = (typeToString ctx field.cf_type p) in
			let id = field.cf_name in
			(* let v = (match field.cf_kind with Var v -> v | _ -> assert false) in *)
			ctx.writer#write (Printf.sprintf "@property (nonatomic, strong) %s %s%s;" t (addPointerIfNeeded t) id);
			gen_init()
		end
		else begin
			(* let t = (typeToString ctx f.cf_type p) in *)
			let id = field.cf_name in
			ctx.writer#write (Printf.sprintf "@synthesize %s;" id);
			gen_init()
		end
;;

let generateProperty ctx static f =
	
	()
;;

let rec defineGetSet ctx is_static c =
	let def f name =
		Hashtbl.add ctx.get_sets (name,is_static) f.cf_name
	in
	let field f =
		match f.cf_kind with
		| Method _ -> ()
		| Var v ->
			(match v.v_read with AccCall m -> def f m | _ -> ());
			(match v.v_write with AccCall m -> def f m | _ -> ())
	in
	List.iter field (if is_static then c.cl_ordered_statics else c.cl_ordered_fields);
	match c.cl_super with
	| Some (c,_) when not is_static -> defineGetSet ctx is_static c
	| _ -> ()
;;


let makeImportPath (p,s) = match p with [] -> s | _ -> String.concat "/" p ^ "/" ^ s

(* Generate header + implementation *)

let generateClassFiles common_ctx class_def file_info imports_manager =
	(* When we create a new class reset the frameworks and imports that where stored for the previous class *)
	(* The frameworks are kept in a non-resetable variable also *)
	imports_manager#reset;
	
	if not class_def.cl_interface then begin
	
	(* Create the implementation file *)
	let src_dir = srcDir common_ctx in
	let class_path = class_def.cl_path in
	(* let class_name = (snd class_def.cl_path) in *)
	let m_file = newSourceFile src_dir class_path ".m" in
	let output_m = (m_file#write) in
	let ctx = newContext common_ctx m_file imports_manager file_info in
	ctx.class_def <- class_def;
	
	defineGetSet ctx true class_def;
	defineGetSet ctx false class_def;
	(* common_ctx.local_types <- List.map snd c.cl_types; *)
	
	(* imports_manager#add_class_path class_def.cl_path; *)
	ctx.writer#import_header class_def.cl_path;
	newLine ctx;
	output_m ("@implementation " ^ (snd class_def.cl_path) ^ "\n\n");
	
	(match class_def.cl_constructor with
	| None -> ()
	| Some f ->
		let f = { f with
			cf_name = snd class_def.cl_path;
			cf_public = true;
			cf_kind = Method MethNormal;
		} in
		generateField ctx false f;
	);
	
	List.iter (generateField ctx true) class_def.cl_ordered_statics;
	List.iter (generateField ctx false) class_def.cl_ordered_fields;
	
	output_m "\n\n@end\n";
	m_file#close
	
	end;
	
	
	(* Create the header file *)
	
	let src_dir = srcDir common_ctx in
	let class_path = class_def.cl_path in
	(* let class_name = (snd class_def.cl_path) in *)
	let h_file = newSourceFile src_dir class_path ".h" in
	let output_h = (h_file#write) in
	let ctx = newContext common_ctx h_file imports_manager file_info in
	ctx.class_def <- class_def;
	ctx.generating_header <- true;
	ctx.imports_manager#add_class_path class_path;
	
	(* defineGetSet ctx true class_def;
	defineGetSet ctx false class_def; *)
	newLine ctx;
	(* (snd c.cl_path) returns the class name *)
	
	(* Import frameworks *)
	ctx.writer#import_frameworks imports_manager#get_class_frameworks;
	newLine ctx;
	
	(* Import classes *)
	ctx.writer#import_headers imports_manager#get_imports;
	newLine ctx;
	
	output_h ("@interface " ^ (snd class_path));
	(* Add the super class *)
	(match class_def.cl_super with
		| None -> ()
		(* | Some (csup,_) -> output_h (Printf.sprintf " : %s " (s_path ctx true csup.cl_path class_def.cl_pos))); *)
		| Some (csup,_) -> output_h (Printf.sprintf " : %s " (snd csup.cl_path)));
	(* ctx.writer#write (Printf.sprintf "\npublic %s%s%s %s " (final c.cl_meta) (match c.cl_dynamic with None -> "" | Some _ -> if c.cl_interface then "" else "dynamic ") (if c.cl_interface then "interface" else "class") (snd c.cl_path); *)
	if class_def.cl_implements != [] then begin
		(* Add implement *)
		output_h "<";
		(match class_def.cl_implements with
		| [] -> ()
		| l -> concat ctx ", " (fun (i,_) -> output_h (Printf.sprintf "%s" (snd i.cl_path))) l
		);
		output_h ">";
	end;
	output_h "\n\n";
	
	List.iter (generateField ctx true) class_def.cl_ordered_statics;
	List.iter (generateField ctx false) class_def.cl_ordered_fields;
	
	output_h "\n\n@end\n";
	h_file#close
;;




(* GENERATE THE PROJECT DEFAULT FILES AND DIRECTORIES *)

let generateProjectStructure common_ctx = 
	let base_dir = common_ctx.file in
	let sub_dir = match common_ctx.main_class with
		| Some path -> (snd path)
		| _ -> "Application" in
	(* Create classes directory *)
	makeClassDirectories base_dir ( sub_dir :: []);
	makeClassDirectories base_dir ( sub_dir :: ["en.lproj"]);
	(* Create tests directory *)
	makeClassDirectories base_dir ( (sub_dir^"Tests") :: []);
	(* Create project file *)
	makeClassDirectories base_dir ( (sub_dir^".xcodeproj") :: [])
;;

let generateMain common_ctx class_def =

	let main_expression = (match class_def.cl_ordered_statics with
		| [{ cf_expr = Some expression }] -> expression;
		| _ -> assert false ) in
	let base_dir = common_ctx.file in
	let sub_dir = match common_ctx.main_class with
		| Some path -> (snd path)
		| _ -> "Application" in
	(* let class_path = class_def.cl_path in *)
	let class_name = (snd class_def.cl_path) in
	let generate_file filename =
		let m_file = newSourceFile base_dir ([sub_dir],filename) ".m" in
		let output_main = (m_file#write) in
		
		print_endline (Type.s_expr_kind main_expression);
		(* print_endline (Type.s_expr main_expression (Type.s_expr_kind main_expression) ); *)
		
		match main_expression.eexpr with
		| TCall (eo,el) -> 
			print_endline (Type.s_expr_kind eo);
			(* print_endline (Type.s_expr_kind (fst el)); *)
			
			List.iter (
			
			fun object_def -> print_endline (Type.s_expr_kind object_def);
			
			) el;
			
			(* match el.e_expr, el.e_kind with
			| Some { eexpr = TFunction fd }, Method (MethNormal | MethInline) ->
				print_endline "1111111111" *)
			(* let h = generateFunctionHeader ctx (Some (field.cf_name, field.cf_meta)) fd field.cf_params p in
						(* Generate function content if is not a header file *)
						if not ctx.generating_header then generateExpression ctx fd.tf_expr else ctx.writer#write ";";
						h();
						newLine ctx *)
			(* | _ -> print_endline "NOTHING" *)
		(* print_endline (Type.s_expr_kind el) *)
			(* (match eo with
			(* | Some e when (match follow e.etype with TEnum({ e_path = [],"Void" },[]) | TAbstract ({ a_path = [],"Void" },[]) -> true | _ -> false) -> *)
			| Some e -> print_endline "Generating the return";
			| None | _ -> print_endline "You must provide a return UIApplicationMain ()"
				(* ctx.writer#write_i "return "; *)
				(* generateValue ctx e); *)
			) *)
		| _ -> print_endline "The static main method should contain only a return UIApplicationMain and nothing else";
		Type.print_context();
		output_main ("//
//  main.m
//  " ^ class_name ^ "
//
//  Source generated by Haxe Objective-C target
//

#import <UIKit/UIKit.h>
#import \"" ^ class_name ^ ".h\"

int main(int argc, char *argv[]) {
	@autoreleasepool {
		return UIApplicationMain(argc, argv, nil, NSStringFromClass([" ^ class_name ^ " class]));
	}
}");
		m_file#close;
	in
	generate_file "main"
;;
	
let generatePch common_ctx class_def  =
	(* This class imports will be available in the entire Xcode project, we add here Std classes *)
	let base_dir = common_ctx.file in
	let sub_dir = match common_ctx.main_class with
		| Some path -> (snd path)
		| _ -> "Application" in
	let generate_file =
		let file = newSourceFile base_dir ([sub_dir], sub_dir ^ "-Prefix") ".pch" in
		let output_pch = (file#write) in
		
		output_pch "//
// Prefix header for all source files in the project
//

#import <Availability.h>

#ifndef __IPHONE_4_0
#warning \"This project uses features only available in iOS SDK 4.0 and later.\"
#endif

#ifdef __OBJC__
	#import <UIKit/UIKit.h>
	#import <Foundation/Foundation.h>
#endif";
		file#close;
	in
	generate_file
;;

let generatePlist common_ctx class_def  =

	let base_dir = common_ctx.file in
	let sub_dir = match common_ctx.main_class with
		| Some path -> (snd path)
		| _ -> "Application" in
	let generate_file =
		let identifier = "ralcr.com" in
		let file = newSourceFile base_dir ([sub_dir],sub_dir^"-Info") ".plist" in
		let output_pch = (file#write) in
		
		output_pch ("<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleDisplayName</key>
	<string>${PRODUCT_NAME}</string>
	<key>CFBundleExecutable</key>
	<string>${EXECUTABLE_NAME}</string>
	<key>CFBundleIdentifier</key>
	<string>" ^ identifier ^ ".${PRODUCT_NAME:rfc1034identifier}</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>${PRODUCT_NAME}</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>1.0</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>UIRequiredDeviceCapabilities</key>
	<array>
		<string>armv7</string>
	</array>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
</dict>
</plist>");
		file#close;
	in
	generate_file
;;

let generateEnum ctx e =
	()
;;

(* The main entry of the generator *)
let generate common_ctx =
	
	(* Generate folder structure and basic files *)
	generateProjectStructure common_ctx;
	
	let imports_manager = new importsManager in
	let file_info = ref PMap.empty in
	let inits = ref [] in
	List.iter (fun object_def ->
		match object_def with
		| TClassDecl class_def ->
			let class_def = (match class_def.cl_path with
				| ["flash"],"FlashXml__" -> { class_def with cl_path = [],"Xml" }
				| (pack,name) -> { class_def with cl_path = (pack, name) }
			) in
			(match class_def.cl_init with
			| None -> ()
			| Some e -> inits := e :: !inits);
			
			if not class_def.cl_extern then generateClassFiles common_ctx class_def file_info imports_manager
		
		| TEnumDecl e ->
			let pack,name = e.e_path in
			let e = { e with e_path = (pack,protect name) } in
			if not e.e_extern then generateEnum common_ctx e
				
		| TTypeDecl _ | TAbstractDecl _ ->
			()
	) common_ctx.types;
	
	(match common_ctx.main with
	| None -> ()
	| Some e ->
		let main_field = { cf_name = "main"; cf_type = t_dynamic; cf_expr = Some e; cf_pos = e.epos; cf_public = true; cf_meta = []; cf_overloads = []; cf_doc = None; cf_kind = Var { v_read = AccNormal; v_write = AccNormal; }; cf_params = [] } in
		let class_def = { null_class with cl_path = ([],"AppDelegate"); cl_ordered_statics = [main_field] } in
		(* main_deps := find_referenced_types common_ctx (TClassDecl class_def) super_deps constructor_deps false true false; *)
		generateMain common_ctx class_def;
		generatePch common_ctx class_def;
		generatePlist common_ctx class_def;
		generateResources common_ctx;
		
		(* List.iter (fun name ->
			print_endline name
		) imports_manager#get_all_frameworks *)
	)
;;
