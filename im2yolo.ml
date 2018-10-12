let () =
  Format.printf "%t" Yolo.pp_header;
  try
    while true do
      match Imagemap.parse (read_line ()) with
      | None -> ()
      | Some im -> Format.printf "%a" Yolo.pp (Imagemap.to_yolo im)
    done
  with End_of_file ->
    ()
