*&---------------------------------------------------------------------*
*& Report ZRSA22_07
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_07.


PARAMETERS pa_date TYPE sy-datum.
DATA GV_CONDI_D1 LIKE PA_DATE.
GV_CONDI_D1 = SY-DATUM + 7.

DATA GV_CONDI_D2 LIKE PA_DATE.
GV_CONDI_D2 = SY-DATUM - 7.

DATA GV_CONDI_Y1 LIKE PA_DATE.
GV_CONDI_Y1 = SY-DATUM + 365.

DATA GV_CONDI_Y2 LIKE PA_DATE.
GV_CONDI_Y2 = SY-DATUM - 365.



IF pa_date > GV_CONDI_D1.

WRITE pa_date.
NEW-LINE.
WRITE 'ABAP Dictionary'.

ELSEIF pa_date < GV_CONDI_D2.
 WRITE 'SAPUI5'.

  elseif pa_date > GV_CONDI_Y1.
    write '취업'.

    elseif pa_date < '20220620'.
      write : '교육 준비중'.

ENDIF.

*IF pa_date+7 > SY-DATUM.
*WRITE pa_date.
*NEW-LINE.
*WRITE 'ABAP Dictionary'.
*ENDIF.
