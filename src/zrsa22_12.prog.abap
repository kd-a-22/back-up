*&---------------------------------------------------------------------*
*& Report ZRSA22_12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_12.


DATA : gv_carrname TYPE scarr-carrname.
PARAMETERS pa_carr TYPE scarr-carrid.




 PERFORM get_airline_name USING pa_carr  "table은 using으로 사용할 수 없는 것 같다...
                       CHANGING gv_carrname.

 PERFORM get_display_name.



*&---------------------------------------------------------------------*
*& Form get_airline_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_airline_name USING p_carr
                     CHANGING VALUE(pa_carrname).
" Get Airline Name
  p_carr = 'ua'.
  SELECT SINGLE carrname FROM scarr
    INTO pa_carrname
    WHERE carrid = p_carr.

    WRITE 'test gv_carrname'.   " 그냥 출력하는 것은 가능하지만
    WRITE gv_carrname.          "얘는 안 된다. 왜냐하면 아직 폼이 다 끝나지 않았기 때문에 아직 gv_carrname에 값이 들어가지 않았다 폼 문장이 끝나야 pa_carrname에 있는 값이 gv_carrname에 들어간다.
    write pa_carrname.          "얘는 출력이 된다.               /  call by reference는 value 를 사용하지 않는 파라미터.. 이렇게 되면 값을 복사하는 것이 아니라 그냥 같은 공간을 사용하게 된다.그래서 폼이 끝나지 않아도 이미 gv_carrnem에 들어가져 있다.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_display_name
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_display_name .
* WRITE gv_carrname.
ENDFORM.
