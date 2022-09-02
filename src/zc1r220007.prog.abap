
*&---------------------------------------------------------------------*
*& Report ZC1R220007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r220007_top                          .    " Global Data

INCLUDE zc1r220007_s01 .
INCLUDE zc1r220007_c01 .
INCLUDE zc1r220007_o01                          .  " PBO-Modules
INCLUDE zc1r220007_i01                          .  " PAI-Modules
INCLUDE zc1r220007_f01                          .  " FORM-Routines

INITIALIZATION.
  PERFORM init_para.

START-OF-SELECTION.
  PERFORM get_belnr.
  IF sy-subrc IS NOT INITIAL.
    EXIT.
  ENDIF.
  CALL SCREEN 100.
