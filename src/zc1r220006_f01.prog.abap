*&---------------------------------------------------------------------*
*& Include          ZC1R220006_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form get_airline_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_airline_data .

  SELECT a~carrid a~carrname a~url
         b~connid b~fldate b~planetype b~price b~currency
    FROM scarr AS a INNER JOIN sflight AS b
    ON a~carrid = b~carrid
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    WHERE a~carrid IN so_car
    AND b~connid IN so_con
    AND b~planetype IN so_ptype.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout_fcat .

  GS_LAYOUT-CWIDTH_OPT ='X'.

PERFORM set_fcat USING:
      'X' 'CARRID'     ' '   'SCARR'    'CARRID',
      'X' 'CARRNAME'   ' '   'SCARR'    'CARRNAME',
      ''  'CONNID'     ' '   'SFLIGHT'  'CONNID',
      ''  'FLDATE'     ' '   'SFLIGHT'  'FLDATE',
      ''  'PLANETYPE'  ' '   'SFLIGHT'  'PLANETYPE',
      ''  'PRICE'      ' '   'SFLIGHT'  'PRICE',
      ''  'URL'        ' '   'SFLIGHT'  'URL'.




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
FORM set_fcat  USING    PV_KEY PV_FIELD PV_TEXT PV_REF_TABLE PV_REF_FIELD.

  GS_FCAT = VALUE #(
                    KEY = PV_KEY
                    FIELDNAME = PV_FIELD
                    COLTEXT = PV_TEXT
                    REF_TABLE = PV_REF_TABLE
                    REF_FIELD = PV_REF_FIELD
  ).
CASE PV_FIELD.
  WHEN 'PLANETYPE'.
    GS_FCAT-HOTSPOT = 'X'.

ENDCASE.
  APPEND GS_FCAT TO GT_FCAT.
CLEAR GS_FCAT.
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

  IF GCL_CON IS NOT BOUND.
    CREATE OBJECT gcl_con
      EXPORTING
        repid                       = SY-REPID
        dynnr                       = SY-DYNNR
        side                        = gcl_con->DOCK_AT_LEFT
        extension                   = 3000.
    CREATE OBJECT gcl_grId
      EXPORTING
        i_parent          = GCL_CON.

    set HANDLER lcl_handler=>on_hotspot_click for gcl_grid.

    CALL METHOD gcl_GRID->set_table_for_first_display
      EXPORTING
         is_variant                    = GS_VARIANT
*        i_save                        =
*        i_default                     = 'X'
        is_layout                     = GS_LAYOUT
*        is_print                      =
*        it_special_groups             =
*        it_toolbar_excluding          =
*        it_hyperlink                  =
*        it_alv_graphics               =
*        it_except_qinfo               =
*        ir_salv_adapter               =
      CHANGING
        it_outtab                     = GT_DATA
        it_fieldcatalog               = GT_FCAT.



  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form ON_HOTSPOT_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM on_hotspot_click USING PS_ROW    TYPE LVC_S_ROW
                            PS_COLUMN TYPE LVC_S_COL.

    READ TABLE GT_DATA INTO GS_DATA INDEX ps_ROW-INDEX.
    IF SY-SUBRC <> 0.
      MESSAGE I000.
      EXIT.
    ENDIF.

*    CASE PS_COLUMN-FIELDNAME.
*      WHEN 'PLANETYPE'.
*          IF planetype IS  INITIAL.
*            EXIT.
*          ENDIF.
*          PERFORM GET_SAPLANE_DATA.
*    ENDCASE.

ENDFORM.

FORM GET_SAPLANE_DATA.

*  SET PARAMETER ID 'CAR' FIELD GS_DATA-CARRID.
*  SET PARAMETER ID 'DTB' FIELD
*
*CALL TRANSACTION 'SE16'.
*


  ENDFORM.
