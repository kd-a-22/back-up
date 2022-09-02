*&---------------------------------------------------------------------*
*& Report ZBC405_ALV_CL1_A22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_alv_cl1_a22.

TABLES : ztsbook_a22.

*-------------------------
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS: so_car FOR ztsbook_a22-carrid OBLIGATORY MEMORY ID car,
                  so_con FOR ztsbook_a22-connid MEMORY ID con,
                  so_fld FOR ztsbook_a22-fldate,
                  so_cus FOR ztsbook_a22-customid.
  SELECTION-SCREEN SKIP .
  PARAMETERS : p_edit AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN SKIP .
PARAMETERS : p_layout TYPE disvariant-variant.
*--------------------------
DATA : gt_custom TYPE TABLE OF ztscustom_a22,
       gs_custom TYPE ztscustom_a22.
*----- RANGE TYTPE
DATA : rt_tab TYPE zz_range_type.
DATA : rs_tab TYPE LINE OF zz_range_type.
*----/
TYPES : BEGIN OF gty_sbook.
          INCLUDE TYPE ztsbook_a22.
TYPES :   light TYPE c LENGTH 1.
TYPES : telephone TYPE ztscustom_a22-telephone.
TYPES :     email TYPE ztscustom_a22-email.
TYPES : row_color TYPE c LENGTH 4.
TYPES :  it_color TYPE lvc_t_scol.
TYPES :        bt TYPE lvc_t_styl.
TYPES : modified  TYPE c LENGTH 1.  " 레코드가 변경되면 x 가 들어올 것이다.
TYPES : END OF gty_sbook.

DATA : gt_sbook TYPE TABLE OF gty_sbook,
       dl_sbook TYPE TABLE OF ztsbook_a22,   "for deleted records
       dw_sbook type ztsbook_a22,
       gs_sbook TYPE          gty_sbook.


DATA : ok_code TYPE sy-ucomm.


DATA : go_container TYPE REF TO cl_gui_custom_container,
       go_alv       TYPE REF TO cl_gui_alv_grid.

DATA : gs_variant TYPE disvariant,
       gs_layout  TYPE lvc_s_layo,
       gt_sort    TYPE lvc_t_sort,
       gs_sort    TYPE lvc_s_sort,
       gs_color   TYPE lvc_s_scol,    " layout
       gt_exct    TYPE ui_functions,  " toolbat excluding
       gt_fcat    TYPE lvc_t_fcat,
       gs_fcat    TYPE lvc_s_fcat.

INCLUDE zbc405_alv_cl1_a22_class.
*-----------------------------
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F' " => ㄹ4를 누르겠다    " S(SAVE), L (LOAD??)
    CHANGING
      cs_variant  = gs_variant.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    p_layout = gs_variant-variant.
  ENDIF.


INITIALIZATION.
  gs_variant-report = sy-cprog.
  rs_tab-low = 'AA'.
  rs_tab-sign = 'I'.
  rs_tab-option = 'EQ'.
  APPEND rs_tab TO rt_tab.

  so_car[] = rt_tab[].

START-OF-SELECTION.
  PERFORM get_data.

  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .


  DATA : gt_temp TYPE TABLE OF gty_sbook.

  SELECT * FROM ztsbook_a22
    INTO CORRESPONDING FIELDS OF TABLE gt_sbook
    WHERE carrid IN so_car
    AND connid IN so_con
    AND fldate IN so_fld
    AND customid IN so_cus.
  SORT gt_sbook.


  IF sy-subrc EQ 0.
    gt_temp = gt_sbook.
    DELETE gt_temp WHERE customid = space.    " 빈 값 지우기
    SORT gt_temp BY customid.
    DELETE ADJACENT DUPLICATES FROM gt_temp COMPARING customid.  " 중복 지우기

    SELECT * INTO TABLE gt_custom
      FROM ztscustom_a22
      FOR ALL ENTRIES IN gt_temp
      WHERE id = gt_temp-customid.

  ENDIF.
  LOOP AT gt_sbook INTO gs_sbook.
    READ TABLE gt_custom INTO gs_custom WITH KEY id = gs_sbook-customid.
    IF sy-subrc EQ 0.
      gs_sbook-telephone = gs_custom-telephone.
      gs_sbook-email = gs_custom-email.

    ENDIF.



