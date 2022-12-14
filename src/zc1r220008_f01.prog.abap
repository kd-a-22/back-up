*&---------------------------------------------------------------------*
*& Include          ZC1R220008_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_EMP_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_emp_data .

  SELECT  pernr
          ename
          entdt
          gender
          depid
    carrid
  FROM ztsa2201
   INTO CORRESPONDING FIELDS OF TABLE gt_data
    WHERE pernr IN so_pernr.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout .

  gs_layout-zebra = 'X'.
  gs_layout-sel_mode = 'X'.
*  gs_layout-cwidth_opt = 'X'.
  gs_layout-stylefname = 'STYLE'.


  IF gt_fcat IS INITIAL.


    PERFORM set_fcat USING :
         'X'  'PERNR '  ' '  'ZTSA2201'  'PERNR '  'X'  10,
         ' '  'ENAME '  ' '  'ZTSA2201'  'ENAME '  'X'   20,
         ' '  'ENTDT '  ' '  'ZTSA2201'  'ENTDT '  'X'   10,
         ' '  'GENDER'  ' '  'ZTSA2201'  'GENDER'  'X'   5,
         ' '  'DEPID'   ' '  'ZTSA2201'  'DEPID'   'X'   8,
         ' '  'CARRID'   ' '  'ZTSA2201' 'CARRID'   'X'   10,
         ' '  'CARRNAME'   ' '  'SCARR'  'CARRNAME'   ''   20.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING   pv_key pv_field pv_text pv_r_table pv_r_field pv_edit pv_length.

  gt_fcat = VALUE #( BASE gt_fcat (
                         key = pv_key
                         fieldname = pv_field
                         coltext = pv_text
                         ref_table = pv_r_table
                         ref_field = pv_r_field
                         edit      = pv_edit
                         outputlen = pv_length ) ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen .

  IF gcl_container IS NOT BOUND.

    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    SET HANDLER : lcl_event_handler=>handle_data_changed FOR gcl_grid,
                  lcl_event_handler=>handle_change_finished FOR gcl_grid.



    CALL METHOD gcl_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.



    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ROW
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_row .

  CLEAR gs_data.
  APPEND gs_data TO gt_data.

  PERFORM refresh_grid.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_grid .

  gs_stable-row = 'X'.
  gs_stable-col = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = space.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_emp .

  " alv????????? ?????? ???????????? internal table??? ??????
  DATA : lt_save  TYPE TABLE OF ztsa2201,
         lt_del   TYPE TABLE OF ztsa2201,
         lv_cnt   TYPE i,
         lv_error.

  REFRESH lt_save.

  CALL METHOD gcl_grid->check_changed_data. " ALV??? ????????? ?????? ITAB?????? ????????????
  CLEAR : lv_error.      " ?????? ????????? ?????? ?????? ??????

  LOOP AT gt_data INTO gs_data.
    IF  gs_data-pernr IS INITIAL.  " ?????? ???????????? ??????????????????
      MESSAGE s000 WITH 'Emplyee Number is required' DISPLAY LIKE 'E'.
      lv_error = 'X'.  " ???????????? ?????? ?????? ?????? ????????? ?????? ?????? ????????? ?????? ??????
      EXIT.            " ?????? ???????????? ????????? ?????? ?????? : ????????? LOOP??? ?????? ??????
    ENDIF.

    lt_save = VALUE #( BASE lt_save   " ?????? ?????? ???????????? ????????? ITAB??? ????????? ??????.
                      (
                       pernr = gs_data-pernr
                       ename = gs_data-ename
                       entdt = gs_data-entdt
                       gender = gs_data-gender
                       depid = gs_data-depid
                       )
                     ).

  ENDLOOP.

  " CHECK lv_error IS INITAIL   " ?????? ???????????? ?????? ?????? ??????
  IF lv_error IS NOT INITIAL. " ????????? ???????????? ?????? ????????? ????????????.
    EXIT.
  ENDIF.

  IF gt_data_del IS NOT INITIAL.
    LOOP AT gt_data_del INTO DATA(ls_del).
      lt_del = VALUE #( BASE lt_del
                     ( pernr = ls_del-pernr ) ).
    ENDLOOP.
    DELETE ztsa2201 FROM TABLE lt_del.
    IF sy-dbcnt > 0 .
*      COMMIT WORK AND WAIT .
      lv_cnt = lv_cnt + sy-dbcnt.
    ENDIF.
  ENDIF.

  IF lt_save IS NOT INITIAL.
    MODIFY ztsa2201 FROM TABLE lt_save.  " MODITY ????????? DB Table??? ??? ??? ??????. ????????? ???????????? ?????????????????? FROM ??? ?????? STRUCTURE??? ??????,
    IF sy-dbcnt > 0.
*      COMMIT WORK AND WAIT.
      lv_cnt += sy-dbcnt .  " =     lv_cnt = lv_cnt + sy-dbcnt. ?????? ??????
      MESSAGE s002. " ????????? ?????? ?????? ?????????
    ENDIF.
  ENDIF.

  IF lv_cnt > 0.
    COMMIT WORK AND WAIT.
    MESSAGE s001.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_ROW
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_row .

  REFRESH  gt_rows.

  CALL METHOD gcl_grid->get_selected_rows  " ???????????? ????????? ?????? ?????? ?????????.
    IMPORTING
      et_index_rows = gt_rows.

  IF gt_rows IS INITIAL.  " ?????? ??????????????? ??????
    MESSAGE s000 WITH TEXT-t01 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  LOOP AT gt_rows INTO gs_row.
    READ TABLE gt_data INTO gs_data INDEX gs_row-index .
    IF sy-subrc = 0.
      gs_data-mark = 'X'.
      MODIFY gt_data FROM gs_data INDEX gs_row-index
      TRANSPORTING mark.
    ENDIF.
  ENDLOOP.

  " DELETE GT_DATA WHERE mark ='X'.         " 1). ????????? ?????? ???????????? ??????. top?????? mark ?????? ??????.
