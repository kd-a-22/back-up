*&---------------------------------------------------------------------*
*& Report ZC1R220003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r220003.

TABLES : mara, marc.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS : pa_mwr TYPE mkal-werks DEFAULT '1010',
               pa_ber TYPE pbid-berid DEFAULT '1010',
               pa_pbd TYPE pbid-pbdnr  MODIF ID PAD,
               pa_ver TYPE pbid-versb DEFAULT '00' MODIF ID PAD. " SCREEN-NAME 을 사용할 것이기 때문에 MODIF ID 안 해도 된다.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-t02  .
  PARAMETERS : rb_crt  RADIOBUTTON GROUP rb1 DEFAULT 'X' USER-COMMAND mod,  " 라디오버튼 그룹은 유저커멘드를 하나에만 주면 된다.
               rb_disp RADIOBUTTON GROUP rb1.
SELECTION-SCREEN END OF BLOCK bl2.

SELECTION-SCREEN BEGIN OF BLOCK bl3 WITH FRAME TITLE TEXT-t03.  " BLOCK 은 MODIF ID 사용할 수 없다.
  SELECT-OPTIONS : so_mat  FOR mara-matnr  MODIF ID mra,
                   so_mta  FOR mara-mtart  MODIF ID mra,
                   so_mark FOR mara-matkl  MODIF ID mra,

                   so_ekg  FOR marc-ekgrp  MODIF ID mrc.
  PARAMETERS : so_dpo TYPE marc-dispo MODIF ID mrc,
               so_dam TYPE marc-dismm MODIF ID mrc.
SELECTION-SCREEN END OF BLOCK bl3.




AT SELECTION-SCREEN OUTPUT.
  PERFORM modify_screen.

*&---------------------------------------------------------------------*
*& Form MODIFY_SCREEN
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM modify_screen .


  LOOP AT SCREEN.
*
*    CASE  screen-name.               " SCREEN-NAME 사용
*      WHEN 'PA_PBD' OR 'PA_VER'.
*        screen-input = 0.            " INPUT 을 막을 때는 SCREEN NAME을 사용해도 되지만 화면 전제,,
*        MODIFY SCREEN.               "필드 이름까지 막으려면 필드이름 찾고 하는 것이 복잡해지기 때문에 SCRENE-GOUP1을 사용하는 것이 좋다.
*                                     " 그룹으로 묵으려면 MODIFID를 지정해주어야 한다.
*    ENDCASE.

      CASE  screen-group1.            " SCREEN-GROUP1 + MODIF ID 사용
      WHEN 'PAD'.
        screen-input = 0.
        MODIFY SCREEN.

    ENDCASE.

    CASE 'X'.
      WHEN rb_crt.
        CASE screen-group1.
          WHEN 'MRC'.
            screen-active = 0.
            MODIFY SCREEN.
        ENDCASE.

      WHEN rb_disp.                 " SCREEN-GROUP1 + MODIF ID 사용
        CASE screen-group1.
          WHEN 'MRA'.
            screen-active = 0.
            MODIFY SCREEN.
        ENDCASE.
    ENDCASE.


*
*    IF  screen-group1 = 'PBD' .     " 내가 사용한 방법.
*      screen-input = 0.
*      MODIFY SCREEN.
*    ENDIF.
*    IF  screen-group1 = 'VER'.
*      screen-input = 0.
*      MODIFY SCREEN.
*    ENDIF.
*
*    CASE  'X'.
*
*      WHEN rb_crt.
*        IF
*         screen-group1 = 'MRC'.
*          screen-active = 0.
*          screen-input = 0.
*          MODIFY SCREEN.
*        ENDIF.
*
*      WHEN rb_disp.
*        IF screen-group1 = 'MRA'.
*          screen-input = 0.
*          screen-active = 0.
*          MODIFY SCREEN.
*        ENDIF.
*    ENDCASE.
*
*
*
  ENDLOOP.

ENDFORM.
