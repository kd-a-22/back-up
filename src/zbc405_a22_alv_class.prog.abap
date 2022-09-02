*&---------------------------------------------------------------------*
*& Include          ZBC405_A22_ALV_CLASS
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION.   " 정의부.. 선언하는 곳.. static이 있고 어저구가 있는데 우리는 static상ㅅㅇ
  PUBLIC SECTION.
    CLASS-METHODS : on_doubleclick FOR EVENT double_click
      OF cl_gui_alv_grid
      IMPORTING e_row e_column es_row_no,  " 던져줄 결과값.

      on_hotspot FOR EVENT hotspot_click   " method call  " 가능에 모양도 바뀌어야 하기 때문에 field 카탈로그의 도움이 필요하다..
        OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no,
      on_toolbar FOR EVENT toolbar
        OF cl_gui_alv_grid
        IMPORTING e_object,
      on_user_command FOR EVENT user_command
        OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      on_button_click FOR EVENT button_click
        OF cl_gui_alv_grid
        IMPORTING es_col_id es_row_no,

      on_context_menu_request FOR EVENT context_menu_request
        OF cl_gui_alv_grid
        IMPORTING e_object,
          on_before_user_com for event  before_user_command "버튼을 추가했고 위의 이벤트를 타게 한 것.
          of cl_gui_alv_grid
          IMPORTING e_ucomm.

ENDCLASS.

CLASS lcl_handler IMPLEMENTATION. " 구현부

METHOD on_before_user_com.

  CASE e_ucomm.
    WHEN go_alv_grid->mc_fc_detail.
      call METHOD go_alv_grid->set_user_command
       EXPORTING
         i_ucomm = 'SCHE'.

  ENDCASE.

  endmethod.


  METHOD on_context_menu_request.
    " 메뉴도 우리가 S100으로 만들었던 status와 같은 것. 메뉴를 만드는 법 두가지..
    " 1)스크린에프로그램에 있는 메뉴(s100 status)를 데려오거나 2)메소드를 통해 메뉴를 붙이거나 +)둘다 쓰거나
    " 바로 이름이 뜨는 것은 static method 이다.
*    CALL METHOD cl_ctmenu=>load_gui_status    " context menu 를 불러오는 메소드.
*      EXPORTING
*        program    = sy-cprog
*        status     = 'CT_MENU'
**       disable    =    " X 하면 그레이 상태가 된다??
*        menu       = e_object
*      EXCEPTIONS
*        read_error = 1
*        OTHERS     = 2.
*    IF sy-subrc <> 0.
**   Implement suitable error handling here
* ENDIF.
*

    DATA :lv_col_id TYPE lvc_s_col,
          lv_row_id TYPE lvc_s_row.

     CALL METHOD go_alv_grid->get_current_cell
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = lv_row_id
        es_col_id = lv_col_id.
    IF lv_col_id-fieldname = 'CARRID'.



    CALL METHOD e_object->add_separator.

    CALL METHOD e_object->add_function
      EXPORTING
        fcode = 'DIS_CARR'
        text  = 'Dispaly Ariline'
*       icon  =
*       ftype =
*       disabled          =
*       hidden            =
*       checked           =
*       accelerator       =
*       insert_at_the_top = SPACE
      .
 ENDIF.


  ENDMETHOD.


  METHOD on_button_click.
    READ TABLE gt_flt INTO gs_flt
    INDEX es_row_no-row_id.
    IF ( gs_flt-seatsmax  NE gs_flt-seatsocc ) OR
      ( gs_flt-seatsmax_f NE gs_flt-seatsocc_f ).
      MESSAGE i000(zt03_msg) WITH '다른 등급의 좌석을 선택하세요.'.
    ELSE.
      MESSAGE i000(zt03_msg) WITH '모든 좌석이 에약된 상태입니다.'.
    ENDIF.


  ENDMETHOD.


  METHOD on_user_command.
    DATA : lv_occp     TYPE i,
           lv_capa     TYPE i,
           lv_perct    TYPE p LENGTH 8 DECIMALS 1,
           lv_text(20).

    DATA : lt_rows TYPE lvc_t_roid,
           ls_rows TYPE lvc_s_roid.

    DATA : lv_col_id TYPE lvc_s_col,
           lv_row_id TYPE lvc_s_row.

    CLEAR : lv_text.

    CALL METHOD go_alv_grid->get_current_cell
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = lv_row_id
        es_col_id = lv_col_id.



    CASE e_ucomm.
      WHEN 'SCHE'.  " goto glight schedule report.
        READ TABLE gt_flt into gs_flt INDEX lv_row_id-index.
        IF sy-subrc eq 0.
          SUBMIT bc405_event_d4 AND RETURN    " 조건을 확인하고 돌아와라.  submit = 다른 프로그램과 연결 다른프로그램으로 간다?? 지정된 프로그램을 불러오라.
*           via SELECTION-SCREEN.. 서브밋한 프로그램의 셀렉션 스크린으로 이동하는 듯
               with so_car eq gs_flt-carrid  " 조건
               WITH so_con eq gs_flt-connid.

