*&---------------------------------------------------------------------*
*& Report ZC1R220004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r220004_01_top.
*INCLUDE zc1r220004_top                          .    " Global Data

INCLUDE zc1r220004_01_s01.
*INCLUDE zc1r220004_s01 .
INCLUDE zc1r220004_01_class.
*INCLUDE zc1r220004_class.
INCLUDE zc1r220004_01_o01.
*INCLUDE zc1r220004_o01                          .  " PBO-Modules
INCLUDE zc1r220004_01_i01.
*INCLUDE zc1r220004_i01                          .  " PAI-Modules
INCLUDE zc1r220004_01_f01.
*INCLUDE zc1r220004_f01                          .  " FORM-Routines


INITIALIZATION.
  PERFORM init.


START-OF-SELECTION.

  PERFORM get_data.
  PERFORM get_maktx.
  IF sy-subrc = 0.
    CALL SCREEN 100.
  ENDIF.
