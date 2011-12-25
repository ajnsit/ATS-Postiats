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
// Author: Hongwei Xi (gmhwxi AT gmail DOT com)
// Start Time: June, 2011
//
(* ****** ****** *)

staload UT = "pats_utils.sats"
staload _(*anon*) = "pats_utils.dats"

(* ****** ****** *)

staload "pats_basics.sats"

(* ****** ****** *)

(*
** for T_* constructors
*)
staload "pats_lexing.sats"

(* ****** ****** *)

staload SYN = "pats_syntax.sats"

(* ****** ****** *)

staload "pats_staexp1.sats"
staload "pats_staexp2.sats"
staload "pats_dynexp2.sats"

(* ****** ****** *)

implement
fprint_d2itm (out, x) = let
  macdef prstr (s) = fprint_string (out, ,(s))
in
//
case+ x of
| D2ITMcon d2cs => begin
    prstr "D2ITMcon("; fprint_d2conlst (out, d2cs); prstr ")"
  end // end of [D2ITMcon]
| D2ITMcst d2c => begin
    prstr "D2ITMcst("; fprint_d2cst (out, d2c); prstr ")"
  end // end of [D2ITMcst]
| D2ITMe1xp e1xp => begin
    prstr "D2ITMe1xp("; fprint_e1xp (out, e1xp); prstr ")"
  end // end of [D2ITMe1xp]
| D2ITMmacdef d2m => begin
    prstr "D2ITMmacdef("; fprint_d2mac (out, d2m); prstr ")"
  end // end of [D2ITMmacdef]
| D2ITMmacvar d2v => begin
    prstr "D2ITMmacvar("; fprint_d2var (out, d2v); prstr ")"
  end // end of [D2ITMmacvar]
| D2ITMsymdef d2is => begin
    prstr "D2ITMsymdef("; fprint_d2itmlst (out, d2is); prstr ")";
  end // end of [D2ITMsymdef]
| D2ITMvar d2v => begin
    prstr "D2ITMvar("; fprint_d2var (out, d2v); prstr ")"
  end // end of [D2ITMvar]
// end of [case]
end // end of [fprint_d2item]

implement print_d2itm (x) = fprint_d2itm (stdout_ref, x)
implement prerr_d2itm (x) = fprint_d2itm (stderr_ref, x)

implement
fprint_d2itmlst
  (out, xs) = $UT.fprintlst (out, xs, ", ", fprint_d2itm)
// end of [fprint_d2itmlst]

implement print_d2itmlst (xs) = fprint_d2itmlst (stdout_ref, xs)
implement prerr_d2itmlst (xs) = fprint_d2itmlst (stderr_ref, xs)

(* ****** ****** *)

implement
fprint_p2at
  (out, x) = let
  macdef prstr (x) = fprint_string (out, ,(x))
in
//
case+ x.p2at_node of
| P2Tany () => {
    val () = prstr "P2Tany()"
  }
| P2Tvar (knd, d2v) => {
    val () = prstr "P2Tvar("
    val () = fprint_int (out, knd)
    val () = prstr ", "
    val () = fprint_d2var (out, d2v)
    val () = prstr ")"
  }
| P2Tbool (x) => {
    val () = prstr "P2Tbool("
    val () = fprint_bool (out, x)
    val () = prstr ")"
  }
| P2Tint (x) => {
    val () = prstr "P2Tint("
    val () = fprint_string (out, x)
    val () = prstr ")"
  }
| P2Tchar (x) => {
    val () = prstr "P2Tchar("
    val () = fprint_char (out, x)
    val () = prstr ")"
  }
| P2Tstring (x) => {
    val () = prstr "P2Tstring("
    val () = fprint_string (out, x)
    val () = prstr ")"
  }
| P2Tfloat (x) => {
    val () = prstr "P2Tfloat("
    val () = fprint_string (out, x)
    val () = prstr ")"
  }
| P2Tempty () => {
    val () = prstr "P2Tempty()"
  }
| P2Tcon (knd, d2c, s2qs, s2f, npf, p2ts) => {
    val () = prstr "P2Tcon("
    val () = fprint_int (out, knd)
    val () = prstr "; "
    val () = fprint_d2con (out, d2c)
    val () = prstr "; "
    val () = fprint_s2qualst (out, s2qs)
    val () = prstr "; "
    val () = fprint_s2exp (out, s2f)
    val () = prstr "; "
    val () = fprint_int (out, npf)
    val () = prstr "; "
    val () = fprint_p2atlst (out, p2ts)
    val () = prstr ")"
  }
| P2Tlist (npf, p2ts) => {
    val () = prstr "P2Tlist("
    val () = fprint_int (out, npf)
    val () = prstr "; "
    val () = fprint_p2atlst (out, p2ts)
    val () = prstr ")"
  }
