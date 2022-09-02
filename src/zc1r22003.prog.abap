*&---------------------------------------------------------------------*
*& Report ZC1R22003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r22003.

DATA: ls_data     TYPE zssa2240,
      lt_data     LIKE TABLE OF ls_data,
      ls_data_pmt LIKE ls_data,
      LT_DATA_H   LIKE TABLE OF LS_DATA WITH HEADER LINE,


*      BEGIN OF ls_data_tmp,
*        bukrs TYPE ls_data-bukrs,
*        belnr TYPE ls_data-belnr,
*      END OF ls_data_tmp,

      lv_loekz    TYPE eloek,
      lv_statu    TYPE astat,
      lv_bpumz    TYPE ekpo-bpumz,
      lv_bpumn    TYPE ekpo-bpumn,

      lv_lo       LIKE  lv_loekz,
      lv_st       LIKE  lv_statu,
      lv_bpz      LIKE  lv_bpumz,
      lv_bpn      LIKE  lv_bpumn,

      GS_FLT TYPE SFLIGHT,
      GT_FLT LIKE TABLE OF SFLIGHT.


       CLEAR LS_DATA.
      lS_data-BUKRS = '0001'.
      lS_data-belnr = 'AT-001'.
      APPEND LS_DATA TO LT_DATA.

      CLEAR LS_DATA.
      lS_data-BUKRS = '1000'.
      lS_data-belnr = 'ZT-002'.
       APPEND LS_DATA TO LT_DATA.

      CLEAR LS_DATA.
      lS_data-bukrs = '0003'.
      lS_data-belnr = 'YE-0017'.
       APPEND LS_DATA TO LT_DATA.


      CLEAR LT_DATA_H.
      lT_data_H-BUKRS = '0001'.
      lT_data_H-belnr = 'AT-001'.
      APPEND LT_DATA_H.

      CLEAR LT_DATA_H.
     lT_data_H-BUKRS = '1000'.
     lT_data_H-belnr = 'ZT-002'.
       APPEND LT_DATA_H.

      CLEAR LT_DATA_H.
      lT_data_H-bukrs = '0003'.
      lT_data_H-belnr = 'YE-0017'.
       APPEND LT_DATA_H.

        SELECT CARRID CONNID CURRENCY PLANETYPE SEATSOCC_B
          FROM SFLIGHT
          INTO CORRESPONDING FIELDS OF TABLE GT_FLT
          WHERE CURRENCY = 'USD'
            AND PLANETYPE = '747-400'.





       BREAK-POINT.
