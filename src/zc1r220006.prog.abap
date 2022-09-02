*&---------------------------------------------------------------------*
*& Report ZC1R220006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r220006_top                          .    " Global Data

INCLUDE zc1r220006_s01.
INCLUDE zc1r220006_c01.
INCLUDE zc1r220006_o01                          .  " PBO-Modules
INCLUDE zc1r220006_i01                          .  " PAI-Modules
INCLUDE zc1r220006_f01                          .  " FORM-Routines

START-OF-SELECTION.

PERFORM get_airline_data.
IF  sy-subrc = 0.
  call SCREEN 100.
ENDIF.