*    ----/ EXCEPTION HANDLING
    IF gs_sbook-luggweight > 25.
      gs_sbook-light = 1.     " red
    ELSEIF gs_sbook-luggweight > 15 .
      gs_sbook-light = 2.   " yellow
    ELSE.
      gs_sbook-light = 3. " green
    ENDIF.
*    -----/
    IF gs_sbook-class = 'F'.
      gs_sbook-row_color = 'C711'.
    ENDIF.

    IF gs_sbook-smoker = 'X'.
      gs_color-fname = 'SMOKER'.
      gs_color-color-col = col_negative.
      gs_color-color-int = '1' .
      gs_color-color-inv =  '0'.

      APPEND gs_color TO gs_sbook-it_color.


    ENDIF.




    MODIFY gt_sbook FROM gs_sbook.


  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  IF p_edit = 'X'.
    SET PF-STATUS 'S100'.
  ELSE.
    SET PF-STATUS 'S100' EXCLUDING 'SAVE'.
  ENDIF.
  SET TITLEBAR 'T100' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  DATA : p_ans TYPE c LENGTH 1.

  CASE ok_code.

    WHEN 'SAVE'.

      CALL FUNCTION 'POPUP_TO_CONFIRM'  " 메시지를 확인한다.??확인을 위한 메시지 팝업 창을 띄우는 펑션
        EXPORTING
          titlebar              = 'Data Save! '
*         DIAGNOSE_OBJECT       = ''
          text_question         = 'Do you want to Save ?'
          text_button_1         = 'yes'(001)
*         ICON_BUTTON_1         = ' '
          text_button_2         = 'No'(002)
*         ICON_BUTTON_2         = ' '
*         DEFAULT_BUTTON        = '1'   " 1번이 yes 이다.
          display_cancel_button = ' '   " 공백으로 두면 취소버튼 없이 back, yes버튼만 뜬다.
*         USERDEFINED_F1_HELP   = ' '
*         START_COLUMN          = 25
*         START_ROW             = 6
*         POPUP_TYPE            =
*         IV_QUICKINFO_BUTTON_1 = ' '
*         IV_QUICKINFO_BUTTON_2 = ' '
        IMPORTING
          answer                = p_ans
*         TABLES
*         PARAMETER             =
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ELSE .
        IF  p_ans = '1'.
          PERFORM data_save.
        ENDIF.
      ENDIF.

  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREAT_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE creat_alv_object OUTPUT.

  IF go_container IS INITIAL.
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.


    IF sy-subrc EQ 0.
      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_container.


      IF sy-subrc = 0.
        gs_variant-variant = p_layout. "얘를 적어주어야 PARAMETERS에서 레이아웃 입력해서 들어갈 때 설정한 것이 반영 된다.
        PERFORM get_layout.
        PERFORM get_sort.
        PERFORM make_field_cataloge.

        CALL METHOD go_alv->register_edit_event
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_modified. " 변경되는 순간 반영

        APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.  "필터 아이콘  사용 안 하는 툴바 아이콘 숨기기
        APPEND cl_gui_alv_grid=>mc_fc_info TO gt_exct.    " info 아이콘
        APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_exct.


        SET HANDLER lcl_handler=>on_doubleclick FOR go_alv.   " static method 일 떼 =>를 사용.본인 스스로가 참조하는 아이가 되었을 때 =>를 사용.
        SET HANDLER lcl_handler=>on_toolbar     FOR go_alv.   " incetance method 를 쓸 때는 하나짜리
        SET HANDLER lcl_handler=>on_usercommad FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed_finish FOR go_alv.


