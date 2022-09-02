*&---------------------------------------------------------------------*
*& Report  SAPBC430S_FILL_CLUSTER_TAB                                  *
*&                                                                     *
*&---------------------------------------------------------------------*
*&                                                                     *
*&                                                                     *
*&---------------------------------------------------------------------*

REPORT  ZSAPBC430S_FILL_CLUSTER_TAB_A2                                  .

DATA wa_scarr  TYPE scarr.
DATA wa_spfli  TYPE spfli.
DATA wa_flight TYPE sflight.
data wa_saplane type saplane.

DATA my_error TYPE i VALUE 0.


START-OF-SELECTION.

* Replace # by Your user-number and remove all * from here

  DELETE FROM zscarr_a22.
  DELETE FROM ztspfli_a22.
  DELETE FROM ztsflight_a22.
  DELETE FROM ZSAPLANE_A22.

    SELECT * FROM SAPLANE INTO wa_saplane.
    INSERT INTO ZSAPLANE_A22 VALUES wa_saplane.
  ENDSELECT.


  SELECT * FROM scarr INTO wa_scarr.
    INSERT INTO zscarr_a22 VALUES wa_scarr.
  ENDSELECT.

  IF sy-subrc = 0.
    SELECT * FROM spfli INTO wa_spfli.
      INSERT INTO ztspfli_a22 VALUES wa_spfli.
    ENDSELECT.

    IF sy-subrc = 0.

      SELECT * FROM sflight INTO wa_flight.
        INSERT INTO ztsflight_a22 VALUES wa_flight.
      ENDSELECT.
      IF sy-subrc <> 0.
        my_error = 1.
      ENDIF.
    ELSE.
      my_error = 2.
    ENDIF.
  ELSE.
    my_error = 3.
  ENDIF.

  IF my_error = 0.
    WRITE / 'Data transport successfully finished'.
  ELSE.
    WRITE: / 'ERROR:', my_error.
  ENDIF.
