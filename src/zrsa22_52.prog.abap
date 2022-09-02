*&---------------------------------------------------------------------*
*& Report ZRSA22_52
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_52.

TABLES : sbuspart.




SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01 .
  PARAMETERS     p_sub TYPE sbuspart-buspartnum OBLIGATORY.
  SELECT-OPTIONS s_sbu FOR sbuspart-contact NO INTERVALS    .

  SELECTION-SCREEN ULINE.

  PARAMETERS: ra_ta RADIOBUTTON GROUP rb DEFAULT 'X',
              ra_fc RADIOBUTTON GROUP rb.

SELECTION-SCREEN END OF BLOCK b1.



DATA : gs_sbu  TYPE sbuspart,
       gt_sbu  LIKE TABLE OF  gs_sbu,
       GV_TYPE TYPE SBUSPART-BUSPATYP.



REFRESH : gt_sbu.
******* 방법 1
*IF  ra_ta = 'X'.
*  SELECT buspartnum contact contphono buspatyp
*  FROM sbuspart
*  INTO CORRESPONDING FIELDS OF TABLE gt_sbu
*   WHERE buspartnum = p_sub
*   AND contact IN s_sbu
*    AND buspatyp = 'TA'.
*
*ELSEIF ra_fc = 'X'.
*  SELECT buspartnum contact contphono buspatyp
*   FROM sbuspart
*   INTO CORRESPONDING FIELDS OF TABLE gt_sbu
*   WHERE buspartnum = p_sub
*   AND contact IN s_sbu
*   AND buspatyp = 'FC'.
*
*ENDIF.
* ********* 방법 2

CASE  'X'.
  WHEN ra_ta.
    SELECT buspartnum contact contphono buspatyp
      FROM sbuspart
      INTO CORRESPONDING FIELDS OF TABLE gt_sbu
     WHERE buspartnum = p_sub
       AND contact IN s_sbu
      AND buspatyp = 'TA'.

  WHEN ra_fc.
    SELECT buspartnum contact contphono buspatyp
      FROM sbuspart
      INTO CORRESPONDING FIELDS OF TABLE gt_sbu
     WHERE buspartnum = p_sub
       AND contact IN s_sbu
       AND buspatyp = 'FC'.
ENDCASE.


CASE 'X'.
  WHEN RA_TA.
    GV_TYPE = 'TA'.
  WHEN RA_FC.
    GV_TYPE = 'FC'.
  WHEN OTHERS.
ENDCASE.
SELECT buspartnum contact contphono buspatyp
      FROM sbuspart
      INTO CORRESPONDING FIELDS OF TABLE gt_sbu
     WHERE buspartnum = p_sub
       AND contact IN s_sbu
       AND buspatyp = GV_TYPE.




BREAK-POINT.



*LOOP AT GS_SUB.
*CASE  RG.
*	WHEN .
*	WHEN .
*ENDCASE.
*
*
*
*
*ENDLOOP.
