*&---------------------------------------------------------------------*
*& Include          YCL122_002_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.

  save_ok = ok_code . CLEAr ok_code.

CASE save_ok.
  WHEN 'BACK'.  LEAVE TO SCREEN 0.
  WHEN 'SEARCH'.
  PERFORM SELECT_DATA.


  WHEN OTHERS.  OK_CODE = SAVE_OK.
ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT_100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_100 INPUT.

save_ok = ok_code . CLEAr ok_code.

CASE save_ok.
  WHEN 'EXIT'.  LEAVE PROGRAM.
  WHEN 'CANC'.  LEAVE TO SCREEN 0.
  WHEN OTHERS.  OK_CODE = SAVE_OK.
ENDCASE.

CLEAR SAVE_OK.



ENDMODULE.
