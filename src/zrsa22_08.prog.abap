*&---------------------------------------------------------------------*
*& Report ZRSA22_08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_08.


PARAMETERS pa_date TYPE sy-datum.
PARAMETERS PA_CODE TYPE C LENGTH 4 DEFAULT 'SYNC'.
DATA GV_CONDI_D1 LIKE PA_DATE.

GV_CONDI_D1 = SY-DATUM + 7.


CASE PA_CODE.
  WHEN 'SYNC'.
IF PA_DATE > GV_CONDI_D1.
  WRITE 'ABPA Dictionory'(T02).
  ELSE.
WRITE 'ABAP Workbench'(T01).
ENDIF.
    WHEN OTHERS.
        WRITE '다음기회에'(T03).
        EXIT.   "또는 RETURN   "이 아래 문장을 다 ㅂ바져 나간다. IF문도 타지 않는다.
 ENDCASE.






*CASE PA_CODE.
*  WHEN 'SYNC'.
*
*    WHEN OTHERS.
*        WRITE '다음기회에'(T03).
*        EXIT.   "또는 RETURN   "이 아래 문장을 다 ㅂ바져 나간다. IF문도 타지 않는다.
* ENDCASE.
*IF PA_DATE > GV_CONDI_D1.
*  WRITE 'ABPA Dictionory'(T02).
*  ELSE.
*
*
*WRITE 'ABAP Workbench'(T01).
*ENDIF.
