class ZCLC1A22_0001 definition
  public
  final
  create public .

public section.

  methods GET_AIRLINE_INFO
    importing
      !PI_CARRID type SCARR-CARRID
    exporting
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100
    changing
      !ET_AIRLINE type ZC1TT22001 .
protected section.
private section.
ENDCLASS.



CLASS ZCLC1A22_0001 IMPLEMENTATION.


  METHOD get_airline_info.

    IF pi_carrid IS INITIAL.
      pe_code = 'E'.
      pe_msg  = TEXT-e01.
      EXIT.
    ENDIF.


    SELECT carrid carrname currcode url
      INTO CORRESPONDING FIELDS OF TABLE et_airline
      FROM scarr
      WHERE carrid = pi_carrid.

    IF sy-subrc <> 0.
      pe_code = 'E'.          " 펑션을 불러와서 데이터를 가져오는 경우 subrc는 펑션에 대한 것만 띄운다.
      pe_msg = TEXT-e02.      "그래서 결국 결과가 잘 나왔는지 알 수 있는 방법은 펑션에서 메시지를 띄워주는 것 밖에 없다.
      EXIT.                   " 메시지타입으로 알려주는 방법 밖에 없다.
    ELSE.
      pe_code = 'S'.

    ENDIF.


  ENDMETHOD.
ENDCLASS.
