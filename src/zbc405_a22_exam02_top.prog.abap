*&---------------------------------------------------------------------*
*& Include ZBC405_A22_EXAM01_TOP                    - Report ZBC405_A22_EXAM01
*&---------------------------------------------------------------------*
REPORT zbc405_a22_exam01.

TABLES : ztspfli_a22.


TYPES : BEGIN OF gty_spfli.
          INCLUDE TYPE ztspfli_a22.
TYPES:    ind TYPE c.
TYPES : flight TYPE ICON-ID.    " 비행기 버튼
types : fromtz type SAIRPORT-TIME_ZONE ,
        totz type SAIRPORT-TIME_ZONE.

TYPES : LIGHT TYPE C .  " 신호등.
TYPES : ROW_CLOLOR TYPE C LENGTH 4,
        IT_COLOR TYPE LVC_T_SCOL,
        IS_STYL TYPE LVC_T_STYL,
        IT_STY TYPE LVC_T_STYL,
        modified type c.


TYPES END OF gty_spfli.

DATA : gt_flt TYPE TABLE OF gty_spfli,
       gs_flt TYPE          gty_spfli.

DATA: ok_code    TYPE sy-ucomm,
      go_con     TYPE REF TO cl_gui_custom_container,
      go_alv     TYPE REF TO cl_gui_alv_grid,
      gs_variant TYPE disvariant,
      gs_layout  TYPE lvc_s_layo,
      gt_sort    TYPE lvc_t_sort,
      gs_sort    TYPE lvc_s_sort,
      GS_COLOR   TYPE LVC_S_SCOL,
      gt_fcat    TYPE lvc_t_fcat,
      gs_fcat    TYPE lvc_s_fcat,
      GS_STYL TYPE LVC_S_STYL,
       gt_exct TYPE UI_FUNCTIONS.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS : s_car FOR ztspfli_a22-carrid MEMORY ID CAR,
                   s_con FOR ztspfli_a22-connid MEMORY ID CON.
SELECTION-SCREEN END OF BLOCK b1.




SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT (20) TEXT-t03 .
    PARAMETERS : p_lay TYPE disvariant-variant .
    SELECTION-SCREEN COMMENT pos_high(10) TEXT-t04.
    PARAMETERS p_edit AS CHECKBOX .
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b2 .

PARAMETERS sel as CHECKBOX.
