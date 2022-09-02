*&---------------------------------------------------------------------*
*& Include          ZBC405_A22_ALV_E01
*&---------------------------------------------------------------------*


*" SELECTION SCREEN.
SELECT-OPTIONS: so_car FOR sflight-carrid MEMORY ID car,
                so_con FOR sflight-connid MEMORY ID con,
                so_dat FOR sflight-fldate.

SELECTION-SCREEN SKIP 1.  " WRITE 문의 / 같은 거 인듯.
PARAMETERS : pa_lv TYPE disvariant-variant.
PARAMETERS : pa_date TYPE sy-datum DEFAULT ''.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.  " 다음 이벤트가 나오기 전까지가 이 이벤트 로직이다.


  gv_varid-report = sy-cprog.


  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'  " 베리언트를 셀렉션 스크린에서 F4 창으로 선택ㅎㅐ서 할 때 타는 구문.. 그냥 손으로 입력해서 하면 이 구문은 타지 않는다.?
    EXPORTING
      i_save_load     = 'F'      " S, F(파서블엔트리 보여줌 F4의 약자), L
    CHANGING
      cs_variant      = gv_varid
    EXCEPTIONS
      not_found       = 1
      wrong_input     = 2
      fc_not_complete = 3
      OTHERS          = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    pa_lv = gv_varid-variant.
  ENDIF.

START-OF-SELECTION.
  PERFORM get_data.
  CALL SCREEN 100.


*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.       " EXCLUDING '버튼 펑션코드'.  하면 해당 버튼은 실행해도 화면에 보이지 않는다.
  SET TITLEBAR 'T100' WITH sy-datum sy-uname.
ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      LEAVE TO SCREEN 0.              " selection screen으로 빠져나가라.


      CALL METHOD go_alv_grid->free.
      CALL METHOD go_container->free.
      FREE : go_alv_grid, go_container.
      "메모리 확보를 위해 묵시적으로 오브젝트를 만든 것을 릴리즈 해줌으로서 메모리를 확보하는 것을 원칙으로 한다.
      " 찌끄러기 같은 것이 남아있을 수 있으니 해주는 것이 좋다.  안 해주어도 실행에 문제는 없다.

  ENDCASE.


ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_AND_TRANSFER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_and_transfer OUTPUT.
  IF go_container IS INITIAL.  " 버튼을 누를 때 마다 PBO를 타는데 그 때마다 컨테이너가 만들어지는 것은 비효율적.. 그래서 컨테이너가 없을 때만 만들라고 한 것.
    " 컨테이너 만들기
    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.



    " 컨테이너에 그리드 얹기
    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = go_container
*
      EXCEPTIONS
        OTHERS   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    PERFORM make_varid.
    PERFORM make_layout.
    PERFORM make_sort.
    PERFORM make_fieldcatalog.

    APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.  " alv 툴바 아이콘 사라짐.
*         "   클래스          어트리뷰트
    APPEND cl_gui_alv_grid=>mc_fc_info TO gt_exct.
    " < => >해당 클래스의 어트리뷰트를 직접 참조한다.
* APPEND CL_GUI_ALV_GRID=>MC_FC_EXCL_ALL TO GT_EXCT.  " ALV의 모든 툴바 전부 사라짐


    " TABLE 출력하기.

    SET HANDLER lcl_handler=>on_doubleclick FOR go_alv_grid.  " 트리거 설정.이벤트가 타도록.
    SET HANDLER lcl_handler=>on_hotspot FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_toolbar FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_user_command FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_button_click FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_context_menu_request FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_before_user_com FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_data_changed FOR go_alv_grid.


    CALL METHOD go_alv_grid->set_table_for_first_display
    exporting
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
      i_structure_name              = 'SFLIGHT'   " 참조할 구조??
      is_variant                    = gv_varid
      i_save                        = gv_save        " 베리언트 관련)) X(디폴트만 가능??), A(X,U모두), U(사용자 별로 만들겠다??)
      i_default                     = 'X'            " 베리언트 관련)) 비어있으면 글로벌 디폴트 설정한는 체크박스 사라짐.
      is_layout                     = gs_layout     "얼룸갈, 셀 넓이, 셀 선택, 신호등, 레코드/셀 컬러
