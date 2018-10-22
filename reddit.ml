type 'a t = {
  kind: string;
  data: 'a;
} [@@deriving yojson]

type link = {
  selftext: string;
  title: string;
  score: int;
  thumbnail: string;
  is_self: bool;
  author: string;
  num_comments: int;
  permalink: string;
  url: string;
  created_utc: float;
  is_video: bool;
} [@@deriving yojson {strict=false}]

type subreddit = {
  modhash: string;
  dist: int;
  children: link t list;
  after: string option;
  before: string option;
} [@@deriving yojson]

let headers = Cohttp.Header.init_with
  "User-Agent" "linux:github.com/ghuysmans/im2yolo:0.1"

let get ?after ?count name =
  let uri = Uri.make
    ~scheme:"https"
    ~host:"www.reddit.com"
    ~path:("/r/" ^ name ^ ".json")
    ~query:(
      (match after with
      | None -> []
      | Some a -> ["after", [a]]) |> fun l ->
      (match count with
      | None -> l
      | Some c -> ("limit", [string_of_int c]) :: l)
    )
    ()
  in
  let%lwt resp, body = Cohttp_lwt_unix.Client.get ~headers uri in
  match Cohttp.Response.status resp with
  | `OK ->
    let%lwt s = Cohttp_lwt.Body.to_string body in
    Lwt.return (Result.Ok (Yojson.Safe.from_string s))
  | _ ->
    let st = Cohttp.Response.status resp in
    let code, message = Cohttp.Code.(code_of_status st, string_of_status st) in
    Lwt.return (Result.Error (code, message))


let () = Lwt_main.run @@
  (*
  match%lwt get ~count:50 "cat" with
  | Error (_, message) ->
    Lwt_io.eprintf "%s\n" message
  | Ok json ->
  *)
    let json = Yojson.Safe.from_file "cat50.json" in
    match of_yojson subreddit_of_yojson json with
    | Error e ->
      Lwt_io.eprintl e
    | Ok sub ->
      sub.data.children |> Lwt_list.iter_s @@ fun i ->
        Lwt_io.printl @@
          (if i.data.is_video then
            "v "
          else if i.data.is_self then
            "s "
          else
            "p ") ^
          i.data.url