| P2Tlst (p2ts) => {
    val () = prstr "P2Tlst("
    val () = fprint_p2atlst (out, p2ts)
    val () = prstr ")"
  }
| P2Trec (knd, npf, lp2ts) => {
    val () = prstr "P2Ttup("
    val () = fprint_int (out, knd)
    val () = prstr "; "
    val () = fprint_int (out, npf)
    val () = prstr "; "
    val () = fprint_labp2atlst (out, lp2ts)
    val () = prstr ")"
  }
//
| P2Tas (knd, d2v, p2t) => {
    val () = prstr "P2Tas("
    val () = fprint_int (out, knd)
    val () = prstr "; "
    val () = fprint_d2var (out, d2v)
    val () = prstr "; "
    val () = fprint_p2at (out, p2t)
    val () = prstr ")"
  }
| P2Texist (s2vs, p2t) => {
    val () = prstr "P2Texist("
    val () = fprint_s2varlst (out, s2vs)
    val () = prstr "; "
    val () = fprint_p2at (out, p2t)
    val () = prstr ")"
  }
//
| P2Tann (p2t, s2f) => {
    val () = prstr "P2Tann("
    val () = fprint_p2at (out, p2t)
    val () = prstr ", "
    val () = fprint_s2exp (out, s2f)
    val () = prstr ")"
  }
| P2Terr () => prstr "P2Terr()"
(*
| _ => prstr "P2T...(...)"
*)
//
end // end of [fprint_p2at]

implement
print_p2at (x) = fprint_p2at (stdout_ref, x)
implement
prerr_p2at (x) = fprint_p2at (stderr_ref, x)

implement
fprint_p2atlst
  (out, xs) = $UT.fprintlst (out, xs, ", ", fprint_p2at)
// end of [fprint_p2atlst]

implement
print_p2atlst (xs) = fprint_p2atlst (stdout_ref, xs)
implement
prerr_p2atlst (xs) = fprint_p2atlst (stderr_ref, xs)

(* ****** ****** *)

implement
fprint_labp2at
  (out, lp2t) = case+ lp2t of
  | LP2Tnorm (l, p2t) => {
      val () = $LAB.fprint_label (out, l)
      val () = fprint_string (out, "=")
      val () = fprint_p2at (out, p2t)
    } // end of [LP2Tnorm]
  | LP2Tomit () => fprint_string (out, "...")
// end of [fprint_labp2at]

implement
fprint_labp2atlst
  (out, xs) = $UT.fprintlst (out, xs, ", ", fprint_labp2at)
// end of [fprint_p2atlst]

(* ****** ****** *)

implement
fprint_d2exp (out, x) = let
  macdef prstr (x) = fprint_string (out, ,(x))
in
//
case+ x.d2exp_node of
| D2Evar (x) => {
    val () = prstr "D2Evar("
    val () = fprint_d2var (out, x)
    val () = prstr ")"
  } // end of [D2Evar]
//
| D2Ebool (x) => {
    val () = prstr "D2Ebool("
    val () = fprint_bool (out, x)
    val () = prstr ")"
  } // end of [D2Ebool]
| D2Eint (rep) => {
    val () = prstr "D2Eint("
    val () = fprint_string (out, rep)
    val () = prstr ")"
  } // end of [D2Erep]
| D2Echar (x) => {
    val () = prstr "D2Echar("
    val () = fprint_char (out, x)
    val () = prstr ")"
  } // end of [D2Echar]
| D2Estring (x) => {
    val () = prstr "D2Estring("
    val () = fprint_string (out, x)
    val () = prstr ")"
  } // end of [D2Estring]
| D2Efloat (rep) => {
    val () = prstr "D2Efloat("
    val () = fprint_string (out, rep)
    val () = prstr ")"
  } // end of [D2Efloat]
//
| D2Ei0nt (tok) => {
    val- T_INTEGER (_(*base*), rep, _(*sfx*)) = tok.token_node
    val () = prstr "D2Ei0nt("
    val () = fprint_string (out, rep)
    val () = prstr ")"
  } // end of [D2Ei0nt]
| D2Ec0har (tok) => {
    val- T_CHAR (c) = tok.token_node
    val () = prstr "D2Ec0har("
    val () = fprint_char (out, c)
    val () = prstr ")"
  } // end of [D2Ec0har]
| D2Es0tring (tok) => {
    val- T_STRING (str) = tok.token_node
    val () = prstr "D2Es0tring("
    val () = fprint_string (out, str)
    val () = prstr ")"
  } // end of [D2Es0tring]
| D2Ef0loat (tok) => {
    val- T_FLOAT (_(*base*), rep, _(*sfx*)) = tok.token_node
    val () = prstr "D2Ef0loat("
    val () = fprint_string (out, rep)
    val () = prstr ")"
  } // end of [D2Ef0loat]
