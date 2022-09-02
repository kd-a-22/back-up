*&---------------------------------------------------------------------*
*& Include YCL122_002_TOP                           - Module Pool      YCL122_002
*&---------------------------------------------------------------------*
PROGRAM YCL122_002.

TABLES SCARR.
DATA : OK_CODE TYPE SY-UCOMM,
       SAVE_OK(20) TYPE C .

DATA : GT_SCARR TYPE TABLE OF SCARR.
