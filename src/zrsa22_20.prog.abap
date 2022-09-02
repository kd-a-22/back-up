*&---------------------------------------------------------------------*
*& Report ZRSA22_20
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_20.


"1.)  변수 선언: TYPES 또는 DATA: BEGIN OF 사용

DATA : BEGIN OF gs_info ,    " STRUCTURE 선언
          carrid LIKE spfli-carrid,
          carrname LIKE scarr-carrname,
          connid LIKE spfli-connid,
          countryfr LIKE spfli-countryfr,
          countryto LIKE spfli-countryto,
          atype TYPE c LENGTH 10,
  END OF gs_info.

DATA : gt_info LIKE TABLE OF gs_info.   " GT_INFO라는 테이블을 GS_INFO라는 스트럭쳐를 따라서 만들거야.


*2. APPEND 문을 이용해서 Internal Table에 데이터 채우기 ( Table SPFLI에서 읽어와도 됨 )
SELECT  * FROM spfli
  INTO CORRESPONDING FIELDS OF TABLE Gt_INFO.

*"" ... 멍청이 버전... select하고 single하니까 당연히 table에 안 들어가지..
* gs_info-carrid = 'AA'.
** GS_INFO- CARRNAME =''.
* gs_info-connid ='0017'.
* gs_info-countryfr ='US'.
* gs_info-countryto ='US'.
* APPEND gs_info TO gt_info.
* CLEAR gs_info.
*
*  gs_info-carrid = 'AA'.
** GS_INFO- CARRNAME =''.
* gs_info-connid ='0065'.
* gs_info-countryfr ='US'.
* gs_info-countryto ='US'.
*  APPEND gs_info TO gt_info.
*  CLEAR gs_info.
*
*  gs_info-carrid = 'AZ'.
** GS_INFO- CARRNAME =''.
* gs_info-connid ='0555'.
* gs_info-countryfr ='IT'.
* gs_info-countryto ='DE'.
*  APPEND gs_info TO gt_info.
*  CLEAR gs_info.

  "3. LOOP문과 MODIFY 문을 이용해서, 아래 내용을 Internal Table의 테이터로 변경하기
*LOOP AT GT_INFO INTO GS_INFO.
*  IF GT_INFO-COUNTRYFR = GT_INFO-COUNTRYTO.
*
*    GT_INFO-ATYPE = '해외선'.
*
*  ENDIF.
*
*
*ENDLOOP.

LOOP AT gt_info into gs_info.
  IF gs_info-countryfr = Gs_INFO-countryto.
    gs_info-atype = '국내선'.
  ELSE.
    Gs_INFO-atype = '해외선'.
 ENDIF.


SELECT SINGLE carrname   " struceture를 만들고 그것 따라서 table을 만들면 여기서 테이블필드를 못 쓰네..
  FROM scarr
  INTO  gs_info-carrname
  WHERE carrid = gs_info-carrid.



  MODIFY gt_info from gs_info.
ENDLOOP.

*perform name_atype_append_modify.

  cl_demo_output=>display_data( gt_info ).   " table에 있는 정보 write를 쓰지 않아도 볼 수 있다.

" 이건 그냥 내가 strucure를 table에 준 것이 아닌 그냥 table을 만들어서 한 것.


*
*data : BEGIN OF itab occurs 0,   " structure선언문에서 occurs 0 를 넣어주면 table로 만들어준다
*          carrid LIKE spfli-carrid,
*          carrname LIKE scarr-carrname,
*          connid LIKE spfli-connid,
*          countryfr LIKE spfli-countryfr,
*          countryto LIKE spfli-countryto,
*          atype TYPE c LENGTH 10,
*  END OF itab.
*
*  SELECT * from spfli
*  INTO CORRESPONDING FIELDS OF TABLE itab.
*
*    LOOP AT itab.
*      IF itab-countryfr = itab-countryto.
*        itab-atype = '국내선'.
*        ELSE .
*           itab-atype = '해외선'.
*      ENDIF.
*
*select SINGLE carrname
*  from scarr
*  INTO itab-carrname
*  WHERE carrid = itab-carrid.
*      MODIFY itab.
*    ENDLOOP.
*
*  cl_demo_output=>display_data( itab ).
*
*
*  BREAK-POINT.
