*&---------------------------------------------------------------------*
*& Include ZC1R220008_TOP                           - Report ZC1R220008
*&---------------------------------------------------------------------*
REPORT zc1r220008 MESSAGE-ID zmcsa22.

TABLES : ztsa2201.

DATA : BEGIN OF gs_data ,
         mark,
         pernr  TYPE ztsa2201-pernr,
         ename  TYPE ztsa2201-ename,
         entdt  TYPE ztsa2201-entdt,
         gender TYPE ztsa2201-gender,
         depid  TYPE ztsa2201-depid,
         STYLE type lvc_t_styl,
         CARRID  TYPE ZTSA2201-CARRID,
         CARRNAME TYPE SCARR-CARRNAME,
       END OF gs_data,

       gt_data     LIKE TABLE OF gs_data,
       gt_data_del LIKE TABLE OF gs_data.


" alv 관련
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_layout     TYPE lvc_s_layo,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gv_okcode     TYPE sy-ucomm,
       gs_variant    TYPE disvariant,
       gs_stable     TYPE lvc_s_stbl.

DATA : gt_rows TYPE lvc_t_row,  " 사용자가 선택한 행의 정보 저장할 ITAB
       gs_row  TYPE lvc_s_row.
