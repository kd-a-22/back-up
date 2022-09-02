*&---------------------------------------------------------------------*
*& Report ZBC_405_OM_A22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc_405_om_a22.

TABLES : spfli.

SELECT-OPTIONS : so_car FOR spfli-carrid MEMORY ID car,
                 so_con FOR spfli-connid MEMORY ID con.

DATA: gt_spfli TYPE TABLE OF spfli,
      gs_spfli TYPE spfli.

DATA : go_alv     TYPE REF TO cl_salv_table,
       go_func    TYPE REF TO cl_salv_functions_list,
       go_disp    TYPE REF TO cl_salv_display_settings,
       go_columns TYPE REF TO cl_salv_columns_table,
       go_column  TYPE REF TO cl_salv_column_table,
       go_cols    TYPE REF TO cl_salv_column,
       go_layout  TYPE REF TO cl_salv_layout,  " ㅋ
       go_selc    TYPE REF TO cl_salv_selections.  " 셀 선택  "CALL METHOD GO_ALV->get_selections



START-OF-SELECTION.

  SELECT * FROM spfli
    INTO TABLE gt_spfli
    WHERE carrid IN so_car
    AND connid IN so_con.

**    factory 라는 클래스를 통해 우리가 만든 인터널 테이블을 얹어줄 것이다.? salv를 만들것이다?

  TRY.
      CALL METHOD cl_salv_table=>factory
*      EXPORTING
*        list_display   ='X'         "IF_SALV_C_BOOL_SAP=>FALSE " grid 화면을 List형태로 변환.
*        r_container    =
*        container_name =
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = gt_spfli.
    CATCH cx_salv_msg.  " 의도치 않은 덤프가 뜨는 것을 방지.
  ENDTRY.





  CALL METHOD go_alv->get_functions
    RECEIVING
      value = go_func.



  CALL METHOD go_func->set_sort_asc.

  CALL METHOD go_func->set_sort_desc.


*" ---- alv toolbar button 만들기
  CALL METHOD go_func->set_all.

*" ---- display setting
  CALL METHOD go_alv->get_display_settings  "  go_disp에 이 클래스를 따라 넣은 것인가??
    RECEIVING
      value = go_disp.

*" ----SALV title
  CALL METHOD go_disp->set_list_header   "
    EXPORTING
      value = 'SALV DEMO!!'.  " 반환될 것들을 value에 적는 거인 듯.

*" -----zebra pattern
  CALL METHOD go_disp->set_striped_pattern  " 지브라
    EXPORTING
      value = 'X'.

*" ----//Columns
  CALL METHOD go_alv->get_columns
    RECEIVING
      value = go_columns.

*" ----col_pot 기능과 같다.
  CALL METHOD go_columns->set_optimize  " 필드 넓이 맞추기
*  EXPORTING
*    value  = IF_SALV_C_BOOL_SAP~TRUE
    .

  TRY.  " 컬럼스 안에 컬럼을 찾기 위해 왔다?
      CALL METHOD go_columns->get_column  " 팔드 찾기..!
        EXPORTING
          columnname = 'MANDT'
        RECEIVING
          value      = go_cols.
    CATCH cx_salv_not_found.
  ENDTRY.
  go_column ?= go_cols.  " casting.. type 이 달라도 구문오류 없이 인정. 부모가 같으니 눈감아 달라.

  CALL METHOD go_column->set_technical. " 필드 숨기기.. 위에서 MANDT 찾아서 여기서 숨긴 거다.


*  " 0808. 월   1) FLTIME 필드 찾기
  TRY.  " 컬럼스 안에 컬럼을 찾기 위해 왔다?
      CALL METHOD go_columns->get_column  " 팔드 찾기..!
        EXPORTING
          columnname = 'FLTIME'
        RECEIVING
          value      = go_cols.
    CATCH cx_salv_not_found.
  ENDTRY.
  go_column ?= go_cols.

  DATA : g_color TYPE lvc_s_colo.


  g_color-col = '5'.
  g_color-int = ''.
  g_color-inv = '0'.

***2)찾은 FLTIME 필드에 색 입히기.
  CALL METHOD go_column->set_color
    EXPORTING
      value = g_color.

  CALL METHOD go_alv->get_layout
    RECEIVING
      value = go_layout.

*" VARIANT 주는 거인 듯.
  DATA : g_program TYPE salv_s_layout_key.
  g_program-report = sy-cprog.

  CALL METHOD go_layout->set_key
    EXPORTING
      value = g_program.

  CALL METHOD go_layout->set_save_restriction   " 주석처리 하면 저장할 수 있는 아이콘 사라짐.. 선택만 가능하고 저장만 가능해짐.. 얘가 저장 가능하게 해줌.
    EXPORTING
      value = if_salv_c_layout=>restrict_none.

  CALL METHOD go_layout->set_default
    EXPORTING
      value = 'X'.

* " CELL SELECT 셀 선택.

  CALL METHOD go_alv->get_selections
    RECEIVING
      value = go_selc.

  CALL METHOD go_selc->set_selection_mode
    EXPORTING
      value = if_salv_c_selection_mode=>row_column.

    CALL METHOD go_selc->set_selection_mode
    EXPORTING
      value = if_salv_c_selection_mode=>cELL.




  " 화면 뿌리기
  CALL METHOD go_alv->display. " instance method
  "   우리가 만든 인스턴스->메소드
