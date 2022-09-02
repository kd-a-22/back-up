*&---------------------------------------------------------------------*
*& Report ZRSA22_16
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa22_16_top                           .    " Global Data

* INCLUDE ZRSA22_16_O01                           .  " PBO-Modules
* INCLUDE ZRSA22_16_I01                           .  " PAI-Modules
* INCLUDE ZRSA22_16_F01                           .  " FORM-Routines



START-OF-SELECTION.

SELECT *
  FROM zvsa2510 "emp&product database view
  INTO CORRESPONDING FIELDS OF TABLE gt_pro
  WHERE pernr = pa_emp.
*    Get Emp Info
  SELECT SINGLE *
    FROM ztsa2501
    INTO CORRESPONDING FIELDS OF gs_pro_2
    WHERE pernr = pa_emp.
    "Get Dep Info
  SELECT SINGLE *
    FROM ztsa2502_t
    INTO CORRESPONDING FIELDS OF gs_pro_2
    WHERE depid = gs_pro_2-depid.




*
*SELECT *
*  FROM zvsa2510 "emp&product database view
*  INTO CORRESPONDING FIELDS OF TABLE itab
*  WHERE pernr = pa_emp.
*
*SELECT *
*  FROM ztsa2501
*  APPENDING CORRESPONDING FIELDS OF TABLE itab
*  WHERE pernr = pa_emp.
*
*
**
*SELECT *
*  FROM ztsa2502_t
*  APPENDING CORRESPONDING FIELDS OF TABLE itab
*  WHERE depid = itab-depid. " ITAB 선언할 때 occurs 0 만 하고 WITH HEADER LINE 안 했을 때는
*                            " itab-depid is unknown 이라고 뜨는 데 헤더라인도 선언하니까 활성화 된다..
*                            " with headerline 엄청 중요하다... 헤더라인 = 컴포넌트인가봐..
*                            "그냥 internal table에는 컴포넌트라는 게 없나봄...
*



*cl_demo_output=>display_data( itab ).
