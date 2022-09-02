*&---------------------------------------------------------------------*
*& Include SAPMZC1220001_TOP                        - Module Pool      SAPMZC1220001
*&---------------------------------------------------------------------*
PROGRAM sapmzc1220001 MESSAGE-ID zmcsa22.  " report 는 여기가 report 로 시작한다.


DATA : BEGIN OF gs_data   ,
         matnr TYPE ztsa2203-matnr, " Material
         werks TYPE ztsa2203-werks, " Plant
         mtart TYPE ztsa2203-mtart, "Mat,Type
         maTkl TYPE ztsa2203-maTkl, "Mat.Group
         menge TYPE ztsa2203-menge, "Quantity
         meins TYPE ztsa2203-meins, "Unit
         dmbtr TYPE ztsa2203-dmbtr, "Price
         waers TYPE ztsa2203-waers, "Currency
       END OF gs_data,
       GT_DATA LIKE TABLE OF GS_DATA,

       gv_okcode TYPE sy-ucomm.

" ALV 관련
DATA : gcl_container TYPE REF TO cl_gui_custom_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gslfcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.
