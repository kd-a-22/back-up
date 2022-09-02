*&---------------------------------------------------------------------*
*& Include ZC1R220006_TOP                           - Report ZC1R220006
*&---------------------------------------------------------------------*
REPORT zc1r220006 MESSAGE-ID ZMCSA22.

TABLES : scarr, sflight.

DATA : BEGIN OF gs_data,
         carrid    TYPE scarr-carrid,
         carrname  TYPE scarr-carrname,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,
         planetype TYPE sflight-planetype,
         price     TYPE sflight-price,
         currency  TYPE sflight-currency,
         url       TYPE scarr-url,
       END OF gs_data,

       gt_data LIKE TABLE OF gs_data.

*       BEGIN OF GS_SAPL,


data : gcl_con type REF TO cl_gui_docking_container,
       gcl_grid type REF TO cl_gui_alv_grid,
       GS_LAYOUT TYPE LVC_S_LAYO,
       gs_fcat type lvc_s_fcat,
       gt_fcat type lvc_t_fcat,
       gv_okcode,
       GS_VARIANT TYPE DISVARIANT.
