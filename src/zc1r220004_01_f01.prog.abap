*&---------------------------------------------------------------------*
*& Include          ZC1R220004_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
*  SELECT
*     a~matnr  " MAST
*     b~maktx  " MAKT
*     a~stlan
*     a~stlnr
*     a~stlal
*     c~mtart  " MARA
*     c~matkl
*  FROM mast AS a INNER JOIN makt AS b
*                  ON a~matnr = b~matnr
*                  INNER JOIN mara AS c
*                  ON b~matnr = c~matnr
*    INTO CORRESPONDING FIELDS OF TABLE gt_data
*    WHERE b~spras = sy-langu
*    AND a~werks = pa_wer
*    AND a~matnr IN so_mat.

  CLEAR gs_data.
  _clear gt_data.

  SELECT a~matnr  " MAST
         a~stlan
         a~stlnr
         a~stlal
         b~mtart  " MARA
         b~matkl
*         c~maktx  " MAKT
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM mast AS a
    INNER JOIN mara AS b
    ON a~matnr = b~matnr
*    LEFT OUTER JOIN makt AS c
*    ON a~matnr = c~matnr
*    AND c~spras = sy-langu
    WHERE a~werks = pa_wer
    AND  a~matnr IN so_mat.




  IF  sy-subrc <> 0.
    MESSAGE i000 WITH '데이터가 없습니다.'.
    LEAVE LIST-PROCESSING.
  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_SCREEN
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



*    SET HANDLER lcl_handler=>on_doubleclick FOR gcl_grid.
    IF gcl_handler IS NOT BOUND.    " 어디에서 만들어질 지 모른다. 그래서 한 번 만들어 뎠으면 다시 만들어 지지 않도록 해 주어야 한다.
      CREATE OBJECT gcl_handler.
    ENDIF.

    SET HANDLER gcl_handler->handle_double_click FOR gcl_grid.
    SET HANDLER gcl_handler->handle_hotspot      FOR gcl_grid.



    gs_variant-report = sy-repid.



    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
*       is_variant      =
*       i_save          =
*       i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_LAYOUT_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout_fcat .

  gs_layout-zebra      = 'X'.
  gs_layout-sel_mode   = 'D'.
  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING :
        'X' 'MATNR' ' ' 'MAST' 'MATNR' ' ',
        ' ' 'MAKTX' ' ' 'MAKT' 'MAKTX' ' ',
        ' ' 'STLAN' ' ' 'MAST' 'STLAN' ' ',
        ' ' 'STLNR' ' ' 'MAST' 'STLNR' ' ',
        ' ' 'STLAL' ' ' 'MAST' 'STLAL' ' ',
        ' ' 'MTART' ' ' 'MARA' 'MTART' ' ',
        ' ' 'MATKL' ' ' 'MARA' 'MATKL' ' '.
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
FORM set_fcat  USING pv_key pv_field pv_text pv_ref_table pv_ref_field pv_click.

  gs_fcat-key       = pv_key.
  gs_fcat-fieldname = pv_field.
  gs_fcat-coltext   = pv_text.
  gs_fcat-ref_table = pv_ref_table.
  gs_fcat-ref_field = pv_ref_field.

  CASE pv_field.
    WHEN 'STLNR'.
      gs_fcat-hotspot = 'X'.
  ENDCASE.

  APPEND gs_fcat TO gt_fcat.
  CLEAR  gs_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ON_DOUBLECLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM on_doubleclick USING pv_col TYPE lvc_s_col.

  DATA : lv_col_id TYPE lvc_s_col,  " Structure type .. column id 읽어오는 듯
         lv_row_id TYPE lvc_s_row.

  CALL METHOD gcl_grid->get_current_cell  " 위치,, 내가 현재 클릭한 셀의 이름?? 등
    IMPORTING
      es_row_id = lv_row_id
      es_col_id = lv_col_id.



  CASE pv_col-fieldname.
    WHEN 'MATNR'.
      READ TABLE gt_data INTO gs_data
      INDEX lv_row_id-index.                                 "ls_roid-row_id.
      IF sy-subrc = 0.
        SET PARAMETER ID 'MAT' FIELD gs_data-matnr.
        SET PARAMETER ID 'WRK' FIELD pa_wer.
        SET PARAMETER ID 'CSV' FIELD gs_data-stlan.
        CALL TRANSACTION 'CS03'.

      ENDIF.

  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form init
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init .

  pa_wer = '1010'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_COLUMN
*&---------------------------------------------------------------------*
FORM handle_double_click  USING ps_row TYPE lvc_s_row
                                ps_column TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX ps_row-index.

  IF sy-subrc <> 0.
    EXIT.
  ENDIF .

  CASE ps_column-fieldname.
    WHEN 'MATNR'.
      IF gs_data-matnr IS INITIAL.
        EXIT.
      ENDIF.
      SET PARAMETER ID : 'MAT' FIELD gs_data-matnr.

      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.

  ENDCASE.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_HOTSPOT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&---------------------------------------------------------------------*
FORM handle_hotspot  USING    ps_row_id    TYPE lvc_s_row
                              ps_column_id TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX ps_row_id-index.

  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

  CASE ps_column_id-fieldname.
    WHEN 'STLNR'.
      IF gs_data-stlnr IS INITIAL .
        EXIT.
      ENDIF.

      SET PARAMETER ID 'MAT' FIELD gs_data-matnr.
      SET PARAMETER ID 'WRK' FIELD pa_wer.
      SET PARAMETER ID 'CSV' FIELD gs_data-stlan.
      CALL TRANSACTION 'CS03' AND SKIP FIRST SCREEN.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_maktx
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_maktx .

  data : lv_tabix type sy-tabix,
         lV_maktx type makt-maktx,
         lv_code,
         lv_msg(100).

   IF gcl_maktx IS NOT BOUND.
  CREATE OBJECT gcl_maktx.
ENDIF.

LOOP AT gt_data into gs_data .
  lv_tabix = SY-TABIX.

  CLEAR : LV_MAKTX, LV_CODE, LV_MSG.

  CALL METHOD gcl_maktx->set_material_description
    EXPORTING
      pi_matnr = GS_DATA-MATNR
    IMPORTING
      pe_code  = LV_CODE
      pe_msg   = LV_MSG
      ev_maktx = LV_MAKTX
      .
  IF LV_CODE = 'S'.
    GS_DATA-MAKTX = LV_MAKTX.
   MODIFY GT_DATA FROM GS_DATA INDEX lv_tabix
   TRANSPORTING MAKTX.
  ENDIF.

ENDLOOP.









ENDFORM.
