*&---------------------------------------------------------------------*
*& Include          ZBC405_A22_EXAM01_F01
*&---------------------------------------------------------------------*

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_lay.
  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'L'
    CHANGING
      cs_variant  = gs_variant.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    p_lay = gs_variant.
  ENDIF.
  gs_variant-variant = p_lay.


INITIALIZATION.
  gs_variant-report = sy-cprog.  " 이걸 적어주어야 VARIANT 저장하고 어쩌구 해 주는 기능이 활성화 되는 듯.

START-OF-SELECTION.
  PERFORM get_data.
  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*& Module DISPLAY_ALV OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE display_alv OUTPUT.

  IF go_con IS INITIAL.


    CREATE OBJECT go_con
      EXPORTING
        container_name = 'MY_CONTROL'.

    IF sy-subrc = 0.


      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_con.

      IF sy-subrc = 0.

        PERFORM get_layout.
        PERFORM get_fieldcat.

        CALL METHOD go_alv->register_edit_event  " data changed 를 할 때 반드시 사용해야 한다. 얘를 해야 데이터가 변경될 때 반영 된다.
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_modified. " 변경되는 순간 반영


        APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_undo TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_copy TO gt_exct.

        SET HANDLER lcl_handler=>on_toolbar FOR go_alv.
        SET HANDLER lcl_handler=>on_user_command FOR go_alv.
        SET HANDLER lcl_handler=>on_before_user_com FOR go_alv.
        SET HANDLER lcl_handler=>on_doubleclick FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed FOR go_alv.

        SET HANDLER lcl_handler=>on_data_changed_finish FOR go_alv.

        CALL METHOD go_alv->set_table_for_first_display
          EXPORTING
*           i_buffer_active      =
*           i_bypassing_buffer   =
*           i_consistency_check  =
            i_structure_name     = 'ZTSPFLI_A22'
            is_variant           = gs_variant
            i_save               = 'A'
            i_default            = 'X'
            is_layout            = gs_layout
*           is_print             =
*           it_special_groups    =
            it_toolbar_excluding = gt_exct
*           it_hyperlink         =
*           it_alv_graphics      =
*           it_except_qinfo      =
*           ir_salv_adapter      =
          CHANGING
            it_outtab            = gt_flt
            it_fieldcatalog      = gt_fcat
*           it_sort              =
*           it_filter            =
*  EXCEPTIONS
*           invalid_parameter_combination = 1
*           program_error        = 2
*           too_many_lines       = 3
*           others               = 4
          .
        IF sy-subrc <> 0.
* Implement suitable error handling here
        ENDIF.
      ENDIF.
    ENDIF.



  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  DATA : ls_button TYPE stb_button.

  SELECT * FROM ztspfli_a22
   INTO CORRESPONDING FIELDS OF TABLE gt_flt
   WHERE carrid IN s_car
    AND  connid IN s_con.
  SORT gt_flt.





  LOOP AT gt_flt INTO gs_flt.

    SELECT SINGLE time_zone
      FROM sairport
      INTO gs_flt-fromtz
      WHERE id = gs_flt-airpfrom.

    SELECT SINGLE time_zone
    FROM sairport
    INTO gs_flt-totz
    WHERE id = gs_flt-airpfrom.





    IF  gs_flt-countryfr = gs_flt-countryto.
      gs_flt-ind = 'D'.
      gs_color-fname = 'IND'.
      gs_color-color-col = 3.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ELSE.
      gs_flt-ind = 'I'.
      gs_color-fname = 'IND'.
      gs_color-color-col = 5.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.


    IF gs_flt-fltype = 'X' .
      gs_flt-flight = icon_ws_plane.
    ELSE.
*     GS_FLT-FLIGHT = icon_okay.
    ENDIF.

    IF gs_flt-period > 2.
      gs_flt-light = 1.
    ELSEIF gs_flt-period = 1.
      gs_flt-light = 2.
    ELSE .
      gs_flt-light = 3.
    ENDIF.

*


    MODIFY gt_flt FROM gs_flt.

  ENDLOOP.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_layout .

  gs_layout-zebra = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-ctab_fname = 'IT_COLOR'.  " 셀 색.. 이거 안 해주면 셀 색깔 안 바뀐다.
  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-excp_led = 'X'.
  gs_layout-sel_mode = 'D'.


ENDFORM.

FORM get_fieldcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'FLTIME'.
  gs_fcat-edit = p_edit.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'DEPTIME'.
  gs_fcat-edit = p_edit.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'IND'.
  gs_fcat-coltext = 'I&D'.  "컬럼의 해딩..
  gs_fcat-col_pos = 6.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'FLIGHT'.
  gs_fcat-coltext = 'FLIGHT'.
  gs_fcat-col_opt = 'X'.
  gs_fcat-col_pos = 10.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'FROMTZ'.
  gs_fcat-coltext = 'rom TZone'.
  gs_fcat-ref_table = 'SAIRPORT'.
  gs_fcat-ref_field = 'TIME_ZONE'.
  gs_fcat-col_pos = 16.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'TOTZ'.
  gs_fcat-coltext = 'Tzone'.
  gs_fcat-ref_table = 'SAIRPORT'.
  gs_fcat-ref_field = 'TIME_ZONE'.
  gs_fcat-col_pos = 17.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'EXCEPTION'.
  gs_fcat-col_pos = 1.
  APPEND gs_fcat TO gt_fcat.




  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'FLTYPE'.
  gs_fcat-no_out = 'X' .  " 화면에서 안 보이게?? 필드 안 보이게 하는 거..
  APPEND gs_fcat TO gt_fcat.



  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'ARRTIME'.
  gs_fcat-emphasize = 'C710'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'PERIOD'.
  gs_fcat-emphasize = 'C710'.
  APPEND gs_fcat TO gt_fcat.
