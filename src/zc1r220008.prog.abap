*&---------------------------------------------------------------------*
*& Report ZC1R220008
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc1r220008_top                          .    " Global Data


INCLUDE zc1r220008_s01 .
INCLUDE zc1r220008_c01 .
INCLUDE zc1r220008_o01                          .  " PBO-Modules
INCLUDE zc1r220008_i01                          .  " PAI-Modules
INCLUDE zc1r220008_f01                          .  " FORM-Routines

START-OF-SELECTION.
  PERFORM get_emp_data.
  PERFORM set_style.

*
  CALL SCREEN 100.
*   IF SY-SUBRC NE 0.
*
*     MESSAGE I001.
*
* ENDIF.
