*&---------------------------------------------------------------------*
*& Include          SAPMZC1220001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f4_werks
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_werks .

  SELECT werks, name1, ekorg, land1
    INTO TABLE @DATA(lt_werks)
    FROM t001w.

  IF sy-subrc NE 0.
    MESSAGE s001.
    EXIT.
  ENDIF.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'werks'
      dynpprog     = sy-repid
      dynpnr       = sy-dynnr
      dynprofield  = 'gs_data-werks'
      window_title = TEXT-t01
      value_org    = 'S'
    TABLES
      value_tab    = lt_werks.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  REFRESH gt_data.
  SELECT matnr werks mtart matkl menge meins
    dmbtr waers
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM ztsa2203.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout .

  gs_layout-zebra = 'X'.
  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode = 'X'.

  IF gt_fcat IS INITIAL .
    PERFORM set_fcat USING :
          'X'  'MATNR'  ' '  'ZTSA2203'  'MATNR'   ' '      ' ' ,
          'X'  'WERKS'  ' '  'ZTSA2203'  'WERKS'   ' '      ' ' ,
          ' '  'MTART'  ' '  'ZTSA2203'  'MTART'   ' '      ' ' ,
          ' '  'MARKL'  ' '  'ZTSA2203'  'MARKL'   ' '      ' ' ,
          ' '  'MENGE'  ' '  'ZTSA2203'  'MENGE'   'MEINS'  ' ' ,
          ' '  'MEINS'  ' '  'ZTSA2203'  'MEINS'   ' '      ' ' ,
          ' '  'DMBTR'  ' '  'ZTSA2203'  'DMBTR'   ' '      'WAERS' ,
          ' '  'WAERS'  ' '  'ZTSA2203'  'WAERS'   ' '      ' ' .

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING  pv_key
                      pv_field
                      pv_text
                      pv_ref_table
                      pv_ref_field
                      pv_qfield
                      pv_cfield.

  gt_fcat = VALUE #( BASE gt_fcat
                 (
                  key     = pv_key
                  fieldname = pv_field
                  coltext = pv_text
                  ref_table = pv_ref_table
                  ref_field = pv_ref_field
                  qfieldname    = pv_qfield
                  cfieldname    = pv_cfield
                  ) ).


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
        container_name = 'GCL_CONTAINER'.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat.
    ELSE.
      PERFORM refresh_grid.
  ENDIF.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data .

  DATA : ls_save TYPE ztsa2203.

  CLEAR   ls_save.
  IF   gs_data-matnr IS INITIAL
    OR gs_data-werks IS INITIAL.
    MESSAGE s000 WITH TEXT-e01 DISPLAY LIKE 'E'.
  ENDIF.

  ls_save = CORRESPONDING #( gs_data ).

  MODIFY ztsa2203 FROM ls_save.  " 모디파이는 무슨일이 있어도 무조건 0이 떨어진다.

  IF sy-dbcnt > 0 . " db에서 무슨 변화가 일어나면 카운트가 일어난다.
    COMMIT WORK AND WAIT.
    MESSAGE s002 WITH TEXT-m01.
  ELSE.
    ROLLBACK WORK.
    MESSAGE s000 WITH TEXT-m02 DISPLAY LIKE 'W'.
  ENDIF.



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


data: ls_stable type lvc_s_stbl.

ls_stable-row = 'X'.
ls_stable-COL = 'X'.

CALL METHOD gcl_grid->refresh_table_display
  EXPORTING
    is_stable      = ls_stable
    i_soft_refresh = SPACE.


ENDFORM.
