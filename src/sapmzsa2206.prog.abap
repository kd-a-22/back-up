*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA2204
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE MZSA2206_TOP.
*INCLUDE mzsa2204_top                            .    " Global Data

INCLUDE MZSA2206_O01.
*INCLUDE mzsa2204_o01                            .  " PBO-Modules
INCLUDE MZSA2206_I01.
*INCLUDE mzsa2204_i01                            .  " PAI-Modules
INCLUDE MZSA2206_F01.
*INCLUDE mzsa2204_f01                            .  " FORM-Routines


LOAD-OF-PROGRAM.

  PERFORM set_default CHANGING zssa0073.
  clear: gv_r1, gv_r2, gv_r3.
  gv_r2 = 'X'.
