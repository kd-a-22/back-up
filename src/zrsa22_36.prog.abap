*&---------------------------------------------------------------------*
*& Report ZRSA22_36
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_36.
TYPES: BEGIN OF ts_dep,

         budget TYPE ztsa2202_1-budget,
         waers  TYPE ztsa2202_1-waers,
       END OF ts_dep.

DATA : gs_dep TYPE zssa2220,
       gt_dep LIKE TABLE OF gs_dep.

DATA go_salv TYPE REF TO cl_salv_table.



START-OF-SELECTION.

  SELECT *
    FROM ztsa2202_1
    INTO CORRESPONDING FIELDS OF TABLE gt_dep.

*cl_demo_output=>display_data( gt_dep ).

  cl_salv_table=>factory(
        IMPORTING r_salv_table = go_salv
        CHANGING t_table = gt_dep
           ).
  go_salv->display(  ).
