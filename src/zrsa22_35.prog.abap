*&---------------------------------------------------------------------*
*& Report ZRSA22_35
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_35.

*data : gv_c type c LENGTH 20,
*       gv_de type p LENGTH 5 DECIMALS 2,
*       gv_n type n LENGTH 9,
*       GV_AR TYPE C LENGTH 27,
*       GV_N2 TYPE N LENGTH 10,
*       GV_I TYPE I,
*       GV_P2 TYPE P LENGTH 3 DECIMALS 2.
*
*
*GV_N = 000000678.
*GV_AR = 'ABCDEFGHIJ'.
*GV_N2 = 0000000365.
*GV_I = 25.
*GV_P2 = '0.25'.
*
*
*
*write : gv_N, / gv_AR, / gv_N2, / gv_I, / GV_P2.


******++++===      2교시    ====++++******

*DATA : BEGIN OF gs_itab,
*         matnr TYPE mara-matnr,
*         werks TYPE marc-werks,
*         mtart TYPE mara-mtart,
*         matkl TYPE mara-matkl,
*         ekgrp TYPE marc-ekgrp,
*         pstat TYPE marc-pstat,
*       END OF gs_itab.
*
*DATA : gs_ztsa2201 TYPE ztsa2201,
*       gt_ztsa2201 LIKE TABLE OF gs_ztsa2201,
*       gt_itab     LIKE TABLE OF gs_itab.


