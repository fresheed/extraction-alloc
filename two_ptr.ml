
type bool =
| True
| False

type 'a option =
| Some of 'a
| None

type 'a list =
| Nil
| Cons of 'a * 'a list

(** val length : 'a1 list -> int **)

let rec length = function
| Nil -> 0
| Cons (_, l') -> succ (length l')

type sumbool =
| Left
| Right

module Nat =
 struct
  (** val eq_dec : int -> int -> sumbool **)

  let rec eq_dec n m =
    (fun fO fS n -> if n=0 then fO () else fS (n-1))
      (fun _ ->
      (fun fO fS n -> if n=0 then fO () else fS (n-1))
        (fun _ -> Left)
        (fun _ -> Right)
        m)
      (fun n0 ->
      (fun fO fS n -> if n=0 then fO () else fS (n-1))
        (fun _ -> Right)
        (fun n1 -> eq_dec n0 n1)
        m)
      n
 end

(** val nth_error : 'a1 list -> int -> 'a1 option **)

let rec nth_error l n =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> match l with
              | Nil -> None
              | Cons (x, _) -> Some x)
    (fun n0 -> match l with
               | Nil -> None
               | Cons (_, l0) -> nth_error l0 n0)
    n

(** val floyd_loop :
    ('a1 -> 'a1 -> sumbool) -> ('a1 -> 'a1 option) -> int -> 'a1 -> 'a1 -> bool
    option **)

let rec floyd_loop eq_dec0 next fuel s f =
  (fun fO fS n -> if n=0 then fO () else fS (n-1))
    (fun _ -> None)
    (fun fuel0 ->
    match next f with
    | Some f1 ->
      (match next f1 with
       | Some f2 ->
         (match next s with
          | Some s1 ->
            (match eq_dec0 s1 f2 with
             | Left -> Some True
             | Right -> floyd_loop eq_dec0 next fuel0 s1 f2)
          | None -> Some False)
       | None -> Some False)
    | None -> Some False)
    fuel

(** val floyd :
    ('a1 -> 'a1 -> sumbool) -> ('a1 -> 'a1 option) -> 'a1 -> int -> bool option **)

let floyd eq_dec0 next x0 fuel =
  floyd_loop eq_dec0 next fuel x0 x0

(** val next_of : int option list -> int -> int option **)

let next_of arr i =
  match nth_error arr i with
  | Some o -> o
  | None -> None

(** val floyd_array : int option list -> bool **)

let floyd_array arr =
  match floyd Nat.eq_dec (next_of arr) 0 (succ (length arr)) with
  | Some b -> b
  | None -> False
