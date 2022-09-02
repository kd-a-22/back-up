*&---------------------------------------------------------------------*
*& Report ZRCA22_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca22_01.

DATA gv_num TYPE i.
DO 6 TIMES.
  gv_num = gv_num + 1.
  WRITE sy-index. " -가 붙으면 스트럭쳐.. 스트럭쳐 안에는 컴포넌트들이 있다.
  IF gv_num > 3.
    EXIT.
    ENDIF.
  WRITE gv_num.
  NEW-LINE.
  ENDDO.

  "do는 무조건 반복하라. while 은 특수한 경우 반복하지 마라.(특수한 경우가 되면 반복을 멈춰라.인듯)

**DATA gv_gender TYPE c LENGTH 1. " M, F

***gv_gender = 'M'.
***IF gv_gender = 'M'.
***
***  ELSEIF gv_gender = 'F'.
***
***  ELSE .
***
***
***  ENDIF.
  "부등호 표시가 가능한 것이 if문 문자열로고 부등호를 메길 수 있다. 알파벳이나 가나다라는 순서가 있기 때문..

**  CASE gv_gender.
**   WHEN 'M'.
**   WHEN 'F'.
**   WHEN OTHERS.
** ENDCASE.
