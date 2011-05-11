(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(*                              Hongwei Xi                             *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, Boston University
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
** later version.
** 
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
** 
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)
//
// Author: Hongwei Xi (hwxi AT cs DOT bu DOT edu)
// Start Time: May, 2011
//
(* ****** ****** *)

staload _(*anon*) = "prelude/DATS/reference.dats"

(* ****** ****** *)

staload
FIL = "pats_filename.sats"
typedef filename = $FIL.filename

staload SYM = "pats_symbol.sats"
staload SYN = "pats_syntax.sats"

(* ****** ****** *)

staload "pats_symmap.sats"
staload "pats_symenv.sats"

(* ****** ****** *)

staload "pats_staexp2.sats"
staload "pats_dynexp2.sats"

(* ****** ****** *)

staload "pats_namespace.sats"
staload "pats_trans2_env.sats"

(* ****** ****** *)

local

viewtypedef
filenv_struct = @{
  name= filename
, sort= s2temap
, sexp= s2itmmap
, dexp= d2itmmap
} // end of [filenv_struct]

assume filenv_type = ref (filenv_struct)

in // in of [local]

implement
filenv_get_name (fenv) = let
  val (vbox pf | p) = ref_get_view_ptr (fenv) in p->name  
end // end of [filenv_get_name]

implement
filenv_get_s2temap (fenv) = let
  val (vbox pf | p) = ref_get_view_ptr (fenv)
  prval (pf1, fpf1) = __assert (view@ (p->sort)) where {
    extern prfun __assert {a:viewt@ype} {l:addr} (pf: !a @ l): (a @ l, minus (filenv, a @ l))
  } // end of [prval]
in
  (pf1, fpf1 | &p->sort)
end // end of [filenv_get_s2temap]

implement
filenv_get_s2itmmap (fenv) = let
  val (vbox pf | p) = ref_get_view_ptr (fenv)
  prval (pf1, fpf1) = __assert (view@ (p->sexp)) where {
    extern prfun __assert {a:viewt@ype} {l:addr} (pf: !a @ l): (a @ l, minus (filenv, a @ l))
  } // end of [prval]
in
  (pf1, fpf1 | &p->sexp)
end // end of [filenv_get_s2itmmap]

end // end of [local]

(* ****** ****** *)

local

viewtypedef s2rtenv = symenv (s2rtext)
val [l0:addr] (pf | p0) = symenv_make_nil ()
val (pf0 | ()) = vbox_make_view_ptr {s2rtenv} (pf | p0)

assume s2rtenv_push_v = unit_v

(* ****** ****** *)

fun
the_s2rtenv_find_namespace .<>.
  (id: symbol): s2rtextopt_vt = let
  fn f (
    fenv: filenv
  ) :<cloptr1> s2rtextopt_vt = let
    val (pf, fpf | p) = filenv_get_s2temap (fenv)
    val ans = symmap_search (!p, id)
    prval () = minus_addback (fpf, pf | fenv)
  in
    ans
  end // end of [f]
in
  the_namespace_search (f)
end // end of [the_s2rtenv_find_namespace]

(* ****** ****** *)

in // in of [local]

implement
the_s2rtenv_add (id, s2te) = let
  prval vbox pf = pf0 in symenv_insert (!p0, id, s2te)
end // end of [the_s2rtenv_add]

(* ****** ****** *)

implement
the_s2rtenv_find (id) = let
  val ans = let
    prval vbox pf = pf0 in symenv_search (!p0, id)
  end // end of [val]
in
//
case+ ans of
| Some_vt _ => (fold@ ans; ans)
| ~None_vt () => let
    val ans = the_s2rtenv_find_namespace (id)
  in
    case+ ans of
    | Some_vt _ => (fold@ ans; ans)
    | ~None_vt () => let
        prval vbox pf = pf0 in symenv_pervasive_search (!p0, id)
      end // end of [None_vt]
  end // end of [None_vt]
//
end // end of [the_s2rtenv_find]

(* ****** ****** *)

implement
the_s2rtenv_find_qua (q, id) = let
(*
  val () = print "the_s2rtenv_find_qua: qid = "
  val () = $SYN.print_s0rtq (q)
  val () = $SYM.print_symbol (id)
  val () = print_newline ()
*)
in
//
case+ q.s0rtq_node of
| $SYN.S0RTQnone _ => the_s2rtenv_find (id)
| $SYN.S0RTQsymdot _ => None_vt ()
//
end // end of [the_s2rtenv_find_qua]

(* ****** ****** *)

implement
the_s2rtenv_pop
  (pfenv | (*none*)) = map where {
  prval unit_v () = pfenv
  prval vbox pf = pf0
  val map = symenv_pop (!p0)
} // end of [the_s2rtenv_pop]

implement
the_s2rtenv_push_nil
  () = (pfenv | ()) where {
  prval vbox pf = pf0
  val () = symenv_push_nil (!p0)
  prval pfenv = unit_v ()
} // end of [the_s2rtenv_push_nil]

(* ****** ****** *)

implement
the_s2rtenv_pervasive_joinwth (map) = let
  prval vbox pf = pf0 in symenv_pervasive_joinwth (!p0, map)
end // end of [fun]

(* ****** ****** *)

end // end of [local]

(* ****** ****** *)

local

viewtypedef s2expenv = symenv (s2itm)
val [l0:addr] (pf | p0) = symenv_make_nil ()
val (pf0 | ()) = vbox_make_view_ptr {s2expenv} (pf | p0)

assume s2expenv_push_v = unit_v

fun
the_s2expenv_find_namespace .<>.
  (id: symbol): s2itmopt_vt = let
  fn f (
    fenv: filenv
  ) :<cloptr1> s2itmopt_vt = let
    val (pf, fpf | p) = filenv_get_s2itmmap (fenv)
    val ans = symmap_search (!p, id)
    prval () = minus_addback (fpf, pf | fenv)
  in
    ans
  end // end of [f]
in
  the_namespace_search (f)
end // end of [the_s2expenv_find_namespace]

in // in of [local]

implement
the_s2expenv_add (id, s2i) = let
  prval vbox pf = pf0 in symenv_insert (!p0, id, s2i)
end // end of [the_s2expenv_add]

(* ****** ****** *)

implement
the_s2expenv_find (id) = let
  val ans = let
    prval vbox pf = pf0 in symenv_search (!p0, id)
  end // end of [val]
in
//
case+ ans of
| Some_vt _ => (fold@ ans; ans)
| ~None_vt () => let
    val ans = the_s2expenv_find_namespace (id)
  in
    case+ ans of
    | Some_vt _ => (fold@ ans; ans)
    | ~None_vt () => let
        prval vbox pf = pf0 in symenv_pervasive_search (!p0, id)
      end // end of [None_vt]
  end // end of [None_vt]
//
end // end of [the_s2expenv_find]

(* ****** ****** *)

implement
the_s2expenv_find_qua (q, id) = let
// (*
  val () = print "the_s2expenv_find_qua: qid = "
  val () = $SYN.print_s0taq (q)
  val () = $SYM.print_symbol (id)
  val () = print_newline ()
// *)
in
//
case+ q.s0taq_node of
| $SYN.S0TAQnone _ => the_s2expenv_find (id)
| $SYN.S0TAQsymdot _ => None_vt ()
| $SYN.S0TAQsymcolon _ => None_vt ()
//
end // end of [the_s2expenv_find_qua]

(* ****** ****** *)

implement
the_s2expenv_pop
  (pfenv | (*none*)) = map where {
  prval unit_v () = pfenv
  prval vbox pf = pf0
  val map = symenv_pop (!p0)
} // end of [the_s2expenv_pop]

implement
the_s2expenv_pop_free
  (pfenv | (*none*)) = () where {
  prval unit_v () = pfenv
  prval vbox pf = pf0
  val () = symenv_pop_free (!p0)
} // end of [the_s2expenv_pop_free]

implement
the_s2expenv_push_nil
  () = (pfenv | ()) where {
  prval vbox pf = pf0
  val () = symenv_push_nil (!p0)
  prval pfenv = unit_v ()
} // end of [the_s2expenv_push_nil]

end // end of [local]

(* ****** ****** *)

implement
the_s2expenv_add_scst (s2c) = let
(*
  val () = begin
    print "s2expenv_add_scst: s2c = "; print (s2c); print_newline ()
    print "s2expenv_add_scst: s2t = "; print (s2cst_get_srt s2c); print_newline ()
  end // end of [val]
*)
  val id = s2cst_get_sym s2c
  val s2cs = (
    case+ the_s2expenv_find (id) of
    | ~Some_vt s2i => begin case+ s2i of
      | S2ITMcst s2cs => s2cs | _ => list_nil ()
      end // end of [Some_vt]
    | ~None_vt () => list_nil ()
  ) : s2cstlst
  val s2i = S2ITMcst (list_cons (s2c, s2cs))
in
  the_s2expenv_add (id, s2i)
end // end of [the_s2expenv_add_scst]

implement
the_s2expenv_add_svar (s2v) = let
  val id = s2var_get_sym (s2v) in the_s2expenv_add (id, S2ITMvar s2v)
end // end of [the_s2expenv_add_svar]

implement
the_s2expenv_add_svarlst
  (s2vs) = list_app_fun (s2vs, the_s2expenv_add_svar)
// end of [the_s2expenv_add_svarlst]

(* ****** ****** *)

local

val the_tmplev = ref_make_elt<int> (0)

in

implement
the_tmplev_get () = !the_tmplev

implement
the_tmplev_inc () =
  !the_tmplev := !the_tmplev + 1
// end of [tmplev_inc]

implement
the_tmplev_dec () =
  !the_tmplev := !the_tmplev - 1
// end of [tmplev_dec]

end // end of [local]

(* ****** ****** *)

local

fun the_s2rtenv_initialize (): void = {
//
  val (pfenv | ()) = the_s2rtenv_push_nil ()
//
// HX: pre-defined predicative sorts
//
  val () = the_s2rtenv_add ($SYM.symbol_INT, S2TEsrt s2rt_int)
  val () = the_s2rtenv_add ($SYM.symbol_BOOL, S2TEsrt s2rt_bool)
  val () = the_s2rtenv_add ($SYM.symbol_ADDR, S2TEsrt s2rt_addr)
  val () = the_s2rtenv_add ($SYM.symbol_CHAR, S2TEsrt s2rt_char)
//
// HX: pre-defined impredicative sorts
//
  val () = the_s2rtenv_add ($SYM.symbol_PROP, S2TEsrt s2rt_prop)
  val () = the_s2rtenv_add ($SYM.symbol_TYPE, S2TEsrt s2rt_type)
  val () = the_s2rtenv_add ($SYM.symbol_T0YPE, S2TEsrt s2rt_t0ype)
  val () = the_s2rtenv_add ($SYM.symbol_VIEW, S2TEsrt s2rt_view)
  val () = the_s2rtenv_add ($SYM.symbol_VIEWTYPE, S2TEsrt s2rt_viewtype)
  val () = the_s2rtenv_add ($SYM.symbol_VIEWT0YPE, S2TEsrt s2rt_viewt0ype)
  val () = the_s2rtenv_add ($SYM.symbol_TYPES, S2TEsrt s2rt_types)
//
  val map = the_s2rtenv_pop (pfenv | (*none*))
  val () = the_s2rtenv_pervasive_joinwth (map)
//
} // end of [trans2_env_initialize]

in // in of [local]

implement
the_trans2_env_initialize () = {
  val () = the_s2rtenv_initialize ()
}

end // end of [local]

(* ****** ****** *)

(* end of [pats_trans2_env.dats] *)
