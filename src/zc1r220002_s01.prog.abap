*&---------------------------------------------------------------------*
*& Include          ZC1R220002_S01
*&---------------------------------------------------------------------*


 TABLES : mara, marc.

 SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-t01.
   PARAMETERS       pa_werks type marc-werks OBLIGATORY.
   SELECT-OPTIONS : so_mat for mara-matnr,
                    so_mta for mara-mtart,
                    so_ekg for marc-ekgrp.


   SELECTION-SCREEN end of BLOCK bl1.