*
*    CLEAR: gs_fcat.
*  gs_fcat-fieldname = 'COUNTRYFR'.
*  gs_fcat-col_pos = 8.
*  APPEND gs_fcat TO gt_fcat.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form TIME_CHANGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM time_change  USING    per_data_changed TYPE REF TO cl_alv_changed_data_protocol
                           p_mod_cells TYPE lvc_s_modi.

  DATA : lv_fltime  TYPE ztspfli_a22-fltime,
         lv_deptime TYPE ztspfli_a22-deptime,
         lv_arrtime TYPE spfli-arrtime,
         lv_period  TYPE n , "ztspfli_a22-period,
         lv_totz    TYPE sairport-time_zone,
         lv_fromtz  TYPE sairport-time_zone.


  READ TABLE gt_flt INTO gs_flt INDEX p_mod_cells-row_id.

  CALL METHOD per_data_changed->get_cell_value
    EXPORTING
      i_row_id    = p_mod_cells-row_id
*     i_tabix     =
      i_fieldname = 'FLTIME'
    IMPORTING
      e_value     = lv_fltime.


  CALL METHOD per_data_changed->get_cell_value
    EXPORTING
      i_row_id    = p_mod_cells-row_id
*     i_tabix     =
      i_fieldname = 'DEPTIME'
    IMPORTING
      e_value     = lv_deptime.


  lv_fromtz = gs_flt-fromtz.
  lv_totz = gs_flt-totz.


  CALL FUNCTION 'ZBC405_CALC_ARRTIME'
    EXPORTING
      iv_fltime       = lv_fltime
      iv_deptime      = lv_deptime
      iv_utc          = lv_totz
      iv_utc1         = lv_fromtz
    IMPORTING
      ev_arrival_time = lv_arrtime
      ev_period       = lv_period.


  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = p_mod_cells-row_id
      i_fieldname = 'ARRTIME'
      i_value     = lv_arrtime.

  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = p_mod_cells-row_id
      i_fieldname = 'PERIOD'
      i_value     = lv_period.

*  CALL METHOD per_data_changed->modify_cell
*    EXPORTING
*      i_row_id    = p_mod_cells-row_id
*      i_fieldname = 'FROMTZ'
*      i_value     = lv_fromtz.
*
*  CALL METHOD per_data_changed->modify_cell
*    EXPORTING
*      i_row_id    = p_mod_cells-row_id
*      i_fieldname = 'TOTOZ'
*      i_value     = lv_totz.

  gs_flt-arrtime = lv_arrtime.
  gs_flt-period = lv_period.


  MODIFY gt_flt FROM gs_flt INDEX  p_mod_cells-row_id.




ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  DATA : p_ans TYPE c LENGTH 1.

  CASE ok_code.
    WHEN 'SAVE'.

      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'DATA SAVE!'
*         DIAGNOSE_OBJECT       = ' '
          text_question         = 'Do you want to Save ?'
          text_button_1         = 'yes'(001)
*         ICON_BUTTON_1         = ' '
          text_button_2         = 'No'(002)
*         ICON_BUTTON_2         = ' '
*         DEFAULT_BUTTON        = '1'
          display_cancel_button = 'X'
*         USERDEFINED_F1_HELP   = ' '
*         START_COLUMN          = 25
*         START_ROW             = 6
*         POPUP_TYPE            =
*         IV_QUICKINFO_BUTTON_1 = ' '
*         IV_QUICKINFO_BUTTON_2 = ' '
        IMPORTING
          answer                = p_ans
* TABLES
*         PARAMETER             =
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here

      ELSE.
        IF p_ans = '1'.
          PERFORM data_save.
        ENDIF.
      ENDIF.
  ENDCASE.





ENDMODULE.

FORM data_save.
*
  DATA : LT_FLT TYPE TABLE OF ZTSPFLI_A22,
         LS_FLT TYPE   ZTSPFLI_A22.

  LOOP AT GT_FLT INTO GS_FLT WHERE MODIFIED = 'X'.
    UPDATE ZTSPFLI_A22
    SET FLTIME = GS_FLT-FLTIME
        DEPTIME = GS_FLT-DEPTIME
        ARRTIME = GS_FLT-ARRTIME
        PERIOD = GS_FLT-PERIOD
      WHERE CARRID = GS_FLT-CARRID
       AND  CONNID = GS_FLT-CONNID
       AND  CITYFROM = GS_FLT-CITYFROM
       AND  AIRPFROM = GS_FLT-AIRPFROM
       AND  COUNTRYTO = gs_flt-COUNTRYTO
       and  CITYTO  = gs_flt-CITYTO
       and  AIRPTO = gs_flt-AIRPTO
       and  DISTANCE = gs_flt-DISTANCE.
  ENDLOOP.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_check
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM modify_check  USING    pls_mod_cells type lvc_s_modi.

 READ TABLE gt_flt INTO gs_flt INDEX pls_mod_cells-row_id.
  IF sy-subrc EQ 0.
    gs_flt-modified = 'X'.
    MODIFY gt_flt FROM gs_flt INDEX pls_mod_cells-row_id.
  ENDIF.


ENDFORM.
