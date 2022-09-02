*&---------------------------------------------------------------------*
*& Report ZRSA22_25
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa22_25_top                           .    " Global Data

* INCLUDE ZRSA22_25_O01                           .  " PBO-Modules
* INCLUDE ZRSA22_25_I01                           .  " PAI-Modules
 INCLUDE zrsa22_25_f01                           .  " FORM-Routines


 START-OF-SELECTION.
 WRITE 'Test'.


 SELECT *
   FROM sflight
   INTO CORRESPONDING FIELDS OF TABLE gt_info
   WHERE carrid = pa_car
   and connid BETWEEN pa_con1 and pa_con2.
*   AND connid in so_con[].

 cl_demo_output=>display_data( gt_info ).