**        -- I_SAVE : '' 변경만 가능한 상태 생성 못 함  A UX다 됨  X 디폴트만 가능  U 자기가 설정한 거 자기만 볼 수 있더. 글로벌은 못 건들임
        CALL METHOD go_alv->set_table_for_first_display
          EXPORTING
*           i_buffer_active      =
*           i_bypassing_buffer   =
*           i_consistency_check  =
            i_structure_name     = 'ZTSBOOK_A22'
            is_variant           = gs_variant
            i_save               = 'A'
            i_default            = 'X'  " I_SAVE 에서 사용.. LAYOUT 저장시 창에서 사용됨.
            is_layout            = gs_layout
*           is_print             =
*           it_special_groups    =
            it_toolbar_excluding = gt_exct
*           it_hyperlink         =
*           it_alv_graphics      =
*           it_except_qinfo      =
*           ir_salv_adapter      =
          CHANGING
            it_outtab            = gt_sbook
            it_fieldcatalog      = gt_fcat   " sturcture에는 없지만 internal table에는 있는 것을 보이고 싶다. 할 때 사용. 기본에 있는 것을 바꿀때.. 필드 명을 바꾸거나 필드의 내용ㅇ을 바꿀 때 (EX 필드를 체크박스로 바꿈ㅁ??)
            it_sort              = gt_sort
*           it_filter            =
*          EXCEPTIONS
*           invalid_parameter_combination = 1
*           program_error        = 2
*           too_many_lines       = 3
*           others               = 4
          .
        IF sy-subrc <> 0.
*         Implement suitable error handling here
        ENDIF.


      ENDIF.
    ENDIF.



  ELSE.

    DATA: gs_stable       TYPE lvc_s_stbl,
          gv_soft_refresh TYPE abap_bool.
*    ---REGRESH ALV METHOD 가 올 자리 / 이 부분을 타면 화면을 다시 보여준다. 다시 보여줄 때 스크롤의 위치나 화면의 상태 등을 고정된채로 refresh 한다.
    gv_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.

    CALL METHOD go_alv->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.



  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Form GT_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_layout .

  gs_layout-sel_mode ='D'.
  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-excp_led = 'X'.  " ICON 모양 변경
  gs_layout-zebra = 'X'.
  gs_layout-cwidth_opt = 'X'.
