*&---------------------------------------------------------------------*
*& Report ZRSA22_60
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_60.

*DATA :BEGIN OF  gs_data,
*        ktopl TYPE ska1-ktopl,
*        ktplt TYPE t004t-ktplt,
*        saknr TYPE ska1-saknr,
*        txt20 TYPE skat-txt20,
*        ktoks TYPE ska1-ktoks,
*        txt30 TYPE t077z-txt30,
*      END OF gs_data ,
*      gt_data  LIKE TABLE OF gs_data,
*
*      gs_t004t TYPE t004t,
*      gt_t004t LIKE TABLE OF gs_t004t,
*
*      gs_skat  TYPE skat,    " KTOPL SAKNR  TXT20
*      gt_skat  LIKE TABLE OF gs_skat,
*
*      gs_t077s TYPE t077s,   " KTOPL KTOKS T077Z
*      gt_t077s LIKE TABLE OF gs_t077s.
*
*
*SELECT ktopl saknr ktoks
*  FROM ska1
*  INTO gt_data-ktopl
*  WHERE ktopl = 'WEG'.
*
*
*  SELECT ktopl ktplt
*    FROM t004t
*    INTO CORRESPONDING FIELDS OF TABLE gr_t004t.
*
*    SELECT ktopl saknr txt20
*      FROM skat
*      INTO CORRESPONDING FIELDS OF TABLE gr_skat.
*
*
*
*SELECT ktopl ktoks txt30
*   FROM t077s
*   INTO CORRESPONDING FIELDS OF TABLE gt_t077s.


*
*SELECT A~ktopl A~saknr A~ktoks B~ktplt
*  FROM ska1 AS A  INNER JOIN TOO4T as b
*                 on a~ktol b~ktol
*  INTO gt_data
*  WHERE ktopl = 'WEG'.
