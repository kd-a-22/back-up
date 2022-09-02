*&---------------------------------------------------------------------*
*& Include          ZC1R220006_S01
*&---------------------------------------------------------------------*


SELECTION-SCREEN BEGIN OF BLOCK BL1 WITH FRAME TITLE TEXT-T01.

  SELECT-OPTIONS : SO_CAR FOR SCARR-CARRID,
                   SO_CON FOR SFLIGHT-CONNID,
                   SO_PTYPE FOR SFLIGHT-PLANETYPE NO INTERVALS NO-EXTENSION.

  SELECTION-SCREEN END OF BLOCK BL1.