*
*
********************<  3 교시
*DATA : gs_sbook TYPE sbook,
*       gt_sbook LIKE TABLE OF gs_sbook,
*       lv_tabix TYPE sy-tabix.
*
*SELECT  carrid connid fldate bookid customid
*        custtype  invoice  class smoker
*  FROM sbook
*  INTO CORRESPONDING FIELDS OF TABLE gt_sbook
*  WHERE carrid     = 'DL'
*    AND custtype   = 'P'
*    AND order_date = '20201227'.
*
*
*
*IF sy-subrc NE 0.
**  MESSAGE s001.
*  LEAVE TO LIST-PROCESSING.    " stop 과 같다. 사람마다 다르게 쓴다. call screen 하기 전 까지의 과정이 리스트프로세싱 영역이다. 이 구문을 쓰면 화면을 불러오지 않고 떠난다.
*ENDIF.  " ++ call screen하고 (화면을 불러오고) stop 을 쓰면 안 된다.화면은 pbo, pai를 왔다갔다 하는 데 갑자기 stop 하게 되면 런타임 에러가 뜬다. 리브 투 리스트프로세싱도 안 먹힌다. 그 영역이 아니기 때문.
*
*
*
***LOOP AT gt_sbook INTO gs_sbook. " if 문은 가능하면 case문으로 쓰는 것이 좋다.
***  IF gs_sbook-smoker = 'X' AND gs_sbook-invoice = 'X'.
***    gs_sbook-class = 'F'.
***    MODIFY gt_sbook FROM gs_sbook INDEX lv_tabix TRANSPORTING class.  " 바꿔줄 인덱스 넘버와 필드의 이름을 지정해 준 것이다.
***  ENDIF.
***ENDLOOP.
*
*
*LOOP AT gt_sbook INTO gs_sbook.
*  CASE gs_sbook-smoker.
*    WHEN 'X'.
*
*      CASE gs_sbook-invoice.
*        WHEN 'X'.
*          gs_sbook-class = 'F'.
*          MODIFY gt_sbook FROM gs_sbook INDEX lv_tabix
*          TRANSPORTING class.
*      ENDCASE.
*
*  ENDCASE.
*ENDLOOP.
**********************  =========================
**DATA : BEGIN OF gs_sflight,
**         carrid     TYPE sflight-carrid,
**         connid     TYPE sflight-connid,
**         fldate     TYPE sflight-fldate,
**         currency   TYPE sflight-currency,
**         planetype  TYPE sflight-planetype,
**         seatsocc_b TYPE sflight-seatsocc_b,
**       END OF gs_sflight,
**       gt_sflight LIKE TABLE OF gs_sflight,
**       gv_tabix   TYPE sy-tabix.
**
**SELECT carrid connid fldate currency planetype seatsocc_b
**  FROM sflight
**  INTO CORRESPONDING FIELDS OF TABLE gt_sflight
**  WHERE currency = 'USD'
**  AND planetype = '747-400'.
**
**IF sy-subrc <> 0.
**  MESSAGE i000(zmca22) WITH '찾을 수 없습니다.!' .
**ENDIF.
**
**LOOP AT gt_sflight INTO gs_sflight.
**  gv_tabix = sy-tabix.
**
**  CASE gs_sflight-carrid.
**    WHEN 'UA'.
**      gs_sflight-seatsocc_b = gs_sflight-seatsocc_b + 5.
**      MODIFY gt_sflight FROM gs_sflight INDEX gv_tabix
**      TRANSPORTING seatsocc_b.
**  ENDCASE.
**ENDLOOP.
**
**
**
***************=========================
**
**
**DATA : BEGIN OF gs_mara,
**         matnr TYPE mara-matnr,
**         maktx TYPE makt-maktx,
**         mtart TYPE mara-mtart,
**         matkl TYPE mara-matkl,
**       END OF gs_mara,
**       gt_mara LIKE TABLE OF gs_mara,
**
**       BEGIN OF gs_makt ,
**         matnr TYPE makt-matnr,
**         maktx TYPE makt-maktx,
**       END OF gs_makt,
**       gt_makt LIKE TABLE OF gs_makt.
**
**REFRESH : gt_mara, gt_makt.
**
**
**SELECT matnr maktx
**  FROM makt
**  INTO CORRESPONDING FIELDS OF TABLE  gt_makt
**  WHERE spras = sy-langu.
**
**
**SELECT matnr  mtart matkl
**   FROM mara
**   INTO CORRESPONDING FIELDS OF TABLE gt_mara.
**
***CLEAR : GT_MARA, GS_MARA , GT_MAKT, GS_MAKT.
**REFRESH : gt_mara, gt_makt.  " REFRESH에는 INTERNAL TALBE TYPE 만 올 수 있다.
**
**
**LOOP AT gt_mara INTO gs_mara.
**
**  READ TABLE gt_makt INTO gs_makt WITH KEY matnr = gs_mara-matnr.
**  IF sy-subrc = 0.
**    gs_mara-maktx = gs_makt-maktx.
**  MODIFY gt_mara FROM gs_mara ."TRANSPORTING maktx.
**  ENDIF.
**

**ENDLOOP.

*====================★★★★★
*DATA : BEGIN OF gs_spfli,
*         carrid   TYPE spfli-carrid,
*         carrname TYPE scarr-carrname,
*         url      TYPE scarr-url,
*         connid   TYPE spfli-connid,
*         airpfrom TYPE spfli-airpfrom,
*         airpto   TYPE spfli-airpto,
*         deptime  TYPE spfli-deptime,
*         arrtime  TYPE spfli-arrtime,
*       END OF gs_spfli,
*
*       gt_spfli LIKE TABLE OF gs_spfli,
*
*       BEGIN OF gs_scarr,
*         carrid   TYPE scarr-carrid,
*         carrname TYPE scarr-carrname,
*         url      TYPE scarr-url,
*       END OF gs_scarr,
*
*       gt_scarr LIKE TABLE OF gs_scarr,
*       gv_tabix TYPE sy-tabix.
*
*SELECT carrid connid airpfrom
*       airpto deptime arrtime
*  FROM spfli
*  INTO CORRESPONDING FIELDS OF TABLE gt_spfli.
*
*
*SELECT carrid carrname url
*  FROM scarr
*  INTO CORRESPONDING FIELDS OF TABLE gt_scarr.
*
*LOOP AT gt_spfli INTO gs_spfli.
*  gv_tabix = sy-tabix.
*
*  READ TABLE gt_scarr INTO gs_scarr WITH KEY carrid = gs_spfli-carrid.
*
*  IF sy-subrc = 0.
*
*    gs_spfli-carrname = gs_scarr-carrname.
*    gs_spfli-url      = gs_scarr-url.
*
*    MODIFY gt_spfli FROM gs_spfli INDEX gv_tabix
*    TRANSPORTING carrname url.
*  ELSE.
*    MESSAGE i000(zmca22) WITH '찾을 수 없습니다!'.
*  ENDIF.
*
*ENDLOOP

