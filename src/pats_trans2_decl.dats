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

staload ERR = "pats_error.sats"

(* ****** ****** *)

staload SYM = "pats_symbol.sats"
overload = with $SYM.eq_symbol_symbol

(* ****** ****** *)

staload "pats_staexp1.sats"
staload "pats_dynexp1.sats"
staload "pats_staexp2.sats"
staload "pats_dynexp2.sats"

(* ****** ****** *)

staload "pats_trans2.sats"
staload "pats_trans2_env.sats"

(* ****** ****** *)

#define l2l list_of_list_vt

(* ****** ****** *)

fn s1rtdef_tr
  (d: s1rtdef): void = let
  val id = d.s1rtdef_sym
  val s2te = s1rtext_tr (d.s1rtdef_def)
in
  the_s2rtenv_add (id, s2te)
end // end of [s1rtdef_tr]

(* ****** ****** *)

fn s1tacst_tr
  (d: s1tacst): void = let
//
  fun aux (
    xs: a1msrtlst, res: s2rt
  ) : s2rt =
    case+ xs of
    | list_cons (x, xs) =>
        s2rt_fun (a1msrt_tr (x), aux (xs, res))
      // end of [list_cons]
    | list_nil () => res
  // end of [aux]
//
  val id = d.s1tacst_sym
  val loc = d.s1tacst_loc
  val s2t_res = s1rt_tr (d.s1tacst_res)
  val s2t_cst = aux (d.s1tacst_arg, s2t_res)
  val s2c = s2cst_make (
    id // sym
  , loc // location
  , s2t_cst // srt
  , None () // isabs
  , false // iscon
  , false // isrec
  , false // isasp
  , None () // islst
  , list_nil () // argvar
  , None () // def
  ) // end of [s2cst_make]
in
  the_s2expenv_add_scst (s2c)
end // end of [s1tacst_tr]

(* ****** ****** *)

(*
typedef
s1tacon = '{ // static constructor declaration
  s1tacon_loc= location
, s1tacon_sym= symbol
, s1tacon_arg= a1msrtlst
, s1tacon_def= s1expopt
} // end of [s1tacon]
*)

fn s1tacon_tr (
  s2t_res: s2rt, d: s1tacon
) : void = let
  val id = d.s1tacon_sym
  val loc = d.s1tacon_loc
//
  val argvar = let
    fn f1 (x: a1srt): syms2rt = let
      val sym = (case+ x.a1srt_sym of
        | None () => $SYM.symbol_empty | Some sym => sym
      ) : symbol
      val s2t = s1rt_tr (x.a1srt_srt)
    in
      (sym, s2t)
    end
    fn f2 (x: a1msrt): syms2rtlst = l2l (list_map_fun (x.a1msrt_arg, f1))
  in
    l2l (list_map_fun (d.s1tacon_arg, f2))
  end : List (syms2rtlst) // end of [val]
//
  val s2t_fun = let
    fun aux (
      s2t_res: s2rt, xss: List (syms2rtlst)
    ) : s2rt =
      case+ xss of
      | list_cons (xs, xss) => let
          val s2ts_arg = l2l (list_map_fun<syms2rt><s2rt> (xs, lam x =<0> x.1))
          val s2t_res = s2rt_fun (s2ts_arg, s2t_res)
        in
          aux (s2t_res, xss)
        end
      | list_nil () => s2t_res
    // end of [aux]
  in
    aux (s2t_res, argvar)
  end : s2rt // end of [val]
