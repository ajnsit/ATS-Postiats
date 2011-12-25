(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-20?? Hongwei Xi, ATS Trustful Software, Inc.
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

staload UT = "pats_utils.sats"
staload _(*anon*) = "pats_utils.dats"

(* ****** ****** *)

staload "pats_basics.sats"

(* ****** ****** *)

staload
INTINF = "pats_intinf.sats"
macdef
fprint_intinf = $INTINF.fprint_intinf

(* ****** ****** *)

staload SYM = "pats_symbol.sats"
macdef fprint_symbol = $SYM.fprint_symbol
staload STAMP = "pats_stamp.sats"
macdef fprint_stamp = $STAMP.fprint_stamp
staload SYN = "pats_syntax.sats"

(* ****** ****** *)

staload EFF = "pats_effect.sats"

(* ****** ****** *)

staload "pats_staexp1.sats"
staload "pats_staexp2.sats"

(* ****** ****** *)

implement
fprint_s2rtdat (out, x) = let
  val sym = s2rtdat_get_sym (x) in fprint_symbol (out, sym)
end // end of [fprint_s2rtdat]

(* ****** ****** *)

implement
fprint_s2rtbas (out, x) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
//
case+ x of
| S2RTBASpre (sym) => {
    val () = prstr "S2ETBASpre("
    val () = fprint_symbol (out, sym)
    val () = prstr ")"
  }
| S2RTBASimp (sym, knd) => {
    val () = prstr "S2ETBASimp("
    val () = fprint_symbol (out, sym)
    val () = prstr ")"
  }
| S2RTBASdef (s2td) => {
    val () = prstr "S2ETBASdef("
    val () = fprint_s2rtdat (out, s2td)
    val () = prstr ")"
  }
//
end // end of [fprint_s2rtbas]

(* ****** ****** *)

implement
fprint_s2rt (out, x) = let
//
  val x = s2rt_delink (x)
//
  macdef prstr (s) = fprint_string (out, ,(s))
in
//
case+ x of
| S2RTbas (s2tb) => {
    val () = prstr "S2RTbas("
    val () = fprint_s2rtbas (out, s2tb)
    val () = prstr ")"
  }
| S2RTfun (s2ts, s2t) => {
    val () = prstr "S2RTfun("
    val () = fprint_s2rtlst (out, s2ts)
    val () = prstr "; "
    val () = fprint_s2rt (out, s2t)
    val () = prstr ")"
  }
| S2RTtup (s2ts) => {
    val () = prstr "S2RTtup("
    val () = fprint_s2rtlst (out, s2ts)
    val () = prstr ")"
  }
| S2RTVar _ => {
    val () = prstr "S2RTVar("
    val () = fprint_string (out, "...")
    val () = prstr ")"
  }
//
| S2RTerr () => prstr "S2RTerr()"
//
end // end of [fprint_s2rt]

implement print_s2rt (x) = fprint_s2rt (stdout_ref, x)
implement prerr_s2rt (x) = fprint_s2rt (stderr_ref, x)

implement
fprint_s2rtlst
  (out, xs) = $UT.fprintlst (out, xs, ", ", fprint_s2rt)
// end of [fprint_s2rtlst]
implement print_s2rtlst (xs) = fprint_s2rtlst (stdout_ref, xs)
implement prerr_s2rtlst (xs) = fprint_s2rtlst (stderr_ref, xs)

(* ****** ****** *)

implement
fprint_s2itm (out, x) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
//
case+ x of
| S2ITMcst (s2cs) => {
    val () = prstr "S2ITMcst("
    val () = fprint_s2cstlst (out, s2cs)
    val () = prstr ")"
  }
| S2ITMdatconptr (d2c) => {
    val () = prstr "S2ITMdatconptr("
    val () = fprint_d2con (out, d2c)
    val () = prstr ")"
  }
| S2ITMdatcontyp (d2c) => {
    val () = prstr "S2ITMdatcontyp("
    val () = fprint_d2con (out, d2c)
    val () = prstr ")"
  }
| S2ITMe1xp (e1xp) => {
    val () = prstr "S2ITMe1xp("
    val () = fprint_e1xp (out, e1xp)
    val () = prstr ")"
  }
| S2ITMfil (fenv) => {
    val () = prstr "S2ITMfil("
    val () = $FIL.fprint_filename (out, filenv_get_name fenv)
    val () = prstr ")"
  }
| S2ITMvar (s2v) => {
    val () = prstr "S2ITMvar("
    val () = fprint_s2var (out, s2v)
    val () = prstr ")"
  }
//
end // end of [fprint_s2itm]

implement print_s2itm (xs) = fprint_s2itm (stdout_ref, xs)
implement prerr_s2itm (xs) = fprint_s2itm (stderr_ref, xs)

(* ****** ****** *)

implement
fprint_tyreckind (out, knd) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
  case+ knd of
  | TYRECKINDbox () => fprint_string (out, "box")
  | TYRECKINDflt0 () => fprint_string (out, "flt0")
  | TYRECKINDflt1 (s) => {
      val () = prstr "flt1("
      val () = fprint_stamp (out, s)
      val () = prstr ")"
    } // end of [TYRECKINDflt1]
  | TYRECKINDflt_ext (name) => fprintf (out, "flt_ext(%s)", @(name))
end // end of [fprint_tyreckind]

(* ****** ****** *)

implement
fprint_s2exp (out, x) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
//
case+ x.s2exp_node of
//
| S2Eint (x) => {
    val () = prstr "S2Eint("
    val () = fprint_int (out, x)
    val () = prstr ")"
  }
| S2Eintinf (x) => {
    val () = prstr "S2Eintinf("
    val () = fprint_intinf (out, x)
    val () = prstr ")"
  }
| S2Echar (x) => {
    val () = prstr "S2Echar("
    val () = fprint_char (out, x)
    val () = prstr ")"
  }
//
| S2Ecst (s2c) => {
    val () = prstr "S2Ecst("
    val () = fprint_s2cst (out, s2c)
    val () = prstr ")"
  }
//
| S2Eextype (name, s2ess) => {
    val () = prstr "S2Eextype("
    val () = fprint_string (out, name)
    val () = (
      case+ s2ess of
      | list_nil () => ()
      | list_cons _ => let
          val () = prstr ("; ") in
          $UT.fprintlst (out, s2ess, "; ", fprint_s2explst)
        end // end of [list_cons]
    ) // end of [val]
    val () = prstr ")"
  } // end of [S2Eextype]
//
| S2Evar (x) => {
    val () = prstr "S2Evar("
    val () = fprint_s2var (out, x)
    val () = prstr ")"
  } // end of [S2Evar]
| S2EVar (X) => {
    val () = prstr "S2EVar("
    val () = fprint_s2Var (out, X)
    val () = prstr ")"
  } // end of [S2EVar]
//
| S2Edatconptr (d2c, s2es) => {
    val () = prstr "S2Edatconptr("
    val () = fprint_d2con (out, d2c)
    val () = prstr "; "
    val () = fprint_s2explst (out, s2es)
    val () = prstr ")"
  } // end of [S2Edatconptr]
| S2Edatcontyp (d2c, s2es) => {
    val () = prstr "S2Edatcontyp("
    val () = fprint_d2con (out, d2c)
    val () = prstr "; "
    val () = fprint_s2explst (out, s2es)
    val () = prstr ")"
  } // end of [S2Edatcontyp]
//
| S2Eat (s2e1, s2e2) => {
    val () = prstr "S2Eat("
    val () = fprint_s2exp (out, s2e1)
    val () = prstr "; "
    val () = fprint_s2exp (out, s2e2)
    val () = prstr ")"
  } // end of [S2Eat]
| S2Esizeof (s2e) => {
    val () = prstr "S2Esizeof("
    val () = fprint_s2exp (out, s2e)
    val () = prstr ")"
  }
//
| S2Eapp (s2e_fun, s2es_arg) => {
    val () = prstr "S2Eapp("
    val () = fprint_s2exp (out, s2e_fun)
    val () = prstr "; "
    val () = fprint_s2explst (out, s2es_arg)
    val () = prstr ")"
  } // end of [S2Eapp]
| S2Elam (s2vs_arg, s2e_body) => {
    val () = prstr "S2Elam("
    val () = fprint_s2varlst (out, s2vs_arg)
    val () = prstr "; "
    val () = fprint_s2exp (out, s2e_body)
    val () = prstr ")"
  } // end of [S2Elam]
| S2Efun (
    fc, lin, s2fe, npf, s2es_arg, s2e_res
  ) => {
    val () = prstr "S2Efun("
    val () = fprint_funclo (out, fc)
    val () = prstr "; "
    val () = fprintf (out, "lin=%i", @(lin))
    val () = prstr "; "
    val () = prstr "eff="
    val () = fprint_s2eff (out, s2fe)
    val () = prstr "; "
    val () = fprintf (out, "npf=%i", @(npf))
    val () = prstr "; "
    val () = fprint_s2explst (out, s2es_arg)
    val () = prstr "; "
    val () = fprint_s2exp (out, s2e_res)
    val () = prstr ")"
  } // end of [S2Efun]
| S2Emetfn (opt, s2es_met, s2e_body) => {
    val () = prstr "S2Emetfn("
    val () = fprint_s2explst (out, s2es_met)
    val () = prstr "; "
    val () = fprint_s2exp (out, s2e_body)
    val () = prstr ")"
  } // end of [S2Emetfn]
//
| S2Etop (knd, s2e) => {
    val () = prstr "S2Etop("
    val () = fprintf (out, "knd=%i", @(knd))
    val () = prstr "; "
    val () = fprint_s2exp (out, s2e)
    val () = prstr ")"
  } // end of [S2Etop]
//
| S2Etyarr (s2e_elt, s2es_dim) => {
    val () = prstr "S2Etyarr("
    val () = fprint_s2exp (out, s2e_elt)
    val () = prstr "; "
    val () = fprint_s2explst (out, s2es_dim)
    val () = prstr ")"
  } // end of [S2Etyarr]
| S2Etyrec (knd, npf, ls2es) => {
    val () = prstr "S2Etyrec("
    val () = fprint_tyreckind (out, knd)
    val () = prstr "; "
    val () = fprintf (out, "npf=%i", @(npf))
    val () = prstr "; "
    val () = fprint_labs2explst (out, ls2es)
    val () = prstr ")"
  } // end of [S2Etyrec]
//
| S2Einvar (s2e) => {
    val () = prstr "S2Einvar("
    val () = fprint_s2exp (out, s2e)
    val () = prstr ")"
  } // end of [S2Einvar]
//
| S2Erefarg (knd, s2e) => { // knd=0/1:val/ref
    val () = prstr "S2Erefarg("
    val () = fprint_int (out, knd)
    val () = prstr "; "
    val () = fprint_s2exp (out, s2e)
    val () = prstr ")"
  } // end of [S2Erefarg]
//
| S2Evararg (s2e) => {
    val () = prstr "S2Evararg("
    val () = fprint_s2exp (out, s2e)
    val () = prstr ")"
  } // end of [S2Evararg]
//
| S2Eexi (
    s2vs, s2ps, s2e
  ) => {
    val () = prstr "S2Eexi("
    val () = fprint_s2varlst (out, s2vs)
    val () = prstr "; "
    val () = fprint_s2explst (out, s2ps)
    val () = prstr "; "
    val () = fprint_s2exp (out, s2e)
    val () = prstr ")"
  } // end of [S2Eexi]
| S2Euni (
    s2vs, s2ps, s2e
  ) => {
    val () = prstr "S2Euni("
    val () = fprint_s2varlst (out, s2vs)
    val () = prstr "; "
    val () = fprint_s2explst (out, s2ps)
    val () = prstr "; "
    val () = fprint_s2exp (out, s2e)
    val () = prstr ")"
  } // end of [S2Euni]
//
| S2Ewth (s2e, ws2es) => {
    val () = prstr "S2Ewth("
    val () = fprint_s2exp (out, s2e)
    val () = prstr "; "
    val () = fprint_wths2explst (out, ws2es)
    val () = prstr ")"
  }
//
| S2Eerr () => prstr "S2Eerr()"
//
(*
| _ => prstr "S2E...(...)"
*)
//
end // end of [fprint_s2exp]

implement print_s2exp (x) = fprint_s2exp (stdout_ref, x)
implement prerr_s2exp (x) = fprint_s2exp (stderr_ref, x)

implement
fprint_s2explst
  (out, xs) = $UT.fprintlst (out, xs, ", ", fprint_s2exp)
// end of [fprint_s2explst]

implement print_s2explst (xs) = fprint_s2explst (stdout_ref, xs)
implement prerr_s2explst (xs) = fprint_s2explst (stderr_ref, xs)

(* ****** ****** *)

extern
fun fprint_labs2exp : fprint_type (labs2exp)

implement
fprint_labs2exp (out, x) = {
  val SLABELED (l, name, s2e) = x
  val () = $LAB.fprint_label (out, l)
  val () = fprint_string (out, "=")
  val () = fprint_s2exp (out, s2e)
} // end of [fprint_labs2exp]

implement
fprint_labs2explst (out, xs) =
  $UT.fprintlst (out, xs, ", ", fprint_labs2exp)
// end of [fprint_labs2explst]

(* ****** ****** *)

implement
fprint_wths2explst
  (out, ws2es) = let
  fun loop (
    out: FILEref, ws2es: wths2explst, i: int
  ) : void =
  case+ ws2es of
  | WTHS2EXPLSTnil () => ()
  | WTHS2EXPLSTcons_some
      (knd, s2e, ws2es) => let
      val () = if i > 0 then fprint_string (out, ", ")
      val () = fprint_string (out, "some(")
      val () = fprint_int (out, knd)
      val () = fprint_string (out, "; ")
      val () = fprint_s2exp (out, s2e)
      val () = fprint_string (out, ")")
    in
      loop (out, ws2es, i + 1)
    end // end of [WTHS2EXPLSTcons_some]
  | WTHS2EXPLSTcons_none (ws2es) => let
      val () = if i > 0 then fprint_string (out, ", ")
      val () = fprintf (out, "none()", @())
    in
      loop (out, ws2es, i + 1)
    end // end of [WTHS2EXPLSTcons_none]
in
  loop (out, ws2es, 0)
end // end of [fprint_wths2explst]

(* ****** ****** *)

implement
fprint_s2eff (out, s2fe) =
  case+ s2fe of
  | S2EFFall () => fprint_string (out, "all")
  | S2EFFnil () => fprint_string (out, "nil")
  | S2EFFset (efs, s2es) => {
      val () = fprint_string (out, "set(")
      val () = $EFF.fprint_effset (out, efs)
      val () = fprint_string (out, "; ")
      val () = fprint_s2explst (out, s2es)
      val () = fprint_string (out, ")")
    } // end of [S2EFFset]
// end of [s2eff]

(* ****** ****** *)

implement
fprint_s2qua (out, s2q) = {
  val () = fprint_s2varlst (out, s2q.s2qua_svs)
  val () = fprint_string (out, "; ")
  val () = fprint_s2explst (out, s2q.s2qua_sps)
} // end of [fprint_s2qua]

implement
fprint_s2qualst (out, s2qs) =
  $UT.fprintlst (out, s2qs, "; ", fprint_s2qua)
// end of [fprint_s2qualst]

(* ****** ****** *)

implement
fprint_s2rtext (out, x) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
//
case+ x of
| S2TEsrt (s2t) => {
    val () = prstr "S2TEsrt("
    val () = fprint_s2rt (out, s2t)
    val () = prstr ")"
  }
| S2TEsub _ => {
    val () = prstr "S2TEsub("
    val () = fprint_string (out, "...")
    val () = prstr ")"
  }
| S2TEerr () => prstr "S2TEerr()"
//
end // end of [fprint_s2rtext]

(* ****** ****** *)

implement
fprint_s2exparg (out, s2a) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
//
case+ s2a.s2exparg_node of
| S2EXPARGone () => prstr "S2EXPARGone()"
| S2EXPARGall () => prstr "S2EXPARGall()"
| S2EXPARGseq (s2es) => {
    val () = prstr "S2EXPARGseq("
    val () = fprint_s2explst (out, s2es)
    val () = prstr ")"
  } // end of [S2EXPARGseq]
//
end // end of [fprint_s2exparg]

implement
fprint_s2exparglst (out, xs) =
  $UT.fprintlst (out, xs, ", ", fprint_s2exparg)
// end of [fprint_s2exparglst]

(* ****** ****** *)

implement
fprint_t2mpmarg
  (out, x) = fprint_s2explst (out, x.t2mpmarg_arg)
// end of [fprint_t2mpmarg]

(* ****** ****** *)

implement
fprint_sp2at
  (out, sp2t) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
//
case+ sp2t.sp2at_node of
| SP2Tcon (s2c, s2vs) => {
    val () = prstr "SP2Tcon("
    val () = fprint_s2cst (out, s2c)
    val () = prstr "; "
    val () = fprint_s2varlst (out, s2vs)
    val () = prstr ")"
  } // end of [SP2Tcon]
| SP2Terr () => prstr "SP2Terr()"
//
end // end of [fprint_sp2at]

(* ****** ****** *)

implement
fprint_s2kexp
  (out, s2ke) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
//
case+ s2ke of
| S2KEany () => {
    val () = prstr "S2KEany()"
  }
| S2KEcst (s2c) => {
    val () = prstr "S2KEcst("
    val () = fprint_s2cst (out, s2c)
    val () = prstr ")"
  }
| S2KEapp (_fun, _arg) => {
    val () = prstr "S2KEapp("
    val () = fprint_s2kexp (out, _fun)
    val () = prstr "; "
    val () = fprint_s2kexplst (out, _arg)
    val () = prstr ")"
  }
| S2KEfun () => {
    val () = prstr "S2KEfun()"
  }
| S2KEtyarr (s2ke) => {
    val () = prstr "S2KEtyarr("
    val () = fprint_s2kexp (out, s2ke)
    val () = prstr ")"
  }
| S2KEtyrec (knd, ls2kes) => {
    val () = prstr "S2KEtyrec("
    val () = fprint_tyreckind (out, knd)
    val () = fprint_labs2kexplst (out, ls2kes)
    val () = prstr ")"
  }
| S2KEvar (s2v) => {
    val () = prstr "S2KEvar("
    val () = fprint_s2var (out, s2v)
    val () = prstr ")"
  }
| S2KEerr () => prstr "S2KEerr()"
(*
| _ => prstr "S2KE...(...)"
*)
//
end // end of [fprint_s2kexp]

implement
fprint_s2kexplst (out, xs) =
  $UT.fprintlst (out, xs, ", ", fprint_s2kexp)
// end of [fprint_s2kexplst]

(* ****** ****** *)

extern
fun fprint_labs2kexp : fprint_type (labs2kexp)

implement
fprint_labs2kexp
  (out, x) = {
  val SKLABELED (l, s2ke) = x
  val () = $LAB.fprint_label (out, l)
  val () = fprint_string (out, "=")
  val () = fprint_s2kexp (out, s2ke)
} // end of [fprint_labs2kexp]

implement
fprint_labs2kexplst (out, xs) =
  $UT.fprintlst (out, xs, ", ", fprint_labs2kexp)
// end of [fprint_labs2kexplst]

(* ****** ****** *)

(* end of [pats_staexp2_print.dats] *)
