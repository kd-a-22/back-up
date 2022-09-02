*&---------------------------------------------------------------------*
*& Include          ZC1R220005_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
  PUBLIC SECTION.
  CLASS-METHODS :
  handle_double_click for EVENT double_click of cl_gui_alv_grid
  IMPORTING
    e_row
    e_column.

ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
 METHOD handle_double_click .
   PERFORM HANDLE_DOUBLE_CLICK USING e_row e_column.


   ENDMETHOD.


ENDCLASS.
