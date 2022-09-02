*&---------------------------------------------------------------------*
*& Report ZRSA22_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_01.



*WRITE : 'Hello'.
PARAMETERS pa_carr TYPE scarr-carrid.

DATA gs_scarr TYPE scarr.

*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*




SELECT SINGLE * FROM scarr
                INTO gs_scarr
                WHERE carrid = pa_carr.

  IF SY-SUBRC IS NOT INITIAL.
   ELSE.

  ENDIF.
*PERFORM get_data.  "서브푸틴

*******  IF sy-subrc  IS INITIAL.
*******
*******    NEW-LINE.
*******    WRITE:gs_scarr-carrid,
*******          gs_scarr-carrname,
*******          gs_scarr-url.
*******    ELSE.
********      WRITE 'Sorry, no data found!'.<
*******      write text-t01.
*******
*******  ENDIF.

*FORM get_data .
*ENDFORM.
