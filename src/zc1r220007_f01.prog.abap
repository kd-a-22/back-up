*&---------------------------------------------------------------------*
*& Include          ZC1R220007_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_para
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_para .

  pa_buk = '1010'.
  pa_gja = sy-datum(4). " 현재년도 " 앞에 4자만 짤라온다.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_belnr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_belnr .

*_clear : gs_data gt_data.

  SELECT a~belnr  " bseg
         a~buzei
         b~blart       " bkpf-
         b~budat
         a~shkzg
         a~dmbtr
         b~waers
         a~hkont
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM bseg AS a INNER JOIN bkpf AS b
        ON a~bukrs = b~bukrs
       AND a~belnr = b~belnr
       AND a~gjahr = b~gjahr
     WHERE b~bukrs = pa_buk
       AND b~gjahr = pa_gja
       AND b~belnr IN so_belnr
       AND b~blart IN so_blart.

  IF sy-subrc NE 0.
    MESSAGE s001.
    LEAVE LIST-PROCESSING.
  ENDIF.





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
  gs_layout-sel_mode ='X'.
  gs_layout-cwidth_opt = 'X'.

  IF gs_fcat IS INITIAL.
    PERFORM set_fcat USING :
          'X'  'BELNR'  ' '   'BSEG'  'BELNR',
          'X'  'BUZEI'  ' '   'BSEG'  'BUZEI',
          ' '  'BLART'  ' '   'BKPF'  'BLART',
          ' '  'BUDAT'  ' '   'BKPF'  'BUDAT',
          ' '  'SHKZG'  ' '   'BSEG'  'SHKZG',
          ' '  'DMBTR'  ' '   'BSEG'  'DMBTR',
          ' '  'WAERS'  ' '   'BKPF'  'WAERS',
          ' '  'HKONT'  ' '   'BSEG'  'HKONT'.

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
FORM set_fcat  USING    pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat = VALUE #( key   = pv_key
                     fieldname = pv_field
                     coltext   = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field ).

  CASE pv_field.
    WHEN 'DMBTR'.
      gs_fcat-cfieldname = 'WAERS'.

    WHEN 'BELNR'.
      gs_fcat-hotspot = 'X'.
  ENDCASE.
  APPEND gs_fcat TO gt_fcat.



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

    gs_variant-report = sy-repid.
    IF GCL_HANDLER IS NOT BOUND.
      CREATE OBJECT GCL_HANDLER.
    ENDIF.

SET HANDLER GCL_HANDLER->handl_hotspot FOR GCL_GRID.

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
*& Form HANDL_HOTSPOT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> RE_ROW_ID
*&      --> E_COLUMN_ID
*&---------------------------------------------------------------------*
FORM handl_hotspot  USING    ps_row_id    TYPE lvc_s_row
                             ps_column_id TYPE lvc_s_col.

  READ TABLE GT_DATA INTO GS_DATA INDEX pS_row_id-inDEX.

  IF SY-SUBRC NE 0.
    EXIT.
  ENDIF.
CASE pS_column_id-FIELDNAME.
  WHEN 'BELNR'.
    IF GS_DATA-BELNR IS INITIAL.
      EXIT.
    ENDIF.
    SET PARAMETER ID : 'BLN' FIELD GS_DATA-BELNR,
                       'BUK' FIELD PA_BUK,
                       'GJR' FIELD pa_gja.


CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN..
ENDCASE.


ENDFORM.
