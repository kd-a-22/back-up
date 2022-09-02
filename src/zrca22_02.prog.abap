*&---------------------------------------------------------------------*
*& Report ZRCA22_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca22_02.

DATA gv_step TYPE i.
DATA gv_lev TYPE i.
DATA gv_cal TYPE i.
PARAMETERS pa_til TYPE i.
PARAMETERS pa_syear(1) TYPE c.  " 학년.. 문자에 가가운 숫자이기 때문에 c타입.
DATA gv_new_lev LIKE gv_lev.



*****3. 학년에 따라 다르게 구구단을 출력
"1학년은 최대 3단까지만 출력
"2학년은 최대 5까지
"3학년은 7,
"4학년 이상은 최대 9단까지 출력
CASE pa_syear.
  WHEN '1'.
    IF  pa_til >= 3.
      gv_new_lev = 3.
      ELSE.
         gv_new_lev = pa_til.
    ENDIF.
  WHEN '2'.
      IF pa_til >= 5.
        gv_new_lev = 5.
        ELSE.
          gv_new_lev = pa_til.
      ENDIF.
  WHEN '3'.
      IF pa_til >= 7.
      gv_new_lev = 7.
       ELSE.
          gv_new_lev = pa_til.
      ENDIF.

 when '4'.
   if pa_til >= 9.
     gv_new_lev = 9.
     else.
       gv_new_lev = pa_til.
       endif.

 when '5'.
   if pa_til >= 9.
     gv_new_lev = 9.
     else.
       gv_new_lev = pa_til.
       endif.

when '6'.
  if pa_til >= 0 .
    gv_new_lev = 9.
    else.
      gv_new_lev = 9.
      endif.
  WHEN OTHERS.
message 'Message text' type 'i'.

ENDCASE.




*****1.구구단을 9단까지 출력
*DO 9 TIMES.
*gv_lev = gv_lev + 1.
*
* DO 9 TIMES.
*  gv_step = gv_step + 1.
*  gv_cal = gv_lev * gv_step.   "gv_cal = 1 * gv_step.
*  WRITE  gv_lev && '*' && gv_step && ' = ' && gv_cal.      " WRITE: '1*', gv_step, '=' , gv_cal.
*  NEW-LINE.
* ENDDO.
*
*CLEAR gv_step.
*WRITE '==============================='.
*NEW-LINE.
*ENDDO.



*****2.단계를 입력하면 단계까지만 출력.
DO gv_new_lev TIMES.   " 3단계에서 이 라인의 구문은 gv_new_lev로 바뀐다.
gv_lev = gv_lev + 1.

 DO 9 TIMES.
  gv_step = gv_step + 1.
  gv_cal = gv_lev * gv_step.   "gv_cal = 1 * gv_step.
  WRITE  gv_lev && '*' && gv_step && ' = ' && gv_cal.      " WRITE: '1*', gv_step, '=' , gv_cal.
  NEW-LINE.
 ENDDO.

CLEAR gv_step.
WRITE '==============================='.
NEW-LINE.
ENDDO.




data : begin of itab,
   matnr like mara-matnr,
   ersda like mara-ersda,
  mtart like mara-mtart,
  end of itab.
