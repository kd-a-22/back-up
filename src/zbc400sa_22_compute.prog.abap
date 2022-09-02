*&---------------------------------------------------------------------*
*& Report ZBC400SA_22_COMPUTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBC400SA_22_COMPUTE.

*PARAMETERS : PA_INT1 TYPE I,
*             PA_INT2 TYPE I,
*             PA_OP TYPE C LENGTH 1.
*DATA : GV_RESULT TYPE I.
*
*CASE PA_OP.
*  WHEN '+'.
*    GV_RESULT = PA_INT1 + PA_INT2.
*    WRITE: PA_INT1, PA_OP, PA_INT2, '=', GV_RESULT.
*
*  WHEN '-'.
*    GV_RESULT = PA_INT1 - PA_INT2.
*    WRITE:  PA_INT1, PA_OP, PA_INT2, '=', GV_RESULT.
*  WHEN '*'.
*    GV_RESULT = PA_INT1 * PA_INT2.
*    WRITE:  PA_INT1, PA_OP, PA_INT2, '=', GV_RESULT.
*  WHEN '/'.
*    GV_RESULT = PA_INT1 / PA_INT2.
*    WRITE:  PA_INT1, PA_OP, PA_INT2, '=', GV_RESULT.
*  WHEN OTHERS.
*
*    WRITE '연산자를 정확하게 입력해주세요'.
*
*ENDCASE.


TABLES : SPFLI, SBOOK, SCARR, SFLIGHT.

DATA : BEGIN OF A2 OCCURS 0,
   CARRID LIKE SPFLI-CARRID,
  CONNID LIKE SPFLI-CONNID,
    CITYFROM LIKE SPFLI-CITYFROM,
CITYFTO LIKE SPFLI-CITYTO,
  DISTANCE LIKE SPFLI-DISTANCE,
 DISTID LIKE SPFLI-DISTID,
  END OF A2.

data : BEGIN OF a1 OCCURS 0,
   CARRID LIKE SFLIGHT-CARRID,
  CONNID LIKE SFLIGHT-CONNID,
  FLDATE LIKE SFLIGHT-FLDATE,
  CARRNAME LIKE SCARR-CARRNAME,
  CURRCODE LIKE SCARR-CURRCODE,
CITYFROM LIKE SPFLI-CITYFROM,
CITYFTO LIKE SPFLI-CITYTO,
  DISTANCE LIKE SPFLI-DISTANCE,
 DISTID LIKE SPFLI-DISTID,
SEATSMAX LIKE SFLIGHT-SEATSMAX,
SEATSOCC LIKE SFLIGHT-SEATSOCC,
END OF A1.




SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME  TITLE TEXT-001.

 PARAMETERS : P_CARRID  LIKE SFLIGHT-CARRID.
 PARAMETERS : P_CONNID LIKE SFLIGHT-CONNID.
SELECT-OPTIONS  : S_FLDATE   FOR SFLIGHT-FLDATE.
SELECTION-SCREEN END OF BLOCK B1.




*
*
*  SELECT * FROM SFLIGHT
*    INTO CORRESPONDING FIELDS OF TABLE A1
*    WHERE CARRID = P_CARRID
*     AND CONNID = P_CONNID
*     AND FLDATE IN S_FLDATE.
*
*
*SELECT * FROM SPFLI
*  INTO CORRESPONDING FIELDS OF TABLE A2.

LOOP AT A2.

SELECT * FROM SPFLI
  APPENDING CORRESPONDING FIELDS OF TABLE A1
  WHERE CARRID = A2-CARRID
    AND CONNID = A2-CONNID.

  MODIFY A2.

ENDLOOP.


 LOOP AT A1.
   SELECT SINGLE CARRNAME FROM SCARR
     INTO A1-CARRNAME
     WHERE CARRID = A1-CARRID.

     SELECT SINGLE CURRCODE FROM SCARR
       INTO  A1-CURRCODE
       WHERE CARRID = A1-CARRID.

*      SELECT SINGLE CITYFROM FROM SPFLI
*        INTO A1-CITYFROM
*        WHERE


       MODIFY A1.

 ENDLOOP.


TOP-OF-PAGE.

*
*WRITE : (153) SY-ULINE.   " 헤더부분인듯
*WRITE : / SY-VLINE,
*               (4)'ID',
*               SY-VLINE,
*               (9)'NO',
*               SY-VLINE,
*               (14)'운항일자',
*               SY-VLINE,
*               (24)'항공사 ',
*               SY-VLINE,
*               (4)'통화',
*               SY-VLINE,
*               (14)'출발지',
*               SY-VLINE,
*               (9) '도착지',
*               SY-VLINE,
*               (14) '거리',
*               SY-VLINE,
*               (9)'단위',
*               SY-VLINE,
*               (9) '최대용량',
*               SY-VLINE,
*               (9) '점유좌석',
*               SY-VLINE,
*               /(153) SY-ULINE.






   END-OF-PAGE.

START-OF-SELECTION.





LOOP AT  A1.

  WRITE : / SY-VLINE,
              (5) A1-CARRID NO-GAP,
              SY-VLINE,
              (10) A1-CONNID NO-GAP,
              SY-VLINE,
              (15) A1-FLDATE NO-GAP,
              SY-VLINE,
              (25) A1-CARRNAME
              NO-GAP,
              SY-VLINE,

              (5) A1-CURRCODE NO-GAP,
              SY-VLINE,
              (15) A1-CITYFROM NO-GAP,
              SY-VLINE,

              (10) A1-CITYFTO NO-GAP,
              SY-VLINE,
              (15) A1-DISTANCE  NO-GAP,
              SY-VLINE,
              (10) A1-DISTID NO-GAP,
              SY-VLINE,
              (10) A1-SEATSMAX NO-GAP,
              SY-VLINE,
              (10) A1-SEATSOCC NO-GAP,
              SY-VLINE,
               /(153) SY-ULINE.
              ENDLOOP.





WRITE : /,
           /.





DATA : BEGIN OF A3 OCCURS 0,
  BOOKID LIKE SBOOK-BOOKID,
  PASSNAME LIKE SBOOK-PASSNAME,
  SMOKER LIKE SBOOK-SMOKER,
  LUGGWEIGHT LIKE SBOOK-LUGGWEIGHT,
  WUNIT LIKE SBOOK-WUNIT,
  LOCCURAM LIKE SBOOK-LOCCURAM,
  LOCCURKEY LIKE SBOOK-LOCCURKEY,
  ORDER_DATE LIKE SBOOK-ORDER_DATE,
  END OF A3.

  SELECT * FROM SBOOK
    INTO CORRESPONDING FIELDS OF TABLE A3.





LOOP AT  A3.

  WRITE :
              SY-VLINE,


              (5) A3-BOOKID NO-GAP,
              SY-VLINE,
              (10) A3-PASSNAME NO-GAP,
              SY-VLINE,
              (5) A3-SMOKER NO-GAP,
              SY-VLINE,
              (5) A3-LUGGWEIGHT NO-GAP
              ,
              SY-VLINE,

              (26) A3-WUNIT NO-GAP,
              SY-VLINE,
              (10) A3-LOCCURAM NO-GAP,
              SY-VLINE,
*
              (10) A3-LOCCURKEY  NO-GAP,
              SY-VLINE,
              (15) A3-ORDER_DATE  NO-GAP,
              SY-VLINE,

               /(100) SY-ULINE.
              ENDLOOP.





BREAK-POINT.
