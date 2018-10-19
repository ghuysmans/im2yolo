let handle_status n = Unix.(function
  | WEXITED 0 -> ()
  | WEXITED r -> Printf.eprintf "%s returned %d\n" n r; exit r
  | WSIGNALED s -> Printf.eprintf "%s got signal %d\n" n s; exit s
  | WSTOPPED c -> Printf.eprintf "%s stopped by signal %d\n" n c; exit c
)

let dimensions_of fn =
  let ch = Unix.open_process_in @@ "file " ^ Filename.quote fn in
  let s = input_line ch in
  handle_status "file" (Unix.close_process_in ch);
  try
    ignore Str.(search_forward (regexp {|\(\d\)+x\(\d+\)|}) s 0);
    match List.map int_of_string Str.[matched_group 1 s; matched_group 2 s] with
    | [w; h] -> w, h
    | _ -> failwith ""
  with Failure _ ->
    Printf.eprintf "file parse error: %S\n" s;
    exit 1

let resize ~w ~h inp =
  let open Filename in
  let out = basename inp in
  Printf.sprintf "convert -size %dx%d %s %s" w h (quote inp) (quote out) |>
  Unix.system |>
  handle_status "convert"

let () =
  Array.to_list Sys.argv |> List.tl |> List.iter @@ fun txt_i ->
    let txt_o = Filename.basename txt_i in
    let png_i = Filename.chop_extension txt_i ^ ".png" in
    let ic = open_in txt_i in
    let oc = open_out txt_o in
    (try
      while true do
        ignore @@ input_line ic
      done
    with End_of_file ->
      Printf.printf "%s\n" txt_i);
    close_out oc;
    close_in ic
