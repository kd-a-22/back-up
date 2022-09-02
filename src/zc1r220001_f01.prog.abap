*&---------------------------------------------------------------------*
*& Include          ZC1R220001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_param
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_param .

  pa_carr = 'KA'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  CLEAR   gs_data.
  REFRESH gt_data.

  SELECT carrid connid fldate price currency planetype

    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM sflight
    WHERE carrid = pa_carr
    AND connid IN so_conn.

  IF sy-subrc = 0.
    MESSAGE s001.
    LEAVE LIST-PROCESSING. " STOP
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
  gs_layout-sel_mode = 'D'.
  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING :
          'X'  'CARRID'     ''  'SFLIGHT' 'CARRID',
          'X'  'CONNID'     ''  'SFLIGHT' 'CONNID',
          'X'  'FLDATE'     ''  'SFLIGHT' 'FLDATE',
          ' '  'PRICE'      ''  'SFLIGHT' 'PRICE',
          ' '  'CURRENCY'   ''  'SFLIGHT' 'CURRENCY',
          ' '  'PLANETYPE'  ''  'SFLIGHT' 'PLANETYPE' .

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
*
*&---------------------------------------------------------------------*
FORM set_fcat  USING  pv_key pv_field pv_text pv_ref_table pv_ref_field .

  gS_fcat = VALUE #(
                      key     = pv_key
                      fiEldname = pv_field
                      coltext = pv_text
                      ref_table = pv_ref_table
                      ref_field = pv_ref_field
                     ).

  CASE PV_FIELD.
    WHEN 'PRICE'.
      GS_FCAT-CFIELDNAME = 'CURRENCY'.
  ENDCASE.

*  gs_fcat-key       = pv_key.
*  gs_fcat-fieldname = pv_field.
*  gs_fcat-coltext   = pv_text.
*  gs_fcat-ref_table = pv_ref_table.
*  gs_fcat-ref_field = pv_ref_field.
*
  APPEND gs_fcat TO gt_fcat.
  CLEAR  gs_fcat.


ENDFORM.
*&---------------------------------------------------------------------*
*& Module SET_DISPLAY OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
FORM set_display.

  CREATE OBJECT gcl_container
    EXPORTING
      repid     = SY-REPID
      dynnr     = sy-dynnr
*     side      = CL_GUI_DOCKING_CONTAINER=>DOCK_AT_LEFT
      side      = gcl_container->dock_at_left   " 왼쪽부터 시작
      extension = 3000.



  CREATE OBJECT gcl_grid
    EXPORTING
      i_parent          =  GCL_CONTAINER.
  GS_VARIANT-REPORT = SY-REPID.
*




CALL METHOD gcl_grid->set_table_for_first_display
  EXPORTING
    is_variant                    = GS_VARIANT
    i_save                        = 'A'
    i_default                     = 'X'
    is_layout                     = GS_LAYOUT
  CHANGING
    it_outtab                     = GT_DATA
    it_fieldcatalog               = GT_FCAT.



ENDFORM.
