*&---------------------------------------------------------------------*
*& Include          ZBC405_A22_EXAM01_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  GET_SHELP  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_shelp INPUT.  " F4 눌렀을 때 HELP REQUEST 나오는 거 하는 부분.

  DATA lt_fli LIKE TABLE OF ztspfli_a22.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'CONNID'
      value_org       = 'S'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'ZTSPFLI_A22-CONNID'  " 선택한 필드의 값이 입력될 화면의 필드
    TABLES
      value_tab       = lt_fli
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.


ENDMODULE.



*****  인터넷에서 긁어온 local class 예문
*****
*****CLASS c_counter DEFINITION.
*****  PUBLIC SECTION.
*****    METHODS :
*****      set_counter IMPORTING VALUE(set_value) TYPE i,
*****      increment_counter,
*****      get_counter EXPORTING VALUE(get_value) TYPE i.
*****  PRIVATE SECTION.
*****    DATA count TYPE i.
*****ENDCLASS.
*****
*****CLASS c_counter IMPLEMENTATION.
*****  METHOD set_counter.
*****    count = set_value.
*****  ENDMETHOD.
*****  METHOD increment_counter.
*****    ADD 1 TO count.
*****  ENDMETHOD.
*****  METHOD get_counter.
*****    get_value = count.
*****  ENDMETHOD.
*****ENDCLASS.
