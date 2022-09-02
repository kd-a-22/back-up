*&---------------------------------------------------------------------*
*& Report ZBC405_A22_FS01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a22_fs01.
TYPES :BEGIN OF GTY_FLT.
         INCLUDE TYPE ztspfli_t03.
TYPES:   SUM TYPE ztspfli_t03-wtg001.
  TYPES END OF GTY_FLT.


DATA : go_alv       TYPE REF TO cl_gui_alv_grid,
       go_container TYPE REF TO cl_gui_custom_container.

DATA : ok_code TYPE sy-ucomm.

DATA : gt_flt  TYPE TABLE OF GTY_FLT,
       GS_FLT TYPE GTY_FLT,
       gs_lay  TYPE lvc_s_layo,
       gt_fcat TYPE lvc_t_fcat,
       gs_fcat TYPE lvc_s_fcat,
       NN TYPE N LENGTH 3,
       FSNAME TYPE C LENGTH 20.

 FIELD-SYMBOLS : <FS> TYPE ANY.

PARAMETERS P_CAR TYPE SCARR-CARRID.




START-OF-SELECTION.


  SELECT  *
     FROM ztspfli_t03
    INTO CORRESPONDING FIELDS OF TABLE gT_flt.
*    WHERE CARRID = P_CAR.

LOOP AT  GT_FLT INTO GS_FLT.

CLEAR : NN.
DO 7 TIMES.
  NN = NN + 1.
  CONCATENATE 'GS_FLT-WTG' NN INTO FSNAME.
  CONDENSE FSNAME.

  ASSIGN (FSNAME) TO <FS>.
* GS_FLT-SUM = SUM_AMT + <FS>.

 GS_FLT-SUM = GS_FLT-SUM + <FS>.


ENDDO.


MODIFY GT_FLT FROM GS_FLT.

ENDLOOP.





  CALL SCREEN 100.




*&---------------------------------------------------------------------*
*& Module SET_DISP OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE set_disp OUTPUT.

  PERFORM set_lay.
  PERFORM set_fcat.




  CREATE OBJECT go_container
    EXPORTING
      container_name = 'MY_CON'
    EXCEPTIONS
      OTHERS         = 6.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CREATE OBJECT go_alv
    EXPORTING
      i_parent = go_container.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
*     i_buffer_active  =
*     i_bypassing_buffer            =
*     i_consistency_check           =
      i_structure_name = 'ZTSPFLI_T03'
*     is_variant       =
*     i_save           =
*     i_default        = 'X'
      is_layout        = gs_lay
*     is_print         =
*     it_special_groups             =
*     it_toolbar_excluding          =
*     it_hyperlink     =
*     it_alv_graphics  =
*     it_except_qinfo  =
*     ir_salv_adapter  =
    CHANGING
      it_outtab        = gt_flt
      it_fieldcatalog  = gt_fcat
*     it_sort          =
*     it_filter        =
*    EXCEPTIONS
*     invalid_parameter_combination = 1
*     program_error    = 2
*     too_many_lines   = 3
*     others           = 4
    .
  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE  TO SCREEN 0.
  ENDCASE.

ENDMODULE.
*&---------------------------------------------------------------------*
*& Form SET_LAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_lay .




ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat .

*  CLEAR gs_fcat.

  gs_fcat-fieldname = 'SUM'.
   gs_fcat-coltext = 'SUM'.
  gs_fcat-col_pos = 25.
  APPEND gs_fcat TO gt_fcat.
ENDFORM.
