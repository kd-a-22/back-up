*&---------------------------------------------------------------------*
*& Report ZRSA22_21
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_21.


TYPES : BEGIN OF ts_info,
    carrid    TYPE c LENGTH 3,
    carrname  TYPE scarr-carrname,
    connid    TYPE spfli-connid,
    countryfr TYPE spfli-countryfr,
    countryto TYPE spfli-countryto,
    atype     TYPE c LENGTH 10,
  END OF ts_info.

*CONNECTION INTERNAL TABLE  * LIKE(TYPE)TABLE OF
DATA gt_info TYPE TABLE OF ts_info.

*STURCTURE       * LIKE(TYPE) LINE OF
DATA gs_info LIKE LINE OF gt_info.   " LIKE LINE OF TS_INFO 로 해도 된다.


PARAMETERS pa_car TYPE spfli-carrid.

" 데이터 넣기 1) 손으로 일일이 입력------------------------------------------------
*gs_info-carrid = 'AA'.   " 이렇게 적는 것은 맨 앞자리에 들어가게 할 것이다.
*gs_info-connid = '0017'.
*gs_info-countryfr = 'US'.
*gs_info-countryto = 'US'.
*APPEND gs_info TO gt_info.
*CLEAR gs_info.

" 데이터 넣기 2) 서브루틴 FORM사용.-----------------------------------------------
*PERFORM into_data USING 'AA' '0017' 'US' 'US'.
*PERFORM into_data USING 'AA' '0064' 'US' 'US'.
*PERFORM into_data USING 'AZ' '0555' 'IT' 'DE'.

"데이터 넣기 3) SQL사용.
SELECT carrid connid countryfr countryto
  FROM spfli
  INTO CORRESPONDING FIELDS OF TABLE gt_info
  WHERE carrid = pa_car.

LOOP AT gt_info INTO gs_info.
   " Get Atype( D, I )
  IF gs_info-countryfr = gs_info-countryto.
     gs_info-atype = 'D'.
  ELSE.
     gs_info-atype = 'I'.
  ENDIF.

  "Get Airlinename
  SELECT SINGLE carrname
    FROM scarr
    INTO gs_info-carrname
    WHERE carrid = gs_info-carrid.

  MODIFY gt_info FROM gs_info TRANSPORTING carrname atype.   "TRANSPORTING ATYPE 테이블에 있는 이 값만 변경하겠다.
  CLEAR gs_info.
ENDLOOP.

SORT GT_INFO BY ATYPE ASCENDING.
cl_demo_output=>display_data( gt_info ).

*&---------------------------------------------------------------------*
*& Form INTO_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*FORM into_data USING VALUE(p_carrid)
*                     VALUE(p_connid)
*                     VALUE(p_countryfr)
*                     VALUE(p_countryto).
*
*DATA LS_INFO LIKE LINE OF GT_INFO.
*gs_info-carrid = p_carrid.   " 이렇게 적는 것은 맨 앞자리에 들어가게 할 것이다.
*gs_info-connid = p_connid.
*gs_info-countryfr = p_countryfr.
*gs_info-countryto = p_countryto.
*APPEND LS_INFO TO GT_INFO.
*CLEAR GS_INFO.
*
*
*ENDFORM.
