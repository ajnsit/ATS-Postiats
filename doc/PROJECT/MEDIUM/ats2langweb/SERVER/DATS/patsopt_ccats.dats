(*
//
// [patsopt]:
// *.dats -> *_dats.c
//
*)

(* ****** ****** *)
//
#define ATS_DYNLOADFLAG 0
//
#define
ATS_EXTERN_PREFIX "atslangweb_"
#define
ATS_STATIC_PREFIX "_atslangweb_patsopt_ccats_"
//
(* ****** ****** *)
//
staload
UN = "prelude/SATS/unsafe.sats"
//
(* ****** ****** *)
//
#define
LIBATSCC2PHP_targetloc
"$PATSHOME\
/contrib/libatscc2php/ATS2-0.3.2"
//
(* ****** ****** *)
//
#include
"{$LIBATSCC2PHP}/staloadall.hats"
//
(* ****** ****** *)

staload "./../SATS/atslangweb.sats"

(* ****** ****** *)

implement
{}(*tmp*)
patsopt_ccats_command
(
  stadyn
, fname_dats, fname_dats_c, fname_dats_log
) = let
//
val
patsopt = patsopt_command<> ()
//
val
fname_dats =
  $UN.castvwtp1{string}(fname_dats)
val
fname_dats_c =
  $UN.castvwtp1{string}(fname_dats_c)
val
fname_dats_log =
  $UN.castvwtp1{string}(fname_dats_log)
//
val
stadyn =
(
if (stadyn = 0) then "--static" else "--dynamic"
) : string // end of [val]
//
in
//
$extfcall
(
  string, "sprintf"
, "%s 2>%s --output %s %s %s"
, patsopt, fname_dats_log, fname_dats_c, stadyn, fname_dats
) (* end of [$extfcall] *)
//
end // end of [patsopt_ccats_command]

(* ****** ****** *)

implement
{}(*tmp*)
patsopt_ccats_cont
  (fname_dats_c) =
(
  COMPRES0_succ (tmpfile2string(fname_dats_c))
) (* end of [patsopt_ccats_cont] *)

(* ****** ****** *)

implement
{}(*tmp*)
patsopt_ccats_code
  (stadyn, ptext) =
  ccats_res where
{
//
val pfx = "patsopt_ccats_"
//
val
fname_dats =
tmpfile_make_string(pfx, ptext)
//
val
ccats_res =
patsopt_ccats_file(stadyn, fname_dats)
//
val
unlink_ret = tmpfile_unlink(fname_dats)
//
} (* end of [patsopt_ccats_code] *)

(* ****** ****** *)

implement
{}(*tmp*)
patsopt_ccats_file
(
  stadyn, fname_dats
) = ccats_res where
{
//
val fname_dats_c =
  tmpfile_make_nil ("patsopt_ccats_")
val fname_dats_log =
  tmpfile_make_nil ("patsopt_ccats_")
//
val
command =
patsopt_ccats_command
(
  stadyn
, fname_dats, fname_dats_c, fname_dats_log
) (* patsopt_ccats_command *)
//
(*
val () = prerrln! ("command = ", command)
*)
//
val
exec_ret = exec_retval(command)
//
val
ccats_res = (
//
if exec_ret = 0
  then let
    val compres =
      patsopt_ccats_cont<> (fname_dats_c)
    val unlink_ret = tmpfile_unlink (fname_dats_c)
  in
    compres
  end // end of [then]
  else let
    val errmsg = tmpfile2string (fname_dats_log)
    val unlink_ret = tmpfile_unlink (fname_dats_c)
  in
    COMPRES1_fail (errmsg)
  end (* end of [else] *)
// end of [if]
) : compres // end of [val]
//
val unlink_ret = tmpfile_unlink (fname_dats_log)
//
} (* end of [patsopt_ccats_file] *)

(* ****** ****** *)

(* end of [patsopt_ccats.dats] *)