*  DELETE gt_data WHERE mark IS NOT INITIAL.
*    ENDLOOP.


  " itab?????? ???????????? ?????? DB TABLE????????? ????????? ????????? ??????????????? ?????? ??????




  SORT gt_rows BY index DESCENDING.   " ??????.  " 2) ????????? ?????? ???????????? ??????. sort ??????.. ?????? ??????????????? ??? ??????.

  LOOP AT gt_data INTO gs_data.


    READ TABLE gt_data INTO gs_data INDEX gs_row-index. "  "  ????????? ?????? ?????? ??????
    IF sy-subrc = 0.
      APPEND gs_data TO gt_data_del.
    ENDIF.
    DELETE gt_data INDEX gs_row-index.
  ENDLOOP.

  PERFORM refresh_grid.  " ????????? itab??? alv??? ??????.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_style
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_style .

  DATA : lv_tabix TYPE sy-tabix,
         ls_style TYPE lvc_s_styl.



*  ls_style-fieldname = 'PERNR'.   " ?????????
*  ls_style-style     = CL_GUI_ALV_GRID=>mc_style_disabled.
*
  ls_style = VALUE #( fieldname = 'PERNR'
                      style    = cl_gui_alv_grid=>mc_style_disabled ).

  " Table?????? ????????? ??? ???????????? PK??? ?????? ?????? ????????? ?????????????????????
  LOOP AT gt_data INTO gs_data.
    lv_tabix = sy-tabix.

    REFRESH gs_data-style.

    APPEND ls_style TO gs_data-style.

    MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING style.

  ENDLOOP.






ENDFORM.

FORM set_style_table .

  DATA : lv_tabix TYPE sy-tabix,
         ls_style TYPE lvc_s_styl,
         lt_style TYPE lvc_t_styl.


  " 1. ?????????
*  ls_style-fieldname = 'PERNR'.   " ?????????
*  ls_style-style     = CL_GUI_ALV_GRID=>mc_style_disabled.
*  APPEND ls_style  TO lt_style.

  " 2. ?????????????????? ????????? ?????????
*  ls_style = VALUE #( fiedname = 'PERMR'
*                      style    = cl_gui_alv_grid=>mc_style_disabled ).
*  APPEND ls_style TO lt_stype.

  " 3. ????????? ???????????? ????????? ?????????.
  lt_style = VALUE #(
                  (
                   fieldname = 'PERNR'
                   style    = cl_gui_alv_grid=>mc_style_disabled
                   ) ).

  " Table?????? ????????? ??? ???????????? PK??? ?????? ?????? ????????? ?????????????????????
  LOOP AT gt_data INTO gs_data.
    lv_tabix = sy-tabix.

    REFRESH gs_data-style.

    APPEND LINES OF lt_style TO gs_data-style.
*    gs_emp-style = lt_style.
*    MOVE-CORRESPONDING lt_style TO gs_emp-style.

    MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING style.
  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DATA_CHANGED
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&---------------------------------------------------------------------*
FORM handle_data_changed  USING    pcl_data_changed TYPE REF TO
                                   cl_alv_changed_data_protocol.

  LOOP AT pcl_data_changed->mt_mod_cells INTO DATA(ls_modi).
    " LS_MODI??? NEW VALUE??? ????????? ??????.
    READ TABLE gt_data INTO gs_data INDEX ls_modi-row_id.

*    IF sy-subrc <> 0.
*      CONTINUE.
*    ENDIF.
*
*    SELECT SINGLE carrname
*      INTO gs_data-carrname
*      FROM scarr
*      WHERE carrid = Ls_modi-value.  " NEW VALUE
*
*    IF sy-subrc NE 0.
*      CLEAR gs_data-carrname.
*    ENDIF.
*    MODIFY gt_data FROM gs_data INDEX ls_modi-row_id
*         TRANSPORTING carrname.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_CHANGE_FINISHED
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_MODIFIED
*&      --> ET_GOOD_CELLS
*&---------------------------------------------------------------------*
FORM handle_change_finished  USING    pv_modified
                                      pv_good_cells TYPE lvc_t_modi.

*  DATA : LS_MODI TYPE LVC_T_MODI " ????????????????????? ?????? ???????????? ???. ????????? ?????? ????????? ??????????????? ????????? ??????.
  LOOP AT pv_good_cells INTO DATA(ls_modi).


    READ TABLE gt_data INTO gs_data INDEX ls_modi-row_id.
    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

    SELECT SINGLE carrname
      INTO gs_data-carrname
      FROM scarr
      WHERE carrid = gs_data-carrid.  " NEW VALUE

    IF sy-subrc NE 0.
      CLEAR gs_data-carrname.
    ENDIF.
    MODIFY gt_data FROM gs_data INDEX ls_modi-row_id
         TRANSPORTING carrname.
*
*


  ENDLOOP.
  PERFORM refresh_grid.
ENDFORM.
