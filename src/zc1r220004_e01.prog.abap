*&---------------------------------------------------------------------*
*& Include          ZC1R220004_E01
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION.

  PUBLIC SECTION .
    CLASS-METHODS :
      on_doubleclick FOR EVENT double_click
        OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no.
ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.

  METHOD: on_doubleclick.

    PERFORM on_doubleclick USING e_column.




  ENDMETHOD.

ENDCLASS.
