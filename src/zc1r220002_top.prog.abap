*&---------------------------------------------------------------------*
*& Include ZC1R220002_TOP                           - Report ZC1R220002
*&---------------------------------------------------------------------*
REPORT zc1r220002 MESSAGE-ID zmcsa22.

DATA : BEGIN OF gs_itab,

         matnr TYPE mara-matnr,
         mtart  TYPE mara-mtart,
         matkl TYPE mara-matkl,
         meins TYPE mara-meins,
         tragr TYPE mara-tragr,
         pstat TYPE marc-pstat,
         dismm TYPE marc-dismm,
         ekgrp TYPE marc-ekgrp,
       END OF gs_itab,

       gt_itab LIKE TABLE OF gs_itab,

       GV_OKCODE TYPE SY-UCOMM,
       GS_VARIANT TYPE DISVARIANT.
