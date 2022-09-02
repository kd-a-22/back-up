*&---------------------------------------------------------------------*
*& Report ZRSA22_13
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_13.


DATA: gv_a VALUE 'A',
      gv_b VALUE 'B',
      gv_c VALUE 'C',
      gv_d VALUE 'D'.

PERFORM test  USING gv_a gv_b
              CHANGING gv_c gv_d.

NEW-LINE.

WRITE: 'PERFORM End: ', gv_a, gv_b, gv_c, gv_d.




*
*
*parameters : pa_int1 type i, pa_int2 type i, pa_op type c LENGTH 1.
*
*data gv_result type c LENGTH 7.
*
*PERFORM get_compute USING pa_int1
*                          pa_int2
*                          pa_op.
*
*
**&---------------------------------------------------------------------*
**& Form get_compute
**&---------------------------------------------------------------------*
**& text
**&---------------------------------------------------------------------*
**& -->  p1        text
**& <--  p2        text
**&---------------------------------------------------------------------*
*FORM get_compute USING VALUE(p_num1)
*                        VALUE(p_num2)
*                        VALUE(p_mult).
*
*
*
*
*CASE p_mult.
*  WHEN '+'.
*  gv_result = p_num1 + p_num2.
*  write: p_num1 , p_mult , p_num2 , '=',gv_result.
*  WHEN '-'.
*    gv_result = p_num1 + p_num2.
*  write: p_num1 , p_mult , p_num2 , '=',gv_result.
*  wHEN '*'.
*    gv_result = p_num1 + p_num2.
*  write: p_num1 , p_mult , p_num2 , '=',gv_result.
*  WHEN '/'.
*   gv_result = p_num1 + p_num2.
*  write: p_num1 , p_mult , p_num2 , '=',gv_result.
*  WHEN OTHERS.
*    write '올바른 연산자를 입력하세요'.
*ENDCASE.
*
*
*ENDFORM.




*&---------------------------------------------------------------------*
*& Form test
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM test USING   VALUE(p_a)
                  p_b
          CHANGING VALUE(p_c)
                  p_d.
  p_a = 'a'.
  p_b = 'b'.
  p_c = 'c'.
  p_d = 'd'.

  WRITE: 'PERFORM Int: ', gv_a, gv_b, gv_c, gv_d.

ENDFORM.
