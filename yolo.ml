type t = {c: int; x: int; w: int; y: int; h: int}

let pp ppf {c; x; w; y; h} =
  Format.fprintf ppf "%d\t%d\t%d\t%d\t%d\n" c x w y h

let pp_header ppf =
  Format.fprintf ppf "class\tx\tw\ty\th\n"
