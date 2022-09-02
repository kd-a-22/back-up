*&---------------------------------------------------------------------*
*& Include ZBC405_A22_SIA_TOP                       - Report ZBC405_A22_SIA
*&---------------------------------------------------------------------*
REPORT zbc405_a22_sia.

DATA: gs_flight TYPE dv_flights.

CONSTANTS gc_mark VALUE 'X'.

SELECT-OPTIONS : so_car FOR gs_flight-carrid MODIF ID car,
                 so_con FOR gs_flight-connid.

SELECT-OPTIONS so_fdt FOR gs_flight-fldate NO-EXTENSION.

SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME.

PARAMETERS: pa_all RADIOBUTTON GROUP rbg1,
            pa_nat RADIOBUTTON GROUP rbg1,
            pa_int RADIOBUTTON GROUP rbg1 DEFAULT 'X'.

SELECTION-SCREEN END OF BLOCK radio.

**selection-SCREEN BEGIN OF LINE.
**
**  SELECTION-SCREEN COMMENT 1(20) text-s01.
**  SELECTION-SCREEN COMMENT pos_low(8) text-S04 for FIELD pa_col.
**
**  SELECTION-SCREEN END OF line.
