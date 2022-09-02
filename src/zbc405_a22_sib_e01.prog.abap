*&---------------------------------------------------------------------*
*& Include          ZBC405_A22_E01
*&---------------------------------------------------------------------*

SELECT *
  FROM dv_flights
  INTO  gs_flt.

  write : /10(5) gs_flt-carrid,  "시작자리(이 필드가 차지할 자릿수)
            gs_flt-connid,
            gs_flt-fldate,
            gs_flt-price  currency gs_flt-currency, "CURRENCY 'USD', 라고 써도 되긴 함
            gs_flt-currency
           .
  ENDSELECT.