*       is_print                      =  " TOP-OF-PAGE , 여기서 선언하는 듯
*       it_special_groups             =
      it_toolbar_excluding          = gt_exct " ALV 툴바 사라짐.
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
    changing
      it_outtab                     = gt_flt  " 보여질 TALBE 구조??
      it_fieldcatalog               = gt_fcat
      it_sort                       = gt_sort   " TABLE TYPE 이 와야 한다.
*       it_filter                     =
    exceptions
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      others                        = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


  ELSE.
***-================== new .. alv 셀을 수정하고 리프레시 해도 여전히 해당 위치에 고정되어있도록 .. 패턴으로 불러옴.
***     다시 CREATE 컨테이너 하지 않고 ALV 화면 수정만 하ㅏ면 되니까. 그래서 이걸 쓴다???

    gv_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.

    CALL METHOD go_alv_grid->refresh_table_display    " AVL 화면의 스크롤 기억?????
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*   Implement suitable error handling here
    ENDIF.

  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form get_Data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .


  SELECT * FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_flt
    WHERE carrid IN so_car
      AND connid IN so_con
      AND fldate IN so_dat.

  LOOP AT gt_flt INTO gs_flt.
    SELECT SINGLE *
      FROM saplane
      INTO CORRESPONDING FIELDS OF gs_flt
      WHERE planetype = gs_flt-planetype.

    MODIFY gt_flt FROM gs_flt.

  ENDLOOP.

  " 신호등... 필드 중 맨 앞에 나오도록 정해져 있다. 색깔도 정해져 있음.. 내가 바꿀 수 없다.
  LOOP AT gt_flt INTO gs_flt.
    IF gs_flt-seatsocc < 5.
      gs_flt-light = 1.
    ELSEIF  gs_flt-seatsocc < 100.
      gs_flt-light = 2.
    ELSE .
      gs_flt-light = 3.
    ENDIF.

    " 조건에 맞는 레코드 색 바꾸기 ROW-COLOR
    IF  gs_flt-fldate+4(2) = sy-datum+4(2).
      gs_flt-low_color = 'C511'.
    ENDIF.

    IF gs_flt-planetype = '747-400'.
      gs_color-fname = 'PLANETYPE'.
      gs_color-color-col = col_total.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.

    IF gs_flt-seatsocc_b = 0.
      gs_color-fname = 'SEATSOCC_B'.
      gs_color-color-col = col_negative.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.
    " ICON 으로 이루어진 필드 추가.?
    IF gs_flt-fldate < pa_date.
      gs_flt-changes_possible = icon_space.
    ELSE.
      gs_flt-changes_possible = icon_okay.

    ENDIF.

    IF gs_flt-seatsmax_b = gs_flt-seatsocc_b.
      gs_flt-bnt_text = 'FullSeats!'.

      gs_styl-fieldname = 'BNT_TEXT'.
      gs_styl-style = cl_gui_alv_grid=>mc_style_button.
      APPEND gs_styl TO gs_flt-it_styl.

    ENDIF.


   gs_flt-to = gs_flt-seatsmax - gs_flt-seatsocc.


*    IF GS_FLT-CARRID.
*       gs_flt-bnt_text2 = 'CARRID!'.
*
*       gs_styl-fieldname = 'CARRID_CODE'.
*       GS_styl-style = cl_gui_alv_grid=>mc_style_button.
*       APPEND gs_styl2 to gs_flt-it_styl2.
*
*    ENDIF.
    MODIFY gt_flt FROM gs_flt.
  ENDLOOP.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_VARID
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_varid .
  gv_varid-report = sy-cprog.
  gv_varid-variant = pa_lv.
  gv_save = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_LAYOUR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout .


  gs_layout-zebra = 'X'.         " 얼룩말
