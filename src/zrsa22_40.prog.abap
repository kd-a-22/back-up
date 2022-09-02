*&---------------------------------------------------------------------*
*& Report ZRSA22_40
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa22_40top                            .    " Global Data

* INCLUDE ZRSA22_40O01                            .  " PBO-Modules
* INCLUDE ZRSA22_40I01                            .  " PAI-Modules
INCLUDE zrsa22_40f01                            .  " FORM-Routines

INITIALIZATION.
  pa_maj = 'd220101'.

START-OF-SELECTION.
  PERFORM get_data.

  perform add_data_t USING gs_info
                           gs_info-colleg     gs_info-colleg_t    'G01' '경상대' 'G02' '공대' 'G03' '사범대'
                  CHANGING gt_info.
*
*PERFORM add_data_t USING gs_info gs_info-gender gs_info-gender_t '' '모름' '1' '남성' '2' '여성'
*                       CHANGING gt_info.


  cl_demo_output=>display_data( gt_info ).
