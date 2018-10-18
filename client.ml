Dom_html.(Dom_events.listen (getElementById "f") Event.submit) @@ fun _ _ ->
  match
    Dom_html.(getElementById_coerce "i" CoerceTo.textarea),
    (* Dom_html.(getElementById_coerce "n" CoerceTo.input), *)
    Dom_html.(getElementById_coerce "dl" CoerceTo.a)
  with
  | Some i, (* Some n, *) Some dl ->
    let s = Js.to_string i##.value in
    let printf f = Format.(fprintf str_formatter) f in
    printf "%t" Yolo.pp_header;
    Re.(split Re.(compile (char '\n')) s) |>
    List.iter (fun l ->
      match Imagemap.parse l with
      | None -> ()
      | Some im -> printf "%a" Yolo.pp (Imagemap.to_yolo im));
    dl##.href := Js.string ("data:text/plain;base64," ^
      B64.encode (Format.flush_str_formatter ()));
    false
  | _ ->
    failwith "missing HTML element"
