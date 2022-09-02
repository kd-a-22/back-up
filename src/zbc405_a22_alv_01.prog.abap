*&---------------------------------------------------------------------*
*& Report ZBC405_A22_ALV_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a22_alv_01.

TABLES sflight.

TYPES : BEGIN OF typ_flt.

          INCLUDE   TYPE sflights.
TYPES :   changes_possible TYPE icon-id,
          bnt_text         TYPE c LENGTH 10,
          light            TYPE c LENGTH 1,
          row_color        TYPE c LENGTH 4,
          it_color         TYPE lvc_t_scol,
          it_styl          TYPE lvc_t_styl.

TYPES: END OF typ_flt.


DATA : gt_flt  TYPE TABLE OF typ_flt,
       gs_flt  LIKE LINE OF gt_flt,
       ok_code TYPE sy-ucomm.

*" FOR ALV data 선언
DATA : go_container TYPE REF TO cl_gui_custom_container,
       go_alv_grid  TYPE REF TO cl_gui_alv_grid,
       gv_varid     TYPE disvariant,
       gv_save      TYPE c LENGTH 1,
       gs_layout    TYPE lvc_s_layo,
       gt_sort      TYPE lvc_t_sort,
       gs_color     TYPE lvc_s_scol,
       gt_fcat      TYPE lvc_t_fcat,
       gs_fcat      TYPE lvc_s_fcat,
       gt_exct      TYPE ui_functions,
       gs_styl      TYPE lvc_s_styl.

DATA: gs_stable       TYPE lvc_s_stbl,
      gv_soft_refresh TYPE abap_bool.


SELECT-OPTIONS :
       so_car FOR sflight-carrid MEMORY ID car,
       so_con FOR sflight-connid MODIF ID con,
       so_dat FOR sflight-fldate.

SELECTION-SCREEN SKIP 1.
PARAMETERS: p_lv   TYPE disvariant-variant,
            p_date TYPE sy-datum.


PERFORM get_data.


START-OF-SELECTION.
  CALL SCREEN 100.

*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.
*	WHEN .
*	WHEN OTHERS.
  ENDCASE.


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
  SELECT *
    FROM sflights
    INTO CORRESPONDING FIELDS OF TABLE gt_flt
    WHERE carrid IN so_car
    AND   connid IN so_con
    AND   fldate IN so_dat.
  SORT  gt_flt.

ENDFORM.
*&---------------------------------------------------------------------*
*& Module CREAT_AND_TRANSFER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE creat_and_transfer OUTPUT.

  IF go_container IS INITIAL.

  ENDIF.
  CREATE OBJECT go_container
    EXPORTING
*     parent         =
      container_name = 'MY_CONTROL_AREA'
*     style          =
*     lifetime       = lifetime_default
*     repid          =
*     dynnr          =
*     no_autodef_progid_dynnr     =
    EXCEPTIONS
*     cntl_error     = 1
*     cntl_system_error           = 2
*     create_error   = 3
*     lifetime_error = 4
*     lifetime_dynpro_dynpro_link = 5
      OTHERS         = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  CREATE OBJECT go_alv_grid
    EXPORTING
*     i_shellstyle      = 0
*     i_lifetime        =
      i_parent = go_container
*     i_appl_events     = SPACE
*     i_parentdbg       =
*     i_applogparent    =
*     i_graphicsparent  =
*     i_name   =
*     i_fcat_complete   = SPACE
*     o_previous_sral_handler =
    EXCEPTIONS
*     error_cntl_create = 1
*     error_cntl_init   = 2
*     error_cntl_link   = 3
*     error_dp_create   = 4
      OTHERS   = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  PERFORM get_varid.
  CALL METHOD go_alv_grid->set_table_for_first_display
    EXPORTING
*     i_buffer_active  =
*     i_bypassing_buffer            =
*     i_consistency_check           =
      i_structure_name = 'SFLIGHT'
      is_variant       = gv_varid
      i_save           = 'X'  " A-> U,X모두 가능 U->사용자만 가능 X->디폴트만 가능
      i_default        = 'X'
*     is_layout        =
*     is_print         =
*     it_special_groups             =
*     it_toolbar_excluding          =
*     it_hyperlink     =
*     it_alv_graphics  =
*     it_except_qinfo  =
*     ir_salv_adapter  =
    CHANGING
      it_outtab        = gt_flt
*     it_fieldcatalog  =
*     it_sort          =
*     it_filter        =
*  EXCEPTIONS
*     invalid_parameter_combination = 1
*     program_error    = 2
*     too_many_lines   = 3
*     others           = 4
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.





ENDMODULE.
*&---------------------------------------------------------------------*
*& Form GET_AVIR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_varid .

  gv_varid-report = sy-cprog. " 이걸 설정해 주어야 CHOOS LAYOUT 버튼이 생기고 활성화 된다.
*  GV_VARID-VARIANT = P_LV.    " 이건 왜 있는 건 지 모르겠네... 해도 안 해도 다를 바가 없는 거 같은데


ENDFORM.
