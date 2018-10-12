let () = Js.export "im2yolo" (object%js
  method convert s =
    Format.printf "%t" Yolo.pp_header;
    Str.(split (regexp_string "\n") s) |>
    List.iter @@ fun l ->
      match Imagemap.parse l with
      | None -> ()
      | Some im -> Format.printf "%a" Yolo.pp (Imagemap.to_yolo im)
end)
