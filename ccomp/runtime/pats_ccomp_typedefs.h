/***********************************************************************/
/*                                                                     */
/*                         Applied Type System                         */
/*                                                                     */
/***********************************************************************/

/* (*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2011-2012 Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by the
** Free Software Foundation; either version 2.1, or (at your option)  any
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
*) */

/* ****** ****** */

/*
(* Author: Hongwei Xi *)
(* Authoremail: hwxi AT cs DOT bu DOT edu *)
(* Start time: October, 2012 *)
*/

/* ****** ****** */

#ifndef PATS_CCOMP_TYPEDEFS_H
#define PATS_CCOMP_TYPEDEFS_H

/* ****** ****** */

struct atstype_struct ; /* of indefinite size */

/* ****** ****** */

typedef void atsvoid_t0ype ;

/* ****** ****** */

typedef int atstype_int ;
typedef unsigned int atstype_uint ;

typedef long int atstype_lint ;
typedef unsigned long int atstype_ulint ;

typedef long long int atstype_llint ;
typedef unsigned long long int atstype_ullint ;

typedef short int atstype_sint ;
typedef unsigned short int atstype_usint ;

/* ****** ****** */

typedef atstype_lint atstype_ssize ;
typedef atstype_ulint atstype_size ;

/* ****** ****** */

typedef int atstype_bool ; // true/false: 1/0

/* ****** ****** */

typedef char atstype_char ;
typedef signed char atstype_schar ;
typedef unsigned char atstype_uchar ;

/* ****** ****** */

typedef char *atstype_string ;

/* ****** ****** */

typedef float atstype_float ;
typedef double atstype_double ;
typedef long double atstype_ldouble ;

/* ****** ****** */

typedef void *atstype_ptr ;
typedef void *atstype_ref ;

/* ****** ****** */

typedef
struct {
  atstype_arrptr ptr; atstype_size size;
} atstype_arrpsz ;

/* ****** ****** */

#define atstkind_type(tk) tk
#define atstkind_t0ype(tk) tk

/* ****** ****** */

#define atsrefarg0_type(hit) hit
#define atsrefarg1_type(hit) hit*

/* ****** ****** */

#endif /* PATS_CCOMP_TYPEDEFS_H */

/* end of [pats_ccomp_typedefs.h] */
