*&---------------------------------------------------------------------*
*& Include          ZBC405_A22_SIA_E01
*&---------------------------------------------------------------------*

INITIALIZATION.
  MOVE : 'AA' TO so_car-low,
         'QF' TO so_car-high,
         'BT' TO so_car-option,
         'I'  TO so_car-sign.  "include 데이터 읽을 때 포함시켜라
  APPEND so_car.

  CLEAR so_car.
  MOVE : 'AZ' TO so_car-low,
         'EQ' TO so_car-option,
         'E'  TO so_car-sign. " exclude 데이터 읽을 때 포함시키지 마라.
  APPEND so_car.

START-OF-SELECTION.
  CASE gc_mark.
    WHEN pa_all.
      SELECT * FROM
        dv_flights INTO gs_flight
        WHERE carrid IN so_car
        AND connid IN so_con
        AND fldate IN so_fdt.

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
      SELECT *
        FROM dv_flights INTO gs_flight
        WHERE carrid IN so_car
        AND  connid IN so_con
        AND fldate IN so_fdt
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
      SELECT *
       FROM dv_flights INTO gs_flight
       WHERE carrid IN so_car
       AND  connid IN so_con
       AND fldate IN so_fdt
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