" 그냥 서브밋만 쓰고 andrturn을 안 쓰면 돌아오지 않는다. back누르면 그냥 끝난다. 내 프로그램의 alv화면으로 돌아오지 않는다.
" 조건으로 with을 주지 않으면 서브밋은 셀렉션스크린을 타지 않고 바로 프로그램을 로드한다?
 "   그냥 이거만 덜렁 쓰네.. 뭐지. --> via selectio-screen .

        ENDIF.
      WHEN 'DISP_CARR'.
        IF lv_col_id-fieldname = 'CARRID'.
          READ TABLE gt_flt INTO gs_flt INDEX lv_row_id-index.
          IF sy-subrc EQ 0.
            CLEAR : lv_text.
            SELECT SINGLE carrname INTO lv_text FROM scarr
                     WHERE carrid = gs_flt-carrid.
            IF sy-subrc EQ 0.
              MESSAGE i000(zt03_msg) WITH lv_text.
            ELSE.
              MESSAGE i000(zt03_msg) WITH 'No found!'.
            ENDIF.

          ELSE.
            MESSAGE i000(zt03_msg) WITH '항공사를 선택하세요'.
            EXIT.
          ENDIF.
        ENDIF.




      WHEN 'PERCENTAGE'.
        LOOP AT  gt_flt INTO gs_flt.
          lv_occp = lv_occp + gs_flt-seatsocc.
          lv_capa = lv_capa + gs_flt-seatsmax.
        ENDLOOP.
        lv_perct = lv_occp / lv_capa * 100.
        lv_text = lv_perct.
        CONDENSE lv_text.

        MESSAGE i000(zt03_msg) WITH 'percentage of occupied seat :' lv_text '%'.

      WHEN 'PERCENTAGE_MARKED'.

        CALL METHOD go_alv_grid->get_selected_rows
          IMPORTING
*           et_index_rows =
            et_row_no = lt_rows.
        IF lines( lt_rows ) > 0.
          LOOP AT lt_rows INTO ls_rows.

            READ TABLE gt_flt INTO gs_flt INDEX ls_rows-row_id.
            IF sy-subrc EQ 0.
              lv_occp = lv_occp + gs_flt-seatsocc.
              lv_capa = lv_capa + gs_flt-seatsmax.

            ENDIF.

          ENDLOOP.
          lv_perct = lv_occp / lv_capa * 100.
          lv_text = lv_perct.
          CONDENSE lv_text.

          MESSAGE i000(zt03_msg) WITH 'percentage of Marked occupied occupied seat :' lv_text '%'.
        ELSE.
          MESSAGE i000(zt03_msg) WITH 'Please select at least one line!'.
        ENDIF.
    ENDCASE.
  ENDMETHOD.


  METHOD on_toolbar.



    DATA: ls_button TYPE stb_button.
    ls_button-function = 'DISP_CARR'.
    ls_button-icon = icon_ws_plane.
    ls_button-quickinfo = 'ARILINE NAME'.
    ls_button-butn_type = '0'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.   " 버튼을 만들어서 mt toovar에 넣어주라? mttoobar가 툴바를 가지고 있다. 버튼을 정의하는 table type.

    ls_button-butn_type = '3'.
    ls_button-text = 'Marked Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.
    CLEAR ls_button.

    ls_button-function = 'PERCENTAGE'.
*    LS_BUTTON-ICON = ?
    ls_button-quickinfo = 'PERCENTAGE'.
    ls_button-butn_type = '0'.
    ls_button-text = 'Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.  " 얘가 한 번 insert 될 때마다 버튼이 하나 생긴다.
    CLEAR ls_button.

    ls_button-butn_type = '3'.
    ls_button-text = 'Marked Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    ls_button-function = 'PERCENTAGE_MARKED'.
*    LS_BUTTON-ICON = ?
    ls_button-quickinfo = 'MARKED PERCENTAGE'.
    ls_button-butn_type = '0'.
    ls_button-text = 'Marked Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.
    CLEAR ls_button.



  ENDMETHOD.


  METHOD on_hotspot.



    DATA : carr_name TYPE scarr-carrname.
    CASE e_column_id-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.
        IF sy-subrc EQ 0.
          SELECT SINGLE carrname INTO carr_name FROM scarr WHERE carrid = gs_flt-carrid.
          IF sy-subrc EQ 0.
            MESSAGE i000(zt03_msg) WITH carr_name.
          ELSE.
            MESSAGE i000(zt03_msg) WITH 'NO FOUND!'.
          ENDIF.
        ELSE.
          MESSAGE i065(bc405_408).
          EXIT.
        ENDIF.



    ENDCASE.
  ENDMETHOD.




  METHOD on_doubleclick.
    DATA : total_occ TYPE i.
    DATA : total_occ_c TYPE c LENGTH 10.

    CASE e_column-fieldname.
      WHEN 'CHANGES_POSSIBLE'.
        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.
        IF sy-subrc EQ 0.
          total_occ = gs_flt-seatsocc +
                      gs_flt-seatsocc_b +
                      gs_flt-seatsocc_f.

          total_occ_c = total_occ.
          CONDENSE total_occ_c.
          MESSAGE i000(zt03_msg) WITH 'Total number of bookings:'
                                      total_occ_c.

        ELSE.
          MESSAGE i065(bc405_408).
          EXIT.
        ENDIF.

    ENDCASE.


  ENDMETHOD.

ENDCLASS.
