type t = {x: int; y: int; x': int; y': int}

let regexp = Re.Pcre.regexp
let regexp_string s = Re.Pcre.(regexp (quote s))

let parse s =
  try
    ignore (Re.exec (regexp {|^<area |}) s);
    ignore (Re.exec (regexp_string {| shape="rect"|}) s);
    let g = Re.exec (regexp {| coords="([^"]*)"|}) s in
    Re.split (regexp_string ",") (Re.get g 1) |>
    List.map int_of_string |> function
      | [x; y; x'; y'] -> Some {x; y; x'; y'}
      | _ -> None
  with Not_found ->
    None

let to_yolo {x; y; x'; y'} =
  let w = x' - x in
  let h = y' - y in
  Yolo.{c=0; x; y; w; h} (* TODO parse c? *)
