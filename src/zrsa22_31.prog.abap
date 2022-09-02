*&---------------------------------------------------------------------*
*& Report ZRSA22_31
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa22_31_top                           .    " Global Data

* INCLUDE ZRSA22_31_O01                           .  " PBO-Modules
* INCLUDE ZRSA22_31_I01                           .  " PAI-Modules
INCLUDE zrsa22_31_f01                           .  " FORM-Routines

INITIALIZATION.
  PERFORM set_default.

START-OF-SELECTION.

  SELECT *
    FROM ztsa2201
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
    WHERE entdt BETWEEN pa_ent_b AND pa_ent_e.

  SELECT * FROM ztsa2202
    INTO CORRESPONDING FIELDS OF TABLE gt_dep.
  SORT gt_dep.


  IF sy-subrc IS NOT INITIAL.

    RETURN.

  ENDIF.

  cl_demo_output=>display_data( gt_dep ).
