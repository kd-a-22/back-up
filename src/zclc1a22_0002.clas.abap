class ZCLC1A22_0002 definition
  public
  final
  create public .

public section.

  methods SET_MATERIAL_DESCRIPTION
    importing
      !PI_MATNR type MAKT-MATNR
    exporting
      !PE_CODE type CHAR1
      !PE_MSG type CHAR100
      !EV_MAKTX type MAKT-MAKTX .
protected section.
private section.
ENDCLASS.



CLASS ZCLC1A22_0002 IMPLEMENTATION.


  METHOD set_material_description.

    IF pi_matnr IS INITIAL.
      pe_code = 'E'.
      pe_msg = TEXT-e01.
      EXIT.
    ENDIF.

    SELECT SINGLE maktx
      INTO ev_maktx
      FROM makt
      WHERE matnr = pi_matnr
      AND   spras = sy-langu.

    IF sy-subrc <> 0.
      pe_code = 'E'.
      pe_msg = TEXT-e02.
      EXIT.
    ELSE.
      pe_code = 'S'.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
