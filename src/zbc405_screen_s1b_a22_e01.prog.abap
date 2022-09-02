*&---------------------------------------------------------------------*
*& Include BC405_SCREEN_S1B_E01                                        *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&   Event INITIALIZATION
*&---------------------------------------------------------------------*
INITIALIZATION.
  push_but = 'detail'.
  gv_change = 1.
*  * Initialize select-options for CARRID" OPTIONAL
  MOVE: 'AA' TO so_car-low,
        'QF' TO so_car-high,
        'BT' TO so_car-option,
        'I'  TO so_car-sign.
  APPEND so_car.

  CLEAR so_car.
  MOVE: 'AZ' TO so_car-low,
        'EQ' TO so_car-option,
        'E'  TO so_car-sign.
  APPEND so_car.

* Set texts for tabstrip pushbuttons
  tab1 = 'Connections'(tl1).
  tab2 = 'Date'(tl2).
  tab3 = 'Type of flight'(tl3).
  tab4 = 'Country From'.

* Set second tab page as initial tab
  airlines-activetab = 'CONT'.
  airlines-dynnr     = '1400'.


AT SELECTION-SCREEN OUTPUT.
  IF sy-dynnr = '1400'.
    LOOP AT SCREEN.
      IF screen-group1 = 'DET'.
         screen-active = gv_change.

         IF gv_change = '1'.
      push_but = 'Hide'.
    ELSE.
      push_but = 'Show'.
    ENDIF.



        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.


AT SELECTION-SCREEN.

  CASE sscrfields-ucomm.
    WHEN 'DETA'.
      CHECK sy-dynnr = '1400'.
      IF gv_change = '1'.
        gv_change = '0'.
      ELSE.
        gv_change = '1'.
      ENDIF.
*    MESSAGE i016(pn) with 'This is pushButton test'.

  ENDCASE.





*----------------------------------------------------------------------*
START-OF-SELECTION.
* Checking the output parameters
  CASE gc_mark.
    WHEN pa_all.
*     Radiobutton ALL is marked
      SELECT * FROM dv_flights INTO gs_flight
        WHERE carrid IN so_car
          AND connid IN so_con
          AND fldate IN so_fdt
          AND countryfr IN s_cifr
          AND cityfrom IN s_cifr.

        WRITE: / gs_flight-carrid,
                 gs_flight-connid,
                 gs_flight-fldate,
                 gs_flight-countryfr,
                 gs_flight-cityfrom,
                 gs_flight-airpfrom,
                 gs_flight-countryto,
                 gs_flight-cityto,
                 gs_flight-airpto,
                 gs_flight-seatsmax,
                 gs_flight-seatsocc.
      ENDSELECT.
    WHEN pa_nat.
*     Radiobutton NATIONAL is marked
      SELECT * FROM dv_flights INTO gs_flight
        WHERE carrid IN so_car
          AND connid IN so_con
          AND fldate IN so_fdt
          AND countryfr IN s_cifr
          AND cityfrom IN s_cifr
          AND countryto = dv_flights~countryfr.

        WRITE: / gs_flight-carrid,
                 gs_flight-connid,
                 gs_flight-fldate,
                 gs_flight-countryfr,
                 gs_flight-cityfrom,
                 gs_flight-airpfrom,
                 gs_flight-countryto,
                 gs_flight-cityto,
                 gs_flight-airpto,
                 gs_flight-seatsmax,
                 gs_flight-seatsocc.
      ENDSELECT.
    WHEN pa_int.
*     Radiobutton INTERNAT is marked
      SELECT * FROM dv_flights INTO gs_flight
        WHERE carrid IN so_car
          AND connid IN so_con
          AND fldate IN so_fdt
          AND countryfr IN s_cifr
          AND cityfrom IN s_cifr
          AND countryto <> dv_flights~countryfr.

        WRITE: / gs_flight-carrid,
                 gs_flight-connid,
                 gs_flight-fldate,
                 gs_flight-countryfr,
                 gs_flight-cityfrom,
                 gs_flight-airpfrom,
                 gs_flight-countryto,
                 gs_flight-cityto,
                 gs_flight-airpto,
                 gs_flight-seatsmax,
                 gs_flight-seatsocc.
      ENDSELECT.
  ENDCASE.