//
| D2Eempty () => {
    val () = prstr "D2Eempty()"
  } // end of [D2Eempty]
| D2Eextval (s2f, rep) => {
    val () = prstr "D2Eextval("
    val () = fprint_s2exp (out, s2f)
    val () = prstr "; "
    val () = fprint_string (out, rep)
    val () = prstr ")"
  }
//
| D2Ecst (d2c) => {
    val () = prstr "D2Ecst("
    val () = fprint_d2cst (out, d2c)
    val () = prstr ")"
  }
| D2Econ (
    d2c, s2as, npf, _(*loc*), d2es
  ) => {
    val () = prstr "D2Econ("
    val () = fprint_d2con (out, d2c)
    val () = prstr "; "
    val () = $UT.fprintlst (out, s2as, ", ", fprint_s2exparg)
    val () = prstr "; "
    val () = fprint_int (out, npf)
    val () = prstr "; "
    val () = fprint_d2explst (out, d2es)
    val () = prstr ")"
  }
//
| D2Etmpid
    (d2e_id, t2mas) => {
    val () = prstr "D2Etmpid("
    val () = fprint_d2exp (out, d2e_id)
    val () = prstr "; "
    val () = $UT.fprintlst (out, t2mas, "; ", fprint_t2mpmarg)
    val () = prstr ")"
  }
//
| D2Eapplst (d2e, d2as) => {
    val () = prstr "D2Eapplst("
    val () = fprint_d2exp (out, d2e)
    val () = prstr "; "
    val () = fprint_d2exparglst (out, d2as)
    val () = prstr ")"
  }
| D2Eassgn (d2e_l, d2e_r) => {
    val () = prstr "D2Eassgn("
    val () = fprint_d2exp (out, d2e_l)
    val () = prstr " := "
    val () = fprint_d2exp (out, d2e_r)
    val () = prstr ")"
  }
| D2Ederef (d2e) => {
    val () = prstr "D2Ederef("
    val () = fprint_d2exp (out, d2e)
    val () = prstr ")"
  }
//
| D2Elam_dyn (
    lin, npf, p2ts, d2e
  ) => {
    val () = prstr "D2Elam_dyn("
    val () = fprint_int (out, lin)
    val () = prstr "; "
    val () = fprint_int (out, npf)
    val () = prstr "; "
    val () = fprint_p2atlst (out, p2ts)
    val () = prstr "; "
    val () = fprint_d2exp (out, d2e)
    val () = prstr ")"
  } // end of [D2Elam_dyn]
//
| D2Elam_sta (s2vs, s2ps, d2e) => {
    val () = prstr "D2Elam_sta("
    val () = fprint_s2varlst (out, s2vs)
    val () = prstr "; "
    val () = fprint_s2explst (out, s2ps)
    val () = prstr "; "
    val () = fprint_d2exp (out, d2e)
    val () = prstr ")"
  } // end of [D2Elam_sta]
//
| D2Etup (knd, npf, d2es) => {
    val () = prstr "D2Etup(knd="
    val () = fprint_int (out, knd)
    val () = prstr "; npf="
    val () = fprint_int (out, npf)
    val () = prstr "; "
    val () = fprint_d2explst (out, d2es)
    val () = prstr ")"
  } // end of [D2Etup]
| D2Erec (knd, npf, ld2es) => {
    val () = prstr "D2Erec(knd="
    val () = fprint_int (out, knd)
    val () = prstr "; npf="
    val () = fprint_int (out, npf)
    val () = prstr "; "
    val () = fprint_labd2explst (out, ld2es)
    val () = prstr ")"
  } // end of [D2Erec]
| D2Eseq (d2es) => {
    val () = prstr "D2Eseq("
    val () = fprint_d2explst (out, d2es)
    val () = prstr ")"
  } // end of [D2Eseq]
//
| D2Eann_type (d2e, s2f) => {
    val () = prstr "D2Eann_type("
    val () = fprint_d2exp (out, d2e)
    val () = prstr " : "
    val () = fprint_s2exp (out, s2f)
    val () = prstr ")"
  } // end of [D2Eann_type]
| D2Eann_seff (d2e, s2fe) => {
    val () = prstr "D2Eann_seff("
    val () = fprint_d2exp (out, d2e)
    val () = prstr " : "
    val () = fprint_s2eff (out, s2fe)
    val () = prstr ")"
  } // end of [D2Eann_seff]
| D2Eann_funclo (d2e, fc) => {
    val () = prstr "D2Eann_funclo("
    val () = fprint_d2exp (out, d2e)
    val () = prstr " : "
    val () = fprint_funclo (out, fc)
    val () = prstr ")"
  } // end of [D2Eann_funclo]
//
| _ => prstr "D2E...(...)"
//
end // end of [fprint_d2exp]