*  gs_layout-cwidth_opt = 'X'.    " FIELDCAT COL_OPT 역할 .. 칼럼 글자에 넓이 맞추기.

  gs_layout-sel_mode = 'D'.      " 멀티풀 로우.. 어려 셀 선택 가능. 셀딜드 있음  B = 하나의 셀만 선택 가능셀필드 있음. C=셀필드 없지만 여러개 선택 가능. 셀단위 선택 안 됨. D는 모든 게 다 됨.

  gs_layout-excp_fname = 'LIGHT'." 신호등 설정  'LIGHT'는 변수 이름!!
  gs_layout-excp_led = 'X'.      " 신호등 하나만 귀엽게


  gs_layout-info_fname = 'LOW_COLOR'.  " 레코드 별 색
  gs_layout-ctab_fname = 'IT_COLOR'.   " 셀 별 색

  gs_layout-stylefname = 'IT_STYL'.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_SORT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_sort .

  CLEAR gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 1.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up = 'X'.
  gs_sort-spos = 2.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down = 'X'.
  gs_sort-spos = 3.
  APPEND gs_sort TO gt_sort.

*SORT GT_S DESCENDING

ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_FIELDCATALOG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fieldcatalog.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CARRID'.
*  gs_fcat-HOTSPOT = 'X'.      "  핫스팟 설정
  APPEND gs_fcat TO gt_fcat.


  CLEAR gs_fcat.
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'INFO'.    " 이름 바꾸기
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.

  gs_fcat-fieldname = 'PRICE'.
*  gs_fcat-emphasize = 'C610'.
  gs_fcat-col_opt = 'X'.                    "   GS_FIELD_CAT-NO_OUT = X =>  " 화면에서 안 보이게?? 필드 안 보이게 하는 거..
*  gs_fcat-edit = 'X'.                      " 필드를 수정하도록 속성을 정해준것,
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.                          " 지정한 structure에 있는 필드 외에도 internal table에 있는 필드 내용을 보고 싶다면 이렇게 선언하라.
  gs_fcat-fieldname = 'CHANGES_POSSIBLE'.
  gs_fcat-coltext = 'Chang.Poss'.
  gs_fcat-col_opt = 'X'.   "??? 이거 뭐임.
  gs_fcat-col_pos = 5.  " 필드가 자리할 위치.
  APPEND gs_fcat TO gt_fcat.

  CLEAR :gs_fcat.
  gs_fcat-fieldname = 'BNT_TEXT'.
  gs_fcat-coltext = 'Status'.
  gs_fcat-col_pos = 12.
  APPEND gs_fcat TO gt_fcat.

  CLEAR :gs_fcat.
  gs_fcat-fieldname = 'TANKCAP'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'TANKCAP'.
  gs_fcat-cfieldname = 'CAP_UNIT'.
  gs_fcat-col_pos = 12.
  APPEND gs_fcat TO gt_fcat.

  CLEAR :gs_fcat.
  gs_fcat-fieldname = 'CAP_UNIT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'CAP_UNIT'.
  gs_fcat-col_pos = 12.
  APPEND gs_fcat TO gt_fcat.

  CLEAR :gs_fcat.
  gs_fcat-fieldname = 'WEIGHT'.
  gs_fcat-ref_table = 'SAPLANE'.
  gs_fcat-ref_field = 'WEIGHT'.

  gs_fcat-qfieldname = 'CAP_UNIT'.
  gs_fcat-col_pos = 12.
  APPEND gs_fcat TO gt_fcat.

  CLEAR :gs_fcat.
  gs_fcat-fieldname = 'WEI_UNIT'.
  gs_fcat-ref_table = 'SAPLANE'.   " REF를 하면 해당 엘리먼트에 있는 정보들을 알아서 가져와준다.??
  gs_fcat-ref_field = 'WEI_UNIT'.
  gs_fcat-col_pos = 12.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'PLANETYPE'.
