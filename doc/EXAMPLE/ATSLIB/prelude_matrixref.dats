(*
** for testing [prelude/matrixref]
*)

(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)
//
staload "prelude/lmacrodef.hats"
//
(* ****** ****** *)

staload UN = "prelude/SATS/unsafe.sats"

(* ****** ****** *)
//
postfix 0 sz SZ
//
macdef sz (x) = i2sz ,(x)
macdef SZ (x) = i2sz ,(x)
//
(* ****** ****** *)

implement main0((*void*)) = {(*void*)}

(* ****** ****** *)

(* end of [prelude_matrixref.dats] *)
