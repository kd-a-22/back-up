*&---------------------------------------------------------------------*
*& Include          ZC1R220005_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_LIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_list .
  _clear gs_list gt_list.

  SELECT carrid connid fldate price currency planetype paymentsum
    INTO CORRESPONDING FIELDS OF TABLE gt_list
    FROM sflight
    WHERE carrid IN so_carr.
  IF sy-subrc <> 0.
    MESSAGE s001.
    LEAVE LIST-PROCESSING.
  ENDIF.

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

  gs_layout-zebra = 'x'.
  gs_layout-sel_mode = 'D'.
  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING :
          'X'   'CARRID'       ' ' 'SFLIGHT'  'CARRID',
          'X'   'CONNID'       ' ' 'SFLIGHT'  'CONNID',
          'X'   'FLDATE'       ' ' 'SFLIGHT'  'FLDATE',
          ' '   'CARRNAME'     ' ' 'SCARR'    'CARRNAME',
          ' '   'PRICE'        ' ' 'SFLIGHT'  'PRICE',
          ' '   'CURRENCY'     ' ' 'SFLIGHT'  'CURRENCY',
          ' '   'PLANETYPE'    ' ' 'SFLIGHT'  'PLANETYPE',
          ' '   'PAYMENTSUM'   ' ' 'SFLIGHT'  'PAYMENTSUM'.

  ENDIF.

  IF gs_sort IS INITIAL.
    PERFORM set_sort.

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
FORM set_fcat  USING   pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat = VALUE #( key      = pv_key
                    fieldname = pv_field
                    coltext   = pv_text
                    ref_table = pv_ref_table
                    ref_field = pv_ref_field ).
  CASE pv_field.
    WHEN 'PRICE' .
      gs_fcat = VALUE #( BASE gs_fcat
                              cfieldname = 'CURRENCY'
                              do_sum     = 'X' ).  " 해당 필드에 대한 합계를 자동으로 내 준다.
    WHEN 'PAYMENTSUM'.
      gs_fcat = VALUE #( BASE gs_fcat
                              cfieldname = 'CURRENCY' ).
  ENDCASE.

  APPEND gs_fcat TO gt_fcat.

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

  IF  gcl_container IS NOT BOUND.
    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gcl_container->dock_at_left
        extension = 3000.
*

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.
*
    SET HANDLER : lcl_event_handler=>handle_double_click FOR gcl_grid.

    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
*
      CHANGING
        it_outtab       = gt_list
        it_fieldcatalog = gt_fcat
        it_sort         = gt_sort.

*


  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_DOUBLE_CLICK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&---------------------------------------------------------------------*
FORM handle_double_click  USING    ps_row    TYPE lvc_s_row
                                   ps_column TYPE lvc_s_col .


  READ TABLE gt_list INTO gs_list INDEX ps_row-index.

  IF sy-subrc <> 0.
    EXIT.
  ENDIF.

  CASE ps_column-fieldname.
    WHEN 'CARRID'.
      IF gs_list-carrid IS INITIAL.
        EXIT.
      ENDIF.

      PERFORM get_airline_info USING gs_list-carrid.

  ENDCASE.

ENDFORM.

