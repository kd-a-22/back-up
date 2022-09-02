*&---------------------------------------------------------------------*
*& Report ZRSA22_54
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_54.

TABLES : sflight, sbook.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS     : pa_car TYPE sflight-carrid OBLIGATORY.
  SELECT-OPTIONS : so_con FOR sflight-connid OBLIGATORY.
  PARAMETERS     : pa_plan  TYPE sflight-planetype AS LISTBOX VISIBLE LENGTH 20.
  SELECT-OPTIONS : so_bid FOR sbook-bookid.
SELECTION-SCREEN END OF BLOCK bl1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_car.   "이렇게 쓰면 얘는 더이상 기존의 서치헬프 창이 뜨지 않는다.
  PERFORM f4_carrid.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_bid-low.  " SELECT-OPTION에서는 필드가 두 개이기 때문에 한 필드를 지정해 주어야 한다.



START-OF-SELECTION.   " 위의 이벤트들은 STARTO-OF-SELECTION 이 나오기 전 까지만 탄다.


  DATA : BEGIN OF gs_data,
           carrid    TYPE sflight-carrid,
           connid    TYPE sflight-connid,
           fldate    TYPE sflight-fldate,
           planetype TYPE sflight-planetype,
           currency  TYPE sflight-currency,
           bookid    TYPE sbook-bookid,
           customid  TYPE sbook-customid,
           custtype  TYPE sbook-custtype,
           class     TYPE sbook-class,
           agencynum TYPE sbook-agencynum,
         END OF gs_data,

         gt_data LIKE TABLE OF gs_data,

         BEGIN OF gs_data2,
           carrid    TYPE sflight-carrid,
           connid    TYPE sflight-connid,
           fldate    TYPE sflight-fldate,
           bookid    TYPE sbook-bookid,
           customid  TYPE sbook-customid,
           custtype  TYPE sbook-custtype,
           agencynum TYPE sbook-agencynum,
         END OF gs_data2,

         gt_data2 LIKE TABLE OF gs_data2.

  REFRESH: gt_data, gt_data2.

  SELECT
          a~carrid
          a~connid
          a~fldate
          a~planetype
          a~currency
          b~bookid
          b~customid
          b~custtype
          b~class
          b~agencynum
    FROM sflight AS a INNER JOIN sbook AS b
                     ON  a~carrid = b~carrid
                     AND a~connid = b~connid
                     AND a~fldate = b~fldate
     INTO CORRESPONDING FIELDS OF TABLE gt_data
    WHERE a~carrid    = pa_car
      AND a~connid  IN  so_con
      AND a~planetype = pa_plan
      AND b~bookid  IN so_bid.

  IF sy-subrc <> 0.
    MESSAGE i000(zmca22) WITH '실패'.
    LEAVE LIST-PROCESSING.
  ENDIF.



  LOOP AT gt_data INTO gs_data.

    CASE gs_data-custtype.
      WHEN 'B'.
        MOVE-CORRESPONDING gs_data TO gs_data2 .
        APPEND gs_data2 TO  gt_data2.
        CLEAR gs_data2.
    ENDCASE.
  ENDLOOP.

  SORT  gt_data2 BY carrid connid fldate.
  DELETE ADJACENT DUPLICATES FROM gt_data2 COMPARING carrid connid fldate.

  cl_demo_output=>display( gt_data2 ).

  BREAK-POINT.
*&---------------------------------------------------------------------*
*& Form f4_carrid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_carrid .

*  MESSAGE i000 WITH '왔다.'.

  DATA : BEGIN OF ls_carrid,
           carrid   TYPE scarr-carrid,
           carrname TYPE scarr-carrname,
           currcode TYPE scarr-currcode,
           url      TYPE scarr-url,
         END OF ls_carrid,

         lt_carrid LIKE TABLE OF ls_carrid.

  REFRESH : lt_carrid.

  SELECT carrid carrname currcode url
    INTO CORRESPONDING FIELDS OF TABLE lt_carrid
    FROM scarr.
*    WHERE CURRCODE = 'EUR'.


  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      ddic_structure = ' '
      retfield       = 'CARRID'    " 선택화면 화면으로 세팅할 ITAB의 맆드 ID .. return field 더블클릭 했을 때 떨어트릴 필드.
      dynpprog       = sy-repid
      dynpnr         = sy-dynnr
      dynprofield    = 'PA_CAR'     " 서치헬프 화면에서 선택한 데이터가 세팅될 화면의 힐드 ID
      window_title   = 'Airline List'
      value_org      = 'S'
      display        = abap_true     " 선택한 데이터가 세팅될 화면의 필드에 세팅 되는 것을 막음
* IMPORTING    " 임포팅은 왜 있는 지 모르것움 ㅜ ㅋ
*     USER_RESET     =
    TABLES
      value_tab      = lt_carrid.
*





ENDFORM.
