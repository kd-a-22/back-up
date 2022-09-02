*&---------------------------------------------------------------------*
*& Include          ZC1R220006_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class LCL_HANDLER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION FINAL.

  PUBLIC SECTION.
    CLASS-METHODS :
      on_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id.


ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) LCL_HANDLER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_handler IMPLEMENTATION.
  METHOD on_hotspot_click.

    PERFORM on_hotspot_click USING e_row_id e_column_id.

  ENDMETHOD.
ENDCLASS.
