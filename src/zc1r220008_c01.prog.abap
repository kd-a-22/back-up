*&---------------------------------------------------------------------*
*& Include          ZC1R220008_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS :
      handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,

          HANDLE_CHANGE_FINISHED FOR EVENT DATA_CHANGED_FINISHED OF cl_gui_alv_grid
          IMPORTING E_MODIFIED ET_GOOD_CELLS.
ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handle_data_changed.
    PERFORM HANDLE_DATA_CHANGED USING ER_DATA_CHANGED.
    ENDMETHOD.

    METHOD handle_change_finished.
      PERFORM HANDLE_CHANGE_FINISHED USING E_MODIFIED ET_GOOD_CELLS.
      ENDMETHOD.
ENDCLASS.