FORM get_airline_info USING pv_carrid TYPE scarr-carrid.

  _clear gs_scarr gt_scarr.



  SELECT carrid carrname currcode url
    INTO CORRESPONDING FIELDS OF TABLE gt_scarr
    FROM scarr
    WHERE carrid = pv_carrid.

  IF sy-subrc NE 0.   " 100 화면에서는 PBO를 다시 가야 하기 때문에 STOP을 쓰면 안 된다.
    MESSAGE s000 WITH TEXT-m01.
    EXIT.
  ENDIF.

  CALL SCREEN '0101' STARTING AT 20 3.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout_pop .

  gs_layout_pop-zebra      = 'X'.
  gs_layout_pop-cwidth_opt = 'X'.
  gs_layout_pop-sel_mode   = 'D'.
  gs_layout_pop-no_toolbar = 'X'.  " ALV의 툴바를 없애줌

  IF gs_fcat_pop IS INITIAL.
    PERFORM set_fcat_pop USING :
          'X'  'CARRID'    ' ' 'SCARR'   'CARRID'  ,
          'X'  'CARRNAME'  ' ' 'SCARR'   'CARRNAME',
          'X'  'CURRCODE'  ' ' 'SCARR'   'CURRCODE',
          'X'  'URL'       ' ' 'SCARR'   'URL'     .

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT_POP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat_pop  USING    pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gt_fcat_pop = VALUE #( BASE gt_fcat_pop
                        ( key       = pv_key
                          fieldname = pv_field
                          coltext   = pv_text
                          ref_table = pv_ref_table
                          ref_field = pv_ref_field
                          )
                         ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen_POP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen_pop .

  IF gcl_container_pop IS NOT BOUND.
    CREATE OBJECT gcl_container_pop
      EXPORTING
        container_name = 'GCL_CONTAINER_POP'.

    CREATE OBJECT gcl_grid_pop
      EXPORTING
        i_parent = gcl_container_pop.



    CALL METHOD gcl_grid_pop->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout_pop
      CHANGING
        it_outtab       = gt_scarr
        it_fieldcatalog = gt_fcat_pop.




  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SORT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort .

  gt_sort = VALUE #(
                    (
                    spos      = 1
                    fieldname = 'CARRID'
                    up        = 'X'  " ASENDDING
                    subtot    = 'X'  " 이 기준으로 서브토탈도 낼 것이다.
                   )
                   (
                    spos     = 2
                    fieldname = 'CONNID'
                    up       = 'X'
                       ) ).


**  gs_sort-spos      = 1.         " 정해준 순서대로 정렬이 된다.  SPOS가 2 번이 먼저 적혀있어도 알아서 1번을 찾아가 먼저 정렬을 한다.
**  gs_sort-fieldname = 'CARRID'.   " 하지만 필드들 중에서도 순서가 있다. 그 필드를 먼저 적고 SPOS번호는 뒷자리로 주더라도  뒷 순서의 필드를 먼저 정렬할 수 있다.
**  gs_sirt-up        = 'X'.
**  APPEND gs_sort TO gt_sort .
**
**  gs_sort-spos      = 2.
**  gs_sort-fieldname = 'CONNID'.
**  gs_sirt-up        = 'X'.
**  APPEND gs_sort TO gt_sort .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_carrname
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_carrname .
  DATA : lv_tabix TYPE sy-tabix,
         lt_scarr TYPE ZC1TT22001,
         ls_scarr TYPE scarr,
         LV_CODE,
         LV_MSG(100).

  IF gcl_scarr IS NOT BOUND.
    CREATE OBJECT gcl_scarr.
  ENDIF.

  LOOP AT gt_list INTO gs_list.
    lv_tabix = sy-tabix.

    _clear ls_scarr lt_scarr.
    clear : lv_code, lv_msg.
    CALL METHOD gcl_scarr->get_airline_info
      EXPORTING
        pi_carrid  = gs_list-carrid
      IMPORTING
        pe_code    = lv_code
        pe_msg     = lv_msg
      changing
        et_airline = lt_scarr  .

    IF lv_code = 'S'.
      READ TABLE lt_scarr into ls_scarr  WITH KEY CARRID = GS_LIST-CARRID.    " INDEX 1. WITH KEY 데신 이렇게 써도 됨.
      IF SY-subrc = 0.
        GS_LIST-CARRNAME = LS_SCARR-CARRNAME.

        MODIFY gt_list FROM gs_list  INDEX lv_tabix
        TRANSPORTING CARRNAME.
      ENDIF.

    ENDIF.

  ENDLOOP.

ENDFORM.
