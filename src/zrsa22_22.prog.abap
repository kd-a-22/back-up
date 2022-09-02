*&---------------------------------------------------------------------*
*& Report ZRSA22_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA22_22.

*DATA GS_LIST TYPE SCARR.
*DATA GT_LIST LIKE TABLE OF GS_LIST.
*
*CLEAR: GT_LIST, GS_LIST.
**SELECT *    " SILGLE로 하지 않고 *로 STRUCTURE에 담으면 셀렉트도 반복문이라 한 번 돌아갈 때 마다 스트럭쳐에 들어가고 다시 새 데이터가 들어간다.
**    FROM SCARR
**    INTO CORRESPONDING FIELDS OF GS_LIST
**    WHERE CARRID BETWEEN 'ZZ' AND 'BA'.
**  APPEND GS_LIST TO GT_LIST.
**  CLEAR GS_LIST.
**  ENDSELECT.
*
*
*SELECT * "carrid carrname
*  FROM scarr
*  INTO CORRESPONDING FIELDS OF TABLE gt_list
*  WHERE CARRID BETWEEN 'AA' AND 'BA'.
*  WRITE SY-SUBRC.
*  WRITE SY-DBCNT.  " DB에 있는 레코드 수(인덱스 수..??)
*
*
*data gs_info type zsinfo.
*
*data gt_info like table of gs_info.
*
*parameters : pa_car_1 like gs_info-carrid,
*             pa_car_2 like gs_info-carrid.
*
*LOOP AT  gt_info into gs_info.
*select carrname
*    from scarr
*    INTO CORRESPONDING FIELDS OF gs_info
*    WHERE carrid BETWEEN pa_car_1 and pa_car_2.
*
*    APPEND gs_info to gt_info.
*    CLEAR gs_info.
*    ENDSELECT.
*ENDLOOP.
*
*
*
*
*  CL_DEMO_OUTPUT=>DISPLAY_DATA( GT_info ).


PARAMETERS :pa_num.
data : gv_star, gv_con type c LENGTH 4.




DO pa_num TIMES.
  gv_star = '*'.
  gv_con = gv_con + 1.

     DO gv_con TIMES.
       write  gv_star RIGHT-JUSTIFIED.
     ENDDO.

  NEW-LINE.
ENDDO.



DO  pa_num TIMES.


  write : gv_star.



*  gv_con = gv_con + 1.
*
*
*  DO gv_con TIMES.
*     write gv_con.
*    gv_star = '*'.
*  ENDDO.




ENDDO.
