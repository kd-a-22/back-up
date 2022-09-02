*&---------------------------------------------------------------------*
*& Report ZC1R220005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r220005_top                          .  " Global Data

INCLUDE zc1r220005_s01.
INCLUDE zc1r220005_c01.
INCLUDE zc1r220005_o01                          .  " PBO-Modules
INCLUDE zc1r220005_i01                          .  " PAI-Modules
INCLUDE zc1r220005_f01                          .  " FORM-Routines


START-OF-SELECTION.
  PERFORM get_list.
  PERFORM get_carrname.

  CALL SCREEN 100.
