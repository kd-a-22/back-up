*&---------------------------------------------------------------------*
*& Report ZRSA22_09
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA22_09.


"반복문에서 시스템 변수를 사용하는 것은 쉽지 않다.

DATA : GV_CNT TYPE I.

DATA GV_D TYPE SY-DATUM.
GV_D = SY-DATUM = 365.
CLEAR GV_D.

IF GV_D IS INITIAL.
  WRITE 'NO DATA'.
  ELSE .
    WRITE 'EXITE DATA'.

ENDIF.
*
*DO 10 TIMES.
**  WRITE SY-INDEX.
*  GV_CNT = GV_CNT + 1.
*
*   DO 5 TIMES.
**      WRITE SY-INDEX.
*   ENDDO.
** WRITE SY-INDEX.
** NEW-LINE.
*
*
*
*EXIT.
*ENDDO.