*====================★★★★★

DATA : BEGIN OF gs_data,
         matnr TYPE mara-matnr,
         maktx TYPE makt-maktx,
         mtart TYPE mara-mtart,
         mtbez TYPE t134t-mtbez,
         mbrsh TYPE mara-mbrsh,
         mbbez TYPE t137t-mbbez,
         tragr TYPE mara-tragr,
         vtext TYPE ttgrt-vtext,
       END OF gs_data,

       gt_data  LIKE TABLE OF gs_data,

       gs_mrart TYPE t134t,
       gt_mrart LIKE TABLE OF gs_mrart,

       gs_mbrsh TYPE t137t,
       gt_mbrsh LIKE TABLE OF  gs_mbrsh,

       gs_tragr TYPE ttgrt,
       gt_tragr LIKE TABLE OF gs_tragr,

       gv_tabix TYPE sy-tabix.





*       BEGIN OF gs_mrart,
*         mtbez TYPE t134t-mtbez,
*       END OF gs_mrart,
*       gt_mrart LIKE TABLE OF gs_mrart,
*
*       BEGIN OF gs_mbrsh,
*         mbbez TYPE t137t-mbbez,
*       END OF gs_mbrsh,
*       gt_mbrsh LIKE TABLE OF gs_mbrsh,
*
*       BEGIN OF gs_tragr,
*         vtext TYPE ttgrt-vtext,
*       END OF gs_tragr,
*       gt_tragr LIKE TABLE OF gs_tragr.


SELECT
     a~matnr
     b~maktx
     a~mtart
     a~mbrsh
     a~tragr
   FROM mara AS a INNER JOIN makt AS b
                  ON a~matnr = b~matnr
   INTO CORRESPONDING FIELDS OF TABLE gt_data
   WHERE b~spras = sy-langu.

SELECT mbrsh mbbez
  FROM t137t
  INTO CORRESPONDING FIELDS OF  TABLE gt_mbrsh
  WHERE spras = sy-langu.

SELECT mtart mtbez
  FROM t134t
  INTO CORRESPONDING FIELDS OF TABLE gt_mrart
  WHERE spras = sy-langu.


SELECT tragr vtext
FROM ttgrt
INTO CORRESPONDING FIELDS OF TABLE gt_tragr
  WHERE spras = sy-langu.



LOOP AT gt_data INTO gs_data.
  gv_tabix = sy-tabix.

  READ TABLE gt_mbrsh INTO gs_mbrsh WITH KEY mbrsh = gs_data-mbrsh.
  IF sy-subrc = 0.
    gs_data-mbbez = gs_mbrsh-mbbez.
    MODIFY gt_data FROM gs_data INDEX gv_tabix
   TRANSPORTING mbbez.
  ENDIF.

  READ TABLE gt_mrart INTO gs_mrart WITH KEY mtart = gs_data-mtart.
  IF sy-subrc = 0.
    gs_data-mtbez = gs_mrart-mtbez.
    MODIFY gt_data FROM gs_data INDEX gv_tabix
    TRANSPORTING mtbez.
  ENDIF.

  READ TABLE gt_tragr INTO gs_tragr WITH KEY tragr = gs_data-tragr.
  IF sy-subrc = 0.
    gs_data-vtext = gs_tragr-vtext.
    MODIFY gt_data FROM gs_data INDEX gv_tabix
    TRANSPORTING vtext.
  ENDIF.


ENDLOOP.







BREAK-POINT.
