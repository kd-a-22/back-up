*&---------------------------------------------------------------------*
*& Include          ZBC405_A22_EXAM01_CLASS
*&---------------------------------------------------------------------*


CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS :    " class 가 붙었기 때문에 static method이다.
      on_toolbar FOR EVENT toolbar
        OF cl_gui_alv_grid
        IMPORTING e_object,
      on_user_command FOR EVENT user_command   " 다른 데 거의 이벤트를 여기서 매소드로 사용하는 것이다??
        OF cl_gui_alv_grid
        IMPORTING e_ucomm
        ,
      on_before_user_com FOR EVENT  before_user_command "버튼을 추가했고 위의 이벤트를 타게 한 것.
        OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      on_doubleclick FOR EVENT
        double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,
      on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,
          on_data_changed_finish FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified et_good_cells.


ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.

  METHOD on_data_changed_finish .

      DATA : ls_mod_cells TYPE lvc_s_modi.

    CHECK e_modified = 'X'.

    LOOP AT et_good_cells into ls_mod_cells.
      PERFORM modify_check USING ls_mod_cells.

    ENDLOOP.

  ENDMETHOD.



  METHOD on_data_changed.

    DATA : ls_mod_cells TYPE lvc_s_modi,
           ls_ins_cells TYPE lvc_s_moce,
           ls_del_cells TYPE lvc_s_moce.

    LOOP AT er_data_changed->mt_good_cells INTO ls_mod_cells.
      CASE ls_mod_cells-fieldname.
        WHEN 'FLTIME' OR 'DEPTIME'.
          PERFORM time_change USING er_data_changed ls_mod_cells.

      ENDCASE..

    ENDLOOP.



  ENDMETHOD.


  METHOD on_doubleclick.

    DATA : carrname TYPE scarr-carrname.

    CASE e_column-fieldname.
      WHEN 'CARRID' OR 'CONNID'.
        READ TABLE gt_flt INTO gs_flt INDEX e_row-index.
        SUBMIT bc405_event_s4 AND RETURN
        WITH so_car EQ gs_flt-carrid  " 조건
        WITH so_con EQ gs_flt-connid.


    ENDCASE.

  ENDMETHOD.



  METHOD on_before_user_com.

    CASE e_ucomm.
      WHEN 'SUBM'.
        CALL METHOD go_alv->set_user_command
          EXPORTING
            i_ucomm = 'SCHE'.
    ENDCASE.

  ENDMETHOD.


  METHOD on_user_command.

    DATA : lv_text TYPE c LENGTH 20.

*      DATA : lv_col_id TYPE lvc_s_col,  " Value type.  char 30잘
*            lv_row_id TYPE lvc_s_row.   " Value type. char 3자리ㅣ

    DATA : lv_col_id TYPE lvc_s_col,  " Structure type .. column id 읽어오는 듯
           lv_row_id TYPE lvc_s_row.
    DATA : lt_rows TYPE lvc_t_roid,
           ls_rows TYPE lvc_s_roid.


    CALL METHOD go_alv->get_current_cell  " 위치,, 내가 현재 클릭한 셀의 이름?? 등
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = lv_row_id
        es_col_id = lv_col_id
*       es_row_no =
      .

    CASE e_ucomm.
      WHEN 'AIRNAME'.

        IF lv_col_id-fieldname = 'CARRID'.
          READ TABLE gt_flt INTO gs_flt INDEX lv_row_id-index.
          IF sy-subrc = 0.
            CLEAR lv_text.
            SELECT SINGLE carrname INTO lv_text FROM scarr
              WHERE carrid = gs_flt-carrid.
            IF  sy-subrc = 0.
              MESSAGE i016(pn) WITH lv_text.
            ELSE.
              MESSAGE i016(pn) WITH '찾을 수 없습니다! '.

            ENDIF.
          ELSE.
            MESSAGE i016(pn) WITH '항공사를 선택하세요!'.
          ENDIF.
        ENDIF.


      WHEN 'SCHE'.

*        CALL METHOD go_alv->get_selected_rows
*          IMPORTING
**           et_index_rows =
*            et_row_no = lt_rows.

        READ TABLE gt_flt INTO gs_flt INDEX lv_row_id-index.
        IF sy-subrc = 0.
          SUBMIT bc405_event_d4 AND RETURN
              WITH s_car EQ gs_flt-carrid
              WITH s_con EQ gs_flt-connid.
        ELSE.
          MESSAGE i016(pn) WITH '잘못 된 정보입니다.'.

        ENDIF.



      WHEN 'CALL'.
        READ TABLE gt_flt INTO gs_flt INDEX lv_row_id-index.
        IF sy-subrc = 0.
          SET PARAMETER ID 'CAR' FIELD gs_flt-carrid.
          SET PARAMETER ID 'CON' FIELD gs_flt-connid.
          CALL TRANSACTION 'SAPBC410A_INPUT_FIEL'.
        ENDIF.

    ENDCASE.




  ENDMETHOD.




  METHOD on_toolbar.

    DATA : ls_button TYPE stb_button.
    ls_button-function    = 'AIRNAME'.
    ls_button-icon        = icon_ws_plane.
    ls_button-quickinfo   = 'air name'.
    ls_button-text        = 'flight'.
    ls_button-butn_type   = '0'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.   " mt_toolbar에 위리의 버튼을 추가하겠다.

    CLEAR ls_button.
    ls_button-function   = 'SUBM'.
    ls_button-quickinfo  = 'SUBMIT'.
    ls_button-text       = 'flightInfo'.
    ls_button-butn_type  = '0'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function    = 'CALL'.
    ls_button-quickinfo   = 'air name'.
    ls_button-text        = 'Flight Data'.
    ls_button-butn_type   = '0'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.


  ENDMETHOD.

ENDCLASS.
