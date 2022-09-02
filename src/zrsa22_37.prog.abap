*&---------------------------------------------------------------------*
*& Report ZRSA22_37
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_37.

DATA : gs_info TYPE zvsa2202,
       gt_info LIKE TABLE OF gs_info.
*PARAMETERS pa_dep LIKE gs_info-depid.


START-OF-SELECTION.
*select *
*  from zvsa2202
*  INto CORRESPONDING FIELDS OF TABLE gt_info.
**  WHERE depid = pa_dep.


*SELECT *
*  FROM ztsa2201 INNER JOIN ztsa2202_1
*    ON ztsa2201~depid = ztsa2202_1~depid
*  INTO CORRESPONDING FIELDS OF TABLE gt_info
*  WHERE ztsa2201~depid = pa_dep.

*select a~pernr a~ename a~depid b~phone
*  from ztsa2201 as a INNER JOIN ztsa2202_1 as b
*  on a~depid = b~depid
*  INTO CORRESPONDING FIELDS OF TABLE gt_info.
**  WHERE a~depid = pa_dep.



*  SELECT *
*    FROM ztsa2201 AS emp  LEFT OUTER JOIN ztsa2202_1 AS dep
*    ON emp~depid = dep~depid
*    INTO CORRESPONDING FIELDS OF TABLE gt_info.



select * from ztsa2202_t as emp inner join ztsa2202_1 as t
  on emp~depid = t~depid
  INTO CORRESPONDING FIELDS OF table gt_info.


  cl_demo_output=>display_data( gt_info ).
