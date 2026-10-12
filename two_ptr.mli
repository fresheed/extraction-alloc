
type bool =
| True
| False

type 'a option =
| Some of 'a
| None

type 'a list =
| Nil
| Cons of 'a * 'a list

val length : 'a1 list -> int

type sumbool =
| Left
| Right

module Nat :
 sig
  val eq_dec : int -> int -> sumbool
 end

val nth_error : 'a1 list -> int -> 'a1 option

val floyd_loop :
  ('a1 -> 'a1 -> sumbool) -> ('a1 -> 'a1 option) -> int -> 'a1 -> 'a1 -> bool
  option

val floyd :
  ('a1 -> 'a1 -> sumbool) -> ('a1 -> 'a1 option) -> 'a1 -> int -> bool option

val next_of : int option list -> int -> int option

val floyd_array : int option list -> bool
