*&---------------------------------------------------------------------*
*& Include          SAPMZC1220001_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.

leave to SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  F4_WERKS  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_werks INPUT.

  PERFORM f4_werks.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

CASE GV_OKCODE.
  WHEN 'SAVE'.

CLEAR : GV_OKCODE.
PERFORM SAVE_DATA.
  WHEN OTHERS.
ENDCASE.
ENDMODULE.
