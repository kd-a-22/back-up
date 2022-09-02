*&---------------------------------------------------------------------*
*& Report ZRSA22_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA22_06.


PARAMETERS pa_i type i .
PARAMETERS PA_CLASS TYPE C LENGTH 1.
DATA GV_RESULT LIKE PA_I.



*IF PA_I > 20.
* GV_RESULT = PA_I + 10.
* ELSEIF
*  GV_RESULT = PA_I.
*ELSE.
*ENDIF.


* *A,반을 입력하면 100추가

CASE PA_CLASS.
  WHEN 'A'.
    GV_RESULT = PA_I + 100.
  WHEN OTHERS.
  IF PA_I > 20.
    GV_RESULT = PA_I + 10.
    ELSEIF
      GV_RESULT = PA_I.

  ENDIF.

ENDCASE.

WRITE GV_RESULT.






*
**  1.  10 보다 크면 출력..
*if pa_I > 10.
*  WRITE PA_I .
* endif.
*
*
*
**2. 20보다 크면 10을 추가  1) 내가 한 것.  .. 잘못된 것.. 사용자가 입력한 값은 바꾸어서는 안 된다. 이렇게 하면 사용자는 20을 입력했다면 저장되는 것은 30이기 때문에 사용자가 무엇을 입력했는지 정확히 알 수 없다.
**if pa_I > 20.
**PA_I = PA_I + 10.
**  WRITE PA_I .
** endif.
*
*
** 2-1. 20보다 크면 10을 추가  2)강사님이 하신 것 + 20 이상이면 10을 추가하고 20 미만이라면 그 중애서도 10 이상만 출력하라.
*if pa_I > 20.
*
*GV_RESULT = PA_I + 10.
*  WRITE GV_RESULT .
*  ELSE.
*    IF PA_I > 10.
*      WRITE PA_I.
*
*    ENDIF.
*
* endif.
*
*
* IF PA_I > 20.
*
*
* ELSEIF PA_I  > 10.
*
*
*
*ELSE.
*
* ENDIF.