*  GS_LAYOUT-EDIT = 'X'.

  gs_layout-info_fname = 'ROW_COLOR'.
  gs_layout-ctab_fname = 'IT_COLOR'.
  gs_layout-stylefname = 'BT'.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_SORT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_sort .
  CLEAR: gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 1.
  APPEND gs_sort TO gt_sort.

  CLEAR: gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 2.
  APPEND gs_sort TO gt_sort.

  CLEAR: gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down = 'X'.
  gs_sort-spos = 3.
  APPEND gs_sort TO gt_sort.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_field_cataloge
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_field_cataloge .

  CLEAR: gs_fcat.
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'Info'."컬럼의 해딩..
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'SMOKER'.
  gs_fcat-checkbox = 'X' .
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname ='INVOICE'.
  gs_fcat-checkbox = 'X' .
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CANCELLED'.
  gs_fcat-checkbox = 'X' .
  gs_fcat-edit      = p_edit . "'x'   "필드 열기.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'TELEPHONE'.
  gs_fcat-ref_table = 'ZTSCUSTOM_A22'.
  gs_fcat-ref_field = 'TELEPHONE'. " 이렇게 해 주면 해당 테이블의 필드의 엘리먼트의 도메인에 있는 정보를 가지고 와서 대소문자구문이나 등을 따라 만들어진다.
  gs_fcat-col_pos = '30'.  " 필드 넓이 인듯
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'EMAIL'.
  gs_fcat-ref_table = 'ZTSCUSTOM_A22'.
  gs_fcat-ref_field = 'EMAIL'. " 이렇게 해 주면 해당 테이블의 필드의 엘리먼트의 도메인에 있는 정보를 가지고 와서 대소문자구문이나 등을 따라 만들어진다.
  gs_fcat-col_pos = '31'.      " 필드 넓이 인듯
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CUSTOMID'.
*  gs_fcat-emphasize = 'C400'.     " 컬럼 샐 추가. 컬럼의 강조를 필요로 할 때 쓴다.
  gs_fcat-edit      = p_edit. "'x' "필드 열기.
  APPEND gs_fcat TO gt_fcat.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form CUSTOMER_CHANGE_PART
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM customer_change_part  USING    per_data_changed
                                    TYPE REF TO cl_alv_changed_data_protocol
                                    ps_mod_cells TYPE lvc_s_modi.


  DATA: l_customid TYPE ztsbook_a22-customid,
        l_phone    TYPE ztscustom_a22-telephone,
        l_email    TYPE ztscustom_a22-email,
        l_name     TYPE ztscustom_a22-name.
  READ TABLE gt_sbook INTO gs_sbook INDEX ps_mod_cells-row_id.

  CALL METHOD per_data_changed->get_cell_value   " 값을 입력한 셀을 읽는다.
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
*     i_tabix     =
      i_fieldname = 'CUSTOMID'
    IMPORTING
      e_value     = l_customid.   " 입력된 값을 받는 변수.

  IF l_customid IS NOT INITIAL .

    READ TABLE gt_custom INTO gs_custom  WITH KEY id = l_customid.
    IF sy-subrc EQ 0.
      l_phone = gs_custom-telephone.
      l_email = gs_custom-email.
      l_name = gs_custom-name.
    ELSE.
      SELECT SINGLE telephone email name
              INTO  (l_phone, l_email, l_name)
               FROM ztscustom_a22
               WHERE id = l_customid.
    ENDIF.
  ELSE .
    CLEAR: l_email, l_phone, l_name.  " 만약 입력했다가 지운 경우 폰, 메일 필드에 있던 애들을 다시 지운다.
  ENDIF.


  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id   " 입력하고 있는 위치??
      i_fieldname = 'TELEPHONE'
      i_value     = l_phone.              " 바꿀 값?

  CALL METHOD per_data_changed->modify_cell  " 화면에 있는 내용을 바꾸는 것.
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'EMAIL'
      i_value     = l_email.

  CALL METHOD per_data_changed->modify_cell  " 화면에 있는 내용을 바꾸는 것.
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'PASSNAME'
      i_value     = l_name.       "============// 화면에서 만 바뀐 것.

  gs_sbook-email = l_email.
  gs_sbook-telephone = l_phone.
  gs_sbook-passname = l_name.

  MODIFY gt_sbook FROM gs_sbook INDEX ps_mod_cells-row_id.  " 인터널 테이블을 바꾸는 것.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form insert_parts
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_INS_CELLS
*&---------------------------------------------------------------------*
FORM insert_parts  USING rr_data_changed TYPE REF TO
                             cl_alv_changed_data_protocol
                            rs_ins_cells TYPE lvc_s_moce.


  gs_sbook-carrid = so_car-low.
  gs_sbook-connid = so_con-low.
  gs_sbook-fldate = so_fld-low.

*READ TABLE RR_DATA_CHANGED



  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CARRID'
      i_value     = gs_sbook-carrid.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CONNID'
      i_value     = gs_sbook-connid.



  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'FLDATE'
      i_value     = gs_sbook-fldate.



  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'ORDER_DATE'
      i_value     = sy-datum.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CUSTTYPE'
      i_value     = 'P'.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CLASS'
      i_value     = 'C'.

  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CUSTTYPE'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.