//
  val (pf_s2expenv | ()) = the_s2expenv_push_nil ()
  val s2vss = let
    fun f1 (x: syms2rt): s2var =
      if x.0 = $SYM.symbol_empty then
        s2var_make_srt (x.1) else s2var_make_id_srt (x.0, x.1)
      // end of [if]
    fun f2 (
      xs: syms2rtlst
    ) : s2varlst = let
      val s2vs = l2l (list_map_fun (xs, f1))
      val () = the_s2expenv_add_svarlst (s2vs)
    in
      s2vs
    end // end of [f2]
  in
    l2l (list_map_fun (argvar, f2))
  end : List (s2varlst) // end of [val]
  val def = let
    fun aux (
      s2t_fun: s2rt, s2vss: List (s2varlst), s2e: s2exp
    ) : s2exp =
      case+ s2vss of
      | list_cons (s2vs, s2vss) => let
          val- S2RTfun (_, s2t1_fun) = s2t_fun
        in
          s2exp_lam_srt (s2t_fun, s2vs, aux (s2t1_fun, s2vss, s2e))
        end // end of [list_cons]
      | list_nil () => s2e
   in
     case+ d.s1tacon_def of
     | Some s1e => let
         val s2e =
           s1exp_trdn (s1e, s2t_res)
         // end of [val]
         val s2e_def = aux (s2t_fun, s2vss, s2e)
       in
         Some s2e_def
       end // end of [Some]
     | None () => None ()
  end : s2expopt // end of [val]
  val () = the_s2expenv_pop_free (pf_s2expenv | (*none*))
  val s2c = s2cst_make (
      id // sym
    , loc // location
    , s2t_fun // srt
    , Some def // isabs
    , true // iscon
    , false // isrec
    , false // isasp
    , None () // islst
    , argvar // argvar
    , None () // def
    ) // end of [s2cst_make]
  // end of [val]
in
  the_s2expenv_add_scst (s2c)
end // end of [s1tacon_tr]

fn s1taconlst_tr (
  knd: int, ds: s1taconlst
) : void = let
  fun aux (s2t: s2rt, ds: s1taconlst): void =
    case+ ds of
    | list_cons (d, ds) => let
        val () = s1tacon_tr (s2t, d) in aux (s2t, ds)
      end
    | list_nil () => ()
  // end of [aux]
  val s2t_res = s2rt_impredicative (knd)
in
  aux (s2t_res, ds)
end // end of [s1taconlst_tr]

(* ****** ****** *)

implement
d1ecl_tr (d1c0) = let
  val loc0 = d1c0.d1ecl_loc
in
//
case+ d1c0.d1ecl_node of
| D1Cnone () => d2ecl_none (loc0)
| D1Clist (ds) => let
    val ds = l2l (list_map_fun (ds, d1ecl_tr))
  in
    d2ecl_list (loc0, ds)
  end // end of [D1Clist]
| D1Ce1xpdef (id, def) => let
    val () = the_s2expenv_add (id, S2ITMe1xp def)
(*
    val () = the_d2expenv_add (id, D2ITMe1xp def)
*)
  in
    d2ecl_none (loc0)
  end // end of [D1Ce1xpdef]
| D1Csrtdefs (ds) => let
    val () = list_app_fun (ds, s1rtdef_tr) in d2ecl_none (loc0)
  end // end of [D1Csrtdefs]
| D1Cstacsts (ds) => let
    val () = list_app_fun (ds, s1tacst_tr) in d2ecl_none (loc0)
  end // end of [D1Cstacsts]
| D1Cstacons (knd, d1cs) => let
    val () = s1taconlst_tr (knd, d1cs) in d2ecl_none (loc0)
  end // end of [D1Cstacons]
| _ => let
    val () = $LOC.prerr_location (loc0)
    val () = prerr ": d1ecl_tr: not implemented: d1c0 = "
    val () = fprint_d1ecl (stderr_ref, d1c0)
    val () = prerr_newline ()
    val () =  $ERR.abort ()
  in
    d2ecl_none (loc0)
  end // end of [_]
//
end // end of [d1ec_tr]

(* ****** ****** *)

implement
d1eclist_tr (d1cs) = l2l (list_map_fun (d1cs, d1ecl_tr))

(* ****** ****** *)

(* end of [pats_trans2_decl.dats] *)
