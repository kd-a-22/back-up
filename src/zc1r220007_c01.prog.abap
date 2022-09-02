*&---------------------------------------------------------------------*
*& Include          ZC1R220007_C01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.
 PUBLIC SECTION.
   METHODS : HANDL_HOTSPOT FOR EVENT HOTSPOT_CLICK OF cl_gui_alv_grid
   IMPORTING
     E_ROW_ID
     E_COLUMN_ID.


   ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD handl_hotspot.

    PERFORM HANDL_HOTSPOT USING E_ROW_ID E_COLUMN_ID.

    ENDMETHOD.

ENDCLASS.
