*&---------------------------------------------------------------------*
*& Report ZC1R220001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r220001_top                          .    " Global Data

INCLUDE zc1r220001_s01                          .  " PBO-Modules
INCLUDE zc1r220001_o01                          .  " PBO-Modules
INCLUDE zc1r220001_i01                          .  " PAI-Modules
INCLUDE zc1r220001_f01                          .  " FORM-Routines

INITIALIZATION.
  PERFORM init_param.

START-OF-SELECTION.
  PERFORM get_data.

  IF gt_data IS NOT INITIAL.
    CALL SCREEN '0100'.
  ENDIF.
