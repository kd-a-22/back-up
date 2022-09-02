*&---------------------------------------------------------------------*
*& Include ZC1R220005_TOP                           - Report ZC1R220005
*&---------------------------------------------------------------------*
REPORT zc1r220005 MESSAGE-ID zmcsa22.
TABLES : sflight.

DATA : BEGIN OF gs_list,
         carrid     TYPE sflight-carrid,
         connid     TYPE sflight-connid,
         fldate     TYPE sflight-fldate,
         carrname   TYPE scarr-carrname,
         price      TYPE sflight-price,
         currency   TYPE sflight-currency,
         planetype  TYPE sflight-planetype,
         paymentsum TYPE sflight-paymentsum,
       END OF gs_list,

       gt_list LIKE TABLE OF gs_list,

       BEGIN OF gs_scarr ,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         currcode TYPE scarr-currcode,
         url      TYPE scarr-url,
       END OF gs_scarr,

       gt_scarr LIKE TABLE OF gs_scarr,
       gcl_scarr type REF TO ZCLC1A22_0001.
" ALV  관련
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_sort       TYPE lvc_s_sort,
       gt_sort       TYPE lvc_t_sort,
       gs_variant    TYPE disvariant.
" POPUP ALV 관련
DATA : gcl_container_pop TYPE REF TO cl_gui_custom_container,
       gcl_grid_pop      TYPE REF TO cl_gui_alv_grid,
       gs_fcat_pop       TYPE lvc_s_fcat,
       gt_fcat_pop       TYPE lvc_t_fcat,
       gs_layout_pop     TYPE lvc_s_layo.


DATA : gv_okcode TYPE sy-ucomm.

DEFINE _clear.
  CLEAR &1.
  REFRESH &2.
END-OF-DEFINITION.
