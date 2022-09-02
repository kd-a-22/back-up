*&---------------------------------------------------------------------*
*& Include ZC1R220007_TOP                           - Report ZC1R220007
*&---------------------------------------------------------------------*
REPORT zc1r220007 MESSAGE-ID zmcsa22.

CLASS lcl_event_handler DEFINITION DEFERRED.

TABLES : bkpf.

DATA : BEGIN OF gs_data ,
         belnr TYPE bseg-belnr,   "전표번호
         buzei TYPE bseg-buzei, "전표순번
         blart TYPE bkpf-blart, "전표유형
         budat TYPE bkpf-budat, " 전기일지
         shkzg TYPE bseg-shkzg, " 차대지시지
         dmbtr TYPE bseg-dmbtr, "전표금액
         waers TYPE bkpf-waers, "통화기
         hkont TYPE gseg-hkont, "g/l 계졍
       END OF gs_data,

       gt_data LIKE TABLE OF gs_data.
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       GCL_HANDLER   TYPE REF TO lcl_event_handler,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gS_variant    TYPE disvariant.


DEFINE  _clear.
  CLEAR $1.
  REFRESH  &2.
END-OF-DEFINITION.
