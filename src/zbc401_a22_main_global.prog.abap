*&---------------------------------------------------------------------*
*& Report ZBC401_A22_MAIN_GLOBAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC401_A22_MAIN_GLOBAL.


data : go_airplane type REF TO zcl_airplane_a22.
data : gt_airplanes type table of REF TO zcl_airplane_a22.

START-OF-SELECTION.

call method zcl_airplane_a22=>display_n_o_airplanes.

*create OBJECT go_airplane

CREATE OBJECT go_airplane
  EXPORTING
    iv_name         = 'LH Berlin'
    iv_planetype    = '757F'
  EXCEPTIONS
    wrong_planetype = 1
        .
IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplanes.
  ENDIF.



CREATE OBJECT go_airplane
  EXPORTING
    iv_name         = 'LH Berlin'
    iv_planetype    = 'A321'
  EXCEPTIONS
    wrong_planetype = 1
        .
IF sy-subrc = 0.
    APPEND go_airplane TO gt_airplanes.
  ENDIF.





  LOOP AT gt_airplanes INTO go_airplane.

    CALL METHOD go_airplane->display_attribute.
  ENDLOOP.
