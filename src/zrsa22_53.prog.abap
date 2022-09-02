*&---------------------------------------------------------------------*
*& Report ZRSA22_53
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_53.

TABLES : sbook.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS     : pa_car TYPE sbook-carrid OBLIGATORY DEFAULT 'AA'.
  SELECT-OPTIONS : so_con FOR  sbook-connid OBLIGATORY.
  PARAMETERS     : pa_cus TYPE sbook-custtype AS LISTBOX
                   VISIBLE LENGTH 20 OBLIGATORY .
  SELECT-OPTIONS : so_dat FOR sbook-fldate DEFAULT sy-datum,   " 오늘의 현지날짜를 볼 때는 SY-DATLO   현지시간은 SY-TIMLO이다.
                   so_bid FOR sbook-bookid,
                   so_cid FOR sbook-customid NO INTERVALS NO-EXTENSION.

SELECTION-SCREEN END OF BLOCK bl1.

DATA : BEGIN OF gs_data ,
         carrid   TYPE sbook-carrid,
         connid   TYPE sbook-connid,
         fldate   TYPE sbook-fldate,
         bookid   TYPE sbook-bookid,
         customid TYPE sbook-customid,
         custtype TYPE sbook-custtype,
         invoice  TYPE sbook-invoice,
         class    TYPE sbook-class,
       END OF gs_data,

       gt_data  LIKE TABLE OF gs_data,
       gv_tabix TYPE sy-tabix.


 SELECT carrid connid fldate bookid customid
        custtype invoice class
   FROM sbook
   INTO CORRESPONDING FIELDS OF TABLE gt_data
  WHERE carrid    = pa_car
    AND connid   IN so_con
    AND custtype  = pa_cus
    AND fldate   IN so_dat
    AND bookid   IN so_bid
    AND customid IN so_cid.

   IF SY-SUBRC = 0.
     MESSAGE S000(ZMCA22) WITH '성공적!'.
     ELSE.
     MESSAGE I000(ZMCA22) WITH '잘못된 조건입니다!'.
     LEAVE LIST-PROCESSING.  " STOP
   ENDIF.


LOOP AT gt_data INTO gs_data.
  gv_tabix = sy-tabix.
  CASE gs_data-invoice.
    WHEN 'X'.
      gs_data-class = 'F'.
      IF SY-SUBRC = 0.
  MODIFY gt_data FROM gs_data INDEX gv_tabix TRANSPORTING class.
  ELSE.
    MESSAGE I000(ZMCA22) WITH '잘못된 값입니다!'.
  ENDIF.
  ENDCASE.
ENDLOOP.
