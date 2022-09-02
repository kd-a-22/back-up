*&---------------------------------------------------------------------*
*& Report ZRSA22_50
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa22_50_top                           .    " Global Data

* INCLUDE ZRSA22_50_O01                           .  " PBO-Modules
* INCLUDE ZRSA22_50_I01                           .  " PAI-Modules
INCLUDE zrsa22_50_f01                          .  " FORM-Routines



INITIALIZATION.

START-OF-SELECTION.
*-get data 1. ))----------------------------
*  SELECT
*    a~depid
*    "c~DTEXT
*    a~pernr
*    a~ename
*    b~pcode
*   " b~PTEXT
*    b~pkind
*   " b~PKIND_T
*    b~pcost
*    b~waers
*
*    from ztsa2201 as a INNER JOIN ztsa22_pro as b
*    ON a~pernr = b~pchar
*    INTO CORRESPONDING FIELDS OF TABLE gt_info
*    WHERE a~pernr = pa_per.
*
**    from ZTSA2202_T as c INNER JOIN ztsa2201 AS a
*    "and c~DTEXT = 'EN'.
*
*LOOP AT gt_info into gs_info.
*
*select SINGLE dtext
*  from ZTSA2202_T
*  INto CORRESPONDING FIELDS OF gs_info
*  WHERE depid = gs_info-depid.
*
*
*SELECT SINGLE PTEXT
*  from ztsa22_pro_t
*  INto CORRESPONDING FIELDS OF gs_info
*  WHERE pcode = gs_info-pcode.
*
*  IF gs_info-PKIND = 'C01'.
*    gs_info-PKIND_t = '스낵'.
*
*    ELSEIF gs_info-PKIND = 'C02'.
*    gs_info-PKIND_t = '음료'.
*
*    ELSEIF gs_info-PKIND = 'C03'.
*    gs_info-PKIND_t = '식품'.
*
*  ENDIF.
*
*
* MOdify gt_info from gs_info.
* clear gs_info.
*
*
*ENDLOOP.
*---------------------=

*==get data 2        ))=============================================
  SELECT
      a~depid  "부서 id                  ztsa2201
      c~dtext  " 부서 이름 -> text table  ZTSA2202_t
      a~pernr  "사원 번호
      a~ename  "사원 이름
      b~pcode  "제품 코드                ztsa22_pro
      d~ptext  "제품 이름 -> text table  ZTSA22_PRO_T
      b~pkind  "제품 종류
      "b~PKIND_T "제품 종류 이름
      b~pcost  "제품 원가
      b~waers  "제품 원가 단위
      FROM  ztsa2202_t AS c  INNER JOIN ztsa2201 AS a
                                 ON c~depid = a~depid
                             INNER JOIN  ztsa22_pro AS b
                                 ON a~pernr = b~pchar
                             INNER JOIN ztsa22_pro_t AS d
                                 ON b~pcode = d~pcode
      INTO CORRESPONDING FIELDS OF TABLE gt_info
      WHERE a~pernr = pa_per
      AND d~spras = 'E'
      AND c~spras = 'E'.



  LOOP AT gt_info INTO gs_info.
    IF gs_info-pkind = 'C01'.
      gs_info-pkind_t = '스낵'.

    ELSEIF
    gs_info-pkind = 'C02'.
      gs_info-pkind_t = '음료'.

    ELSEIF
    gs_info-pkind = 'C03'.
      gs_info-pkind_t = '식품'.

    ENDIF.


    MODIFY gt_info FROM gs_info.
    CLEAR gs_info.
  ENDLOOP.

  cl_salv_table=>factory(
        IMPORTING r_salv_table = go_salv
        CHANGING t_table = gt_info
          ).

  go_salv->display(  ).



*  cl_demo_output=>display_data( gt_info ).
