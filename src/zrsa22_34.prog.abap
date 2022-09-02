*&---------------------------------------------------------------------*
*& Report ZRSA22_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_34.



DATA gs_dep TYPE zssa2211.
DATA gt_dep LIKE TABLE OF gs_dep.

" emp info (structure variable)
DATA gs_emp LIKE LINE OF gs_dep-emp_list.

PARAMETERS pa_dep TYPE ztsa2202_1-depid.

START-OF-SELECTION.

  SELECT SINGLE *
    FROM ztsa2201
    INTO CORRESPONDING FIELDS OF gs_dep
    WHERE depid = pa_dep.

    IF  sy-subrc <> 0.
      RETurn.


    ENDIF.


    "get Employee list
    select *
      from ztsa2201 "emptable
      INTO CORRESPONDING FIELDS OF table gs_dep-emp_list
      WHERE depid = gs_dep-depid.

      LOOP AT gs_dep-emp_list into gs_emp.
         " get gender text
        MODIFY gs_dep-emp_list from gs_emp.
        CLEar gs_emp.

      ENDLOOP.
