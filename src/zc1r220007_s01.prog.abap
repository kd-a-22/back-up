*&---------------------------------------------------------------------*
*& Include          ZC1R220007_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE text-t01.

  PARAMETERS    : pa_buk   type bkpf-bukrs OBLIGATORY,
                  pa_gja   type bkpf-gjahr OBLIGATORY.
  SELECT-OPTIONS: so_belnr for bkpf-belnr,
                  so_blart for bkpf-blart.

  SELECTION-SCREEN END OF BLOCK bl1 .
