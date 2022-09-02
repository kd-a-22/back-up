class ZCL_IM_BADI_22_MX_A22 definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_22_MX .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BADI_22_MX_A22 IMPLEMENTATION.


  method IF_EX_BADI_22_MX~EXIT_MENU_BOOK.

    set PARAMETER ID :
                 'CAR' field Is_book-carrid,
                 'CON' FIELD IS_BOOK-CONNID,
                 'DAY' FIELD IS_BOOK-FLDATE,
                 'BOK' FIELD IS_BOOK-BOOKID.

    CALL TRANSACTION 'BC425_BOOK_DET' AND SKIP FIRST SCREEN.
  endmethod.
ENDCLASS.
