*&---------------------------------------------------------------------*
*& Report ZC1R220002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE ZC1R220002_TOP                          .    " Global Data
INCLUDE ZC1R220002_S01.                              " Selection-screen


 INCLUDE ZC1R220002_O01                          .  " PBO-Modules
 INCLUDE ZC1R220002_I01                          .  " PAI-Modules
 INCLUDE ZC1R220002_F01                          .  " FORM-Routines

 INITIALIZATION.
 PERFORM get_init.

 START-OF-SELECTION.
 PERFORM get_data.
 IF sy-subrc = 0.
   call SCREEN 100.
ELSE.
  MESSAGE i000 WITH '데이터를 불러오지 못했습니다.!'.
 ENDIF.
