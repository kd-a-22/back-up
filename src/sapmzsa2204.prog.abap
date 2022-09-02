*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA2204
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa2204_top                            .    " Global Data

INCLUDE mzsa2204_o01                            .  " PBO-Modules
INCLUDE mzsa2204_i01                            .  " PAI-Modules
INCLUDE mzsa2204_f01                            .  " FORM-Routines


LOAD-OF-PROGRAM.

  PERFORM set_default CHANGING zssa0073.
