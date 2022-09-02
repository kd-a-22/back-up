*&---------------------------------------------------------------------*
*& Include ZBC405_A22_ALV_TOP                       - Report ZBC405_A22_ALV
*&---------------------------------------------------------------------*
REPORT zbc405_a22_alv.

TABLES : sflight.

TYPES :  BEGIN OF typ_flt.
           INCLUDE TYPE sflight.
types : To  type i.
TYPES :    changes_possibLe TYPE icon-id.
TYPES : TANKCAP TYPE SAPLANE-TANKCAP,
        CAP_UNIT TYPE SAPLANE-CAP_UNIT ,
        WEIGHT TYPE SAPLANE-WEIGHT,
        WEI_UNIT TYPE SAPLANE-WEI_UNIT.

types : bnt_text type c LENGTH 10.
TYPES :    light TYPE c LENGTH 1.     " 신호등 담당 필드
TYPES : low_color TYPE c LENGTH 4.    " LOW COLOR 이벤트 담당 필드
TYPES : it_color  TYPE lvc_t_scol.    " CEL 단위로 색이 다르게 하는 이벤트 담당 필드
types : it_styl  type lvc_t_styl.

TYPES : END OF typ_flt.

DATA : gt_flt  TYPE TABLE OF typ_flt, " 데이터를 담을 곳
       gs_flt  TYPE typ_flt,         " WORCK AREA
       ok_code LIKE sy-ucomm.


*" for alv data  선언
DATA : go_container TYPE REF TO cl_gui_custom_container,
       go_alv_grid  TYPE REF TO cl_gui_alv_grid,
       gv_varid     TYPE disvariant,
       gv_save      TYPE c LENGTH 1,
       gs_layout    TYPE lvc_s_layo,
       gt_sort      TYPE lvc_t_sort,
       gs_sort      LIKE LINE OF gt_sort,
       gs_color     TYPE lvc_s_scol,
       gt_fcat      TYPE lvc_t_fcat,
       gs_fcat      TYPE lvc_s_fcat,
       gt_exct      TYPE ui_functions,
       gs_styl      type lvc_s_styl.

***============new alv 수정하고 refresh 할 경우 해당 화면 해당 셀, 해당 컬럼 위치가 고정된 채 화면 바뀌기.
data : gs_stable  type lvc_s_stbl,  " FIELD(ROW,COL)
      gv_soft_refresh  type abap_bool.  " true false로 값을 변환.. 불린 타입인듯.