*
*  CALL METHOD rr_data_changed->modify_style
*    EXPORTING
*      i_row_id    = Rs_ins_cells-row_id
*      i_fieldname = 'CLASS'
*      i_style     = cl_gui_alv_grid=>mc_style_enabled.
*
*


  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CUSTTYPE'
      i_style     = cl_gui_alv_grid=>mc_style_enabled. " 필드 입력 가능하게 여는 것.. INSERT : 필드 닫는 것.



  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CUSTOMID'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'DISCOUNT'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.



*  CALL METHOD rr_data_changed->modify_style
*    EXPORTING
*      i_row_id    = Rs_ins_cells-row_id
*      i_fieldname = 'PHONE'
*      i_style     = cl_gui_alv_grid=>mc_style_enabled.



  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'SMOKER'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.


  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'LUGGWEIGHT'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.



  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'SMOKER'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.


  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'WUNIT'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.


  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'INVOICE'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.


  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'FORCURAM'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.



  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'FORCURKEY'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'LOCCURAM'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.



  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'LOCCURKEY'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.


  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'ORDER_DATE'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.




  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'AGENCYNUM'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.



  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'PASSNAME'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.









  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CONNID'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'FLDATE'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.

  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CARRID'
      i_style     = cl_gui_alv_grid=>mc_style_enabled.






  MODIFY gt_sbook FROM gs_sbook INDEX rs_ins_cells-row_id .

*

ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_check
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM modify_check  USING    pls_mod_cells TYPE lvc_s_modi.

  READ TABLE gt_sbook INTO gs_sbook INDEX pls_mod_cells-row_id.
  IF sy-subrc EQ 0.
    gs_sbook-modified = 'X'.
    MODIFY gt_sbook FROM gs_sbook INDEX pls_mod_cells-row_id.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form DATA_SAVE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save .

  DATA : ins_sbook TYPE TABLE OF ztsbook_a22,  "insert 될 얘들을 한 번에 모으려고 만드는 것.
         wa_sbook  TYPE ztsbook_a22.

*---- update 대상
  LOOP AT gt_sbook INTO gs_sbook WHERE modified = 'X'.
    UPDATE ztsbook_a22
          SET customid  = gs_sbook-customid
              cancelled = gs_sbook-cancelled
              passname  = gs_sbook-passname
          WHERE carrid = gs_sbook-carrid
            AND connid = gs_sbook-connid
            AND fldate = gs_sbook-fldate
            AND bookid = gs_sbook-bookid.
  ENDLOOP.

*  ---- insert 부분
  DATA : next_number TYPE s_book_id,
         ret_code    TYPE inri-returncode.
  DATA : l_tabix LIKE sy-tabix.

  clear : ins_sbook.  " 이거 했더니 한줄 추가시 6줄 추가 사라짐..

  LOOP AT gt_sbook INTO gs_sbook WHERE bookid IS INITIAL.
    l_tabix = sy-tabix.
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZBOOKIDA22'
        subobject               = gs_sbook-carrid
        ignore_buffer           = ' '
      IMPORTING
        number                  = next_number
        returncode              = ret_code
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* Implement suitable error handling here
   ELSE.

    IF next_number IS NOT INITIAL.
      gs_sbook-bookid = next_number.

      MOVE-CORRESPONDING gs_sbook TO wa_sbook.
      APPEND wa_sbook TO ins_sbook.

      MODIFY gt_sbook FROM gs_sbook INDEX l_tabix TRANSPORTING bookid.  " bookid만 콕 찝어서 modify 하겠다.
    ENDIF.
    endif.
  ENDLOOP.

IF  ins_sbook is not INITIAL .
  INSERT ztsbook_a22 from table ins_sbook.
  ENDIF.

****delet
IF  dl_sbook is NOT INITIAL.
  delete ztsbook_a22 from table dl_sbook.
  clear : dl_sbook. REFRESH : dl_sbook.

ENDIF.


ENDFORM.
