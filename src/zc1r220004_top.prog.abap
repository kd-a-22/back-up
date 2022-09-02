*&---------------------------------------------------------------------*
*& Include ZC1R220004_TOP                           - Report ZC1R220004
*&---------------------------------------------------------------------*
REPORT zc1r220004 MESSAGE-ID zmcsa22.


CLASS lcl_event_handler DEFINITION DEFERRED.  " 로컬클래스를 글로벌 클래스처럼 선언해서 사용할 수 있게 해주는 구문
TABLES : mast.

DATA :BEGIN OF gs_data,   " structure를 헤다가 있는 인터널티이블로 만들고 싶으면 occurs 0을 쓰면 된다.
        matnr TYPE mast-matnr,
        maktx TYPE makt-maktx,
        stlan TYPE mast-stlan,
        stlnr TYPE mast-stlnr,
        stlal TYPE mast-stlal,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl,
      END OF gs_data,

      gt_data   LIKE TABLE OF gs_data . " 헤더가 있는 table로 만들고 싶으면 with headerlne 구문을 쓰면 된다.



" ALV 관련
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       GCL_HANDLER   TYPE REF TO lcl_event_handler,
       gs_fcat       TYPE lvc_s_fcat,    " alv 에 필드를 등록해줌
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,    " alv 형태
       gs_variant    TYPE disvariant,   " 화면 저장.
       gv_okcode     TYPE sy-ucomm.


DEFINE _clear.
  CLEAR   &1.
  REFRESH &1.

END-OF-DEFINITION.
