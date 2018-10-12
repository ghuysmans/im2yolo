type t = {x: int; y: int; x': int; y': int}

let parse s =
  try
    ignore (Str.(search_forward (regexp {|^<area |}) s 0));
    ignore (Str.(search_forward (regexp_string {| shape="rect"|}) s 0));
    ignore (Str.(search_forward (regexp {| coords="\([^"]*\)"|}) s 0));
    Str.(split (regexp_string ",") (matched_group 1 s)) |>
    List.map int_of_string |> function
      | [x; y; x'; y'] -> Some {x; y; x'; y'}
      | _ -> None
  with Not_found ->
    None

let to_yolo {x; y; x'; y'} =
  let w = x' - x in
  let h = y' - y in
  Yolo.{c=0; x; y; w; h} (* TODO parse c? *)
