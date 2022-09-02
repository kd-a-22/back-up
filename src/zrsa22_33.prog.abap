*&---------------------------------------------------------------------*
*& Report ZRSA22_33
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA22_33.

data gs_dep type zssa2206.            "Dep info
data: gt_emp type TABLE of zssa2205,  " Dep  info
      gs_emp like gt_emp.
PARAMETERS : pa_dep type ztsa2202_1-depid.

START-OF-SELECTION.
select SINGLE *
  from ztsa2202_1 "dep table
  INTO CORRESPONDING FIELDS OF gs_dep
  WHERE depid = pa_dep.


SELECT *
  from ZTSA2201
  INTO CORRESPONDING FIELDS OF table gt_emp
  WHERE depid = gs_dep-depid.

  cl_demo_output=>display_data( gt_emp ).