*  gs_fcat-emphasize = 'C610'.
*  gs_fcat-col_opt = 'X'.
  gs_fcat-edit = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR :gs_fcat.
  gs_fcat-fieldname = 'TO'.
  gs_fcat-coltext = 'Total Occupied'.
  gs_fcat-col_opt = 'X'.   "??? 이거 뭐임.
  gs_fcat-col_pos = 11.  " 필드가 자리할 위치.
  APPEND gs_fcat TO gt_fcat.


  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'SEATSMAX'.
  gs_fcat-edit = 'X'.
  APPEND gs_fcat TO gt_fcat.

    CLEAR : gs_fcat.
  gs_fcat-fieldname = 'SEATSOCC'.
  gs_fcat-edit = 'X'.
  APPEND gs_fcat TO gt_fcat.

*   TANKCAP TYPE SAPLANE-TANKCAP,
*        CAP_UNIT TYPE SAPLANE-CAP_UNIT ,
*        WEIGHT TYPE SAPLANE-WEIGHT,
*        WEI_UNIT




*  clear : gs_fcat.
*  gs_fcat-fieldname = 'PRICE'.
*
*  append gs_fcat to gt_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form customer_change_part
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM customer_change_part USING per_d_ch TYPE REF TO cl_alv_changed_data_protocol
                                ins_cells TYPE lvc_s_modi.

  DATA : l_ptype      TYPE sflight-planetype,
         l_seatsmax   TYPE sflight-seatsmax,
         l_seatsmax_b TYPE sflight-seatsmax_b,
         l_seatsmax_f TYPE  sflight-seatsmax_f.

  DATA : gt_temp TYPE TABLE OF SAPLANE,
         gs_temp TYPE SAPLANE.

  SELECT *
    FROM SAPLANE
    INTO CORRESPONDING FIELDS OF TABLE gt_temp.

  READ TABLE gt_FLT INTO gS_FLT INDEX ins_cells-row_id.

  CALL METHOD per_d_ch->get_cell_value
    EXPORTING
      i_row_id    = ins_cells-row_id
*     i_tabix     =
      i_fieldname = 'PLANETYPE'
    IMPORTING
      e_value     = l_ptype.

  IF l_ptype IS NOT INITIAL .
    READ TABLE gt_temp INTO gS_temp WITH KEY planetype = l_ptype.
    IF sy-subrc = 0.

      l_seatsmax = gS_temp-seatsmax.
      l_seatsmax_b = gS_temp-seatsmax_b.
      l_seatsmax_f =  gS_temp-seatsmax_f.

    ELSE.
      SELECT SINGLE seatsmax seatsmax_b seatsmax_f
        FROM SAPLANE
        INTO (l_seatsmax, l_seatsmax_b, l_seatsmax_f)
        WHERE planetype = l_ptype.

    ENDIF.
  ELSE.
    CLEAR : l_seatsmax, l_seatsmax_b, l_seatsmax_f.
  ENDIF.


  CALL METHOD per_d_ch->modify_cell
    EXPORTING
      i_row_id    = ins_cells-row_id
      i_fieldname = 'SEATSMAX'
      i_value     = l_seatsmax.

  CALL METHOD per_d_ch->modify_cell
    EXPORTING
      i_row_id    = ins_cells-row_id
      i_fieldname = 'SEATSMAX_B'
      i_value     = l_seatsmax_b.

  CALL METHOD per_d_ch->modify_cell
    EXPORTING
      i_row_id    = ins_cells-row_id
      i_fieldname = 'SEATSMAX_F'
      i_value     = l_seatsmax_f.



  gs_flt-seatsmax = l_seatsmax.
  gs_flt-seatsmax_b = l_seatsmax_b.
  gs_flt-seatsmax_f = l_seatsmax_f.




  MODIFY gt_flt FROM gs_flt INDEX ins_cells-row_id .




ENDFORM.
