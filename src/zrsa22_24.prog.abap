*&---------------------------------------------------------------------*
*& Report ZRSA22_24
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa22_24_top                           .    " Global Data

* INCLUDE ZRSA22_24_O01                           .  " PBO-Modules
* INCLUDE ZRSA22_24_I01                           .  " PAI-Modules
 INCLUDE zrsa22_24_f01                           .  " FORM-Routines

 INITIALIZATION.

 AT SELECTION-SCREEN OUTPUT.

 AT SELECTION-SCREEN.



 START-OF-SELECTION.

 perform add_airlin.


   IF GT_AIR IS INITIAL.
     MESSAGE I016(PN) WITH 'DATA IS NOT FOUND!'.
    ELSE .

  cl_demo_output=>display_data( gt_air ).

   ENDIF.
