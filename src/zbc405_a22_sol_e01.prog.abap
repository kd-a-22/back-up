*&---------------------------------------------------------------------*
*& Include          ZBC405_A22_SOL_E01
*&---------------------------------------------------------------------*


SELECT SINGLE *
  FROM SPFLI
  INTO CORRESPONDING FIELDS OF  GS_FLT
  WHERE CARRID = P_CAR
  AND   CONNID = P_CON.
*  AND FLDATE   = S_FLDATE.

  WRITE: GS_FLT-CARRID,
         GS_FLT-CONNID.
*         GT_FLT-FLDATE.
