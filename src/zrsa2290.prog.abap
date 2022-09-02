*&---------------------------------------------------------------------*
*& Report ZRSA2290
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa2290_top                            .    " Global Data

INCLUDE zrsa2290_o01                            .  " PBO-Modules
INCLUDE zrsa2290_i01                            .  " PAI-Modules
INCLUDE zrsa2290_f01                            .  " FORM-Routines

INITIALIZATION.

AT SELECTION-SCREEN OUTPUT.

AT SELECTION-SCREEN.

START-OF-SELECTION.

  CALL SCREEN 100.
