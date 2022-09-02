*&---------------------------------------------------------------------*
*& Report ZRSA22_32
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_32.

DATA : gs_emp TYPE zssa0010.

PARAMETERS pa_pernr LIKE gs_emp-pernr.

INITIALIZATION.
  pa_pernr = '22020001'.

START-OF-SELECTION.
  SELECT SINGLE *
      FROM ztsa2201
    INTO CORRESPONDING FIELDS OF gs_emp
    WHERE pernr = pa_pernr.



*  IF GS_EMP IS INITIAL.
  IF sy-subrc <> 0.  " 같은 말.

*    MESSAGE i016(pn) WITH 'DATA IS NOT FOUND ! '.
   "Data is not found
    MESSAGE i001(zmcsa22).
    RETURN.

  ENDIF.

  select SINGLE *
    from ztsa2202_1
    into gs_emp-dep
    where depid = gs_emp-depid.

  cl_demo_output=>display_data( gs_emp ).  "일반적인 스트럭쳐만 출력 가능   nast structure는 안 됨. 하지만 nast structure의 필드는 출력할 수 있다.