implement
print_d2exp (x) = fprint_d2exp (stdout_ref, x)
implement
prerr_d2exp (x) = fprint_d2exp (stderr_ref, x)

implement
fprint_d2explst (out, xs) =
  $UT.fprintlst (out, xs, ", ", fprint_d2exp)
// end of [fprint_d2explst]

implement
print_d2explst (xs) = fprint_d2explst (stdout_ref, xs)
implement
prerr_d2explst (xs) = fprint_d2explst (stderr_ref, xs)

(* ****** ****** *)

implement
fprint_labd2exp (out, x) = {
  val $SYN.DL0ABELED (l, d2e) = x
  val () = $SYN.fprint_l0ab (out, l)
  val () = fprint_string (out, "=")
  val () = fprint_d2exp (out, d2e)
} // end of [fprint_labd2exp]

implement
fprint_labd2explst (out, xs) =
  $UT.fprintlst (out, xs, ", ", fprint_labd2exp)
// end of [fprint_labs2explst]

implement
print_labd2explst (xs) = fprint_labd2explst (stdout_ref, xs)
implement
prerr_labd2explst (xs) = fprint_labd2explst (stderr_ref, xs)

(* ****** ****** *)

implement
fprint_d2exparg (out, x) = let
  macdef prstr (x) = fprint_string (out, ,(x))
in
//
case+ x of
| D2EXPARGsta (s2as) => {
    val () = prstr "D2EXPARGsta("
    val () = fprint_s2exparglst (out, s2as)
    val () = prstr ")"
  }
| D2EXPARGdyn
    (npf, _(*loc*), d2es) => {
    val () = prstr "D2EXPARGdyn("
    val () = fprint_int (out, npf)
    val () = prstr "; "
    val () = fprint_d2explst (out, d2es)
    val () = prstr ")"
  }
//
end // end of [fprint_d2exparg]

implement
fprint_d2exparglst (out, xs) =
  $UT.fprintlst (out, xs, ", ", fprint_d2exparg)
// end of [fprint_d2exparglst]

(* ****** ****** *)

implement
fprint_d2ecl (out, x) = let
  macdef prstr (x) = fprint_string (out, ,(x))
in
//
case+ x.d2ecl_node of
| D2Cnone () => {
    val () = prstr "D2Cnone()"
  } // end of [D2Cnone]
| D2Clist (xs) => {
    val () = prstr "D2Clist(\n"
    val () = $UT.fprintlst (out, xs, "\n", fprint_d2ecl)
    val () = prstr "\n)"
  } // end of [D2Clist]
//
| D2Coverload (id, opt) => {
    val () = prstr "D2Coverload("
    val () = $SYN.fprint_i0de (out, id)
    val () = prstr ", "
    val () = (case+ opt of
      | Some d2i => fprint_d2itm (out, d2i)
      | None () => fprint_string (out, "*ERROR*")
    ) : void // end of [val]
    val () = prstr ")"
  } // end of [D2Coverload]
//
| D2Cdatdec (knd, s2cs) => {
    val () = prstr "D2Cdatdec(\n"
    val () = fprint_int (out, knd)
    val () = prstr "; "
    val () = $UT.fprintlst (out, s2cs, ", ", fprint_s2cst)
    val () = prstr "\n)"
  } // end of [D2Cdatdec]
//
| D2Cdcstdec (knd, d2cs) => {
    val () = prstr "D2Cdcstdec("
    val () = fprint_dcstkind (out, knd)
    val () = prstr "; "
    val () = $UT.fprintlst (out, d2cs, ", ", fprint_d2cst)
    val () = prstr ")"
  }
//
| D2Cfundecs _ => {
    val () = prstr "D2Cfundecs(\n"
    val () = prstr "..."
    val () = prstr "\n)"
  } // end of [D2Cfundecs]
| D2Cvaldecs _ => {
    val () = prstr "D2Cvaldecs(\n"
    val () = prstr "..."
    val () = prstr "\n)"
  } // end of [D2Cvaldecs]
| D2Cvaldecs_rec _ => {
    val () = prstr "D2Cvaldecs_rec(\n"
    val () = prstr "..."
    val () = prstr "\n)"
  } // end of [D2Cvaldecs_rec]
| D2Cvardecs _ => {
    val () = prstr "D2Cvardecs(\n"
    val () = prstr "..."
    val () = prstr "\n)"
  } // end of [D2Cvardecs]
//
| _ => prstr "D2C...(...)"
//
end // end of [fprint_d2ecl]

implement
print_d2ecl (x) = fprint_d2ecl (stdout_ref, x)
implement
prerr_d2ecl (x) = fprint_d2ecl (stderr_ref, x)

(* ****** ****** *)

(* end of [pats_dynexp2_print.dats] *)
