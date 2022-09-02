*&---------------------------------------------------------------------*
*& Include          ZBC405_ALV_CL1_A22_CLASS
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS : on_doubleclick FOR EVENT
      double_click OF cl_gui_alv_grid
      IMPORTING e_row e_column es_row_no,
      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object,
      on_usercommad FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      on_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,
      on_data_changed_finish FOR EVENT data_changed_finished OF cl_gui_alv_grid
        IMPORTING e_modified et_good_cells.


ENDCLASS.


CLASS lcl_handler IMPLEMENTATION .

  METHOD on_data_changed_finish .  " et_goods_cell에 있는 것만 똑 떼어 준다.
     DATA : ls_mod_cells TYPE lvc_s_modi.

    CHECK e_modified = 'X'.  "필드가 수정 중 일 때 이 필드는 x가 된다.  ." check -> 얘가 참일 때 다음 로직을 타라. 만약 거짓이라면 이 메소드를 빠져나가라.. 이게 check로직.

    LOOP AT et_good_cells into ls_mod_cells.
      PERFORM modify_check USING ls_mod_cells.  " 클래스 안에서 모디파이 하면 워닝 뜬다. 그래서 퍼폼 안에서 한다... ++아님... 모디파이에서 인덱스 안 써줘서 그럼

    ENDLOOP.

  ENDMETHOD.


  METHOD on_data_changed.  " et_goods_cell외에 여러가지 정보를 전부다 준다.
    FIELD-SYMBOLS : <fs> LIKE gt_sbook.
    DATA : ls_mod_cells TYPE lvc_s_modi,
           ls_ins_cells TYPE lvc_s_moce,
           ls_del_cells TYPE lvc_s_moce.

    LOOP AT er_data_changed->mt_good_cells INTO ls_mod_cells. "er_data_changed->mt_good_cells = table type이다??
      CASE ls_mod_cells-fieldname.
        WHEN 'CUSTOMID'.
          PERFORM customer_change_part USING er_data_changed
                                             ls_mod_cells.

        WHEN 'CANCELLED'.
      ENDCASE.
    ENDLOOP.

    IF er_data_changed->mt_inserted_rows IS NOT INITIAL.
      ASSIGN er_data_changed->mp_mod_rows->* TO <fs>.  " 새롭게 추가한 셀이 MP어쩌구에 들어가고 그거를 FS에 넣은 것이다.
      IF sy-subrc EQ 0.
        APPEND LINES OF <fs> TO gt_sbook.  " 빈 공간이 fs에 들어간다.
        LOOP AT er_data_changed->mt_inserted_rows INTO ls_ins_cells.

          READ TABLE gt_sbook INTO gs_sbook INDEX ls_ins_cells-row_id.
          IF sy-subrc EQ 0.
*
            PERFORM insert_parts USING er_data_changed
                                          ls_ins_cells.

          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

*-- delete parts

    IF  er_data_changed->mt_deleted_rows IS NOT INITIAL.

      LOOP AT er_data_changed->mt_deleted_rows INTO ls_del_cells.

        READ TABLE gt_sbook INTO gs_sbook INDEX ls_del_cells-row_id.
        IF sy-subrc EQ 0.
          MOVE-CORRESPONDING gs_sbook to dw_sbook.
          APPEND dw_sbook TO dl_sbook.
        ENDIF.
      ENDLOOP.


    ENDIF.

  ENDMETHOD.

  METHOD on_usercommad .
    DATA : ls_col  TYPE lvc_s_col,
           ls_roid TYPE lvc_s_roid.

    CALL METHOD go_alv->get_current_cell
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
*       es_row_id =
        es_col_id = ls_col
        es_row_no = ls_roid.


    CASE e_ucomm.
      WHEN 'GOTOFL'.
        READ TABLE gt_sbook INTO gs_sbook INDEX ls_roid-row_id.
        IF  sy-subrc EQ 0.
          SET PARAMETER ID 'CAR' FIELD gs_sbook-carrid.
          SET PARAMETER ID 'CON' FIELD gs_sbook-connid.
          CALL TRANSACTION 'SAPBC405CAL'.


        ENDIF.

    ENDCASE.

  ENDMETHOD.

  METHOD on_toolbar.
    DATA : wa_button TYPE stb_button.
    wa_button-butn_type = 3 .    " 선 하나 만들기 seperator . 0 이 노말 버튼
    INSERT wa_button INTO TABLE e_object->mt_toolbar.

    CLEAR : wa_button.
    wa_button-butn_type = '0'.     " 노말버튼 만들기 normal button
    wa_button-function = 'GOTOFL'. " FLIGHT CONNECTION.
    wa_button-icon = icon_flight.
    wa_button-quickinfo = 'Go to flight cinnection'.
    wa_button-text = 'Filght'.  "아이콘에 글씨 쓰는 것.
    INSERT wa_button INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.

  METHOD on_doubleclick.
    DATA : carrname TYPE scarr-carrname.


    CASE e_column-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_sbook INTO gs_sbook
        INDEX e_row-index.
        IF sy-subrc EQ 0.
          SELECT SINGLE carrname INTO carrname
            FROM scarr WHERE carrid = gs_sbook-carrid.
          IF sy-subrc EQ 0.
            MESSAGE i000(zt03_msg) WITH carrname.

          ENDIF.

        ENDIF.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
