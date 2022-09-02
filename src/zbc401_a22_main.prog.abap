*&---------------------------------------------------------------------*
*& Report ZBC401_A22_MAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a22_main.

TYPE-POOLS icon.


CLASS lcl_ariplane DEFINITION.

  PUBLIC SECTION .

    METHODS : constructor           " consturucure 생성.. 크리에이트 오브젝트할 때 자동으로 불러와질 아이들.
      IMPORTING  iv_name      TYPE string
                 iv_planetype TYPE saplane-planetype
      EXCEPTIONS wrong_planetype.


    METHODS : set_attributes              " ★instance method★
      IMPORTING iv_name      TYPE string
                iv_planetype TYPE saplane-planetype,
      display_attributes.  " 이 메소드는  import , export parameter 가 없다.

    CLASS-METHODS : display_n_o_ariplanes. " ★static method★
    " 에어플레인의 속성을  받아 출력할 속성들을 만드는 것.

    CLASS-METHODS : get_n_o_airplanes
      RETURNING VALUE(rv_count) TYPE i.


    CLASS-METHODS : class_constructore. " 파라미터도 없이 이름 만 존재하는 아이.



  PRIVATE SECTION.
    DATA : mv_name      TYPE string,
           mv_planetype TYPE saplane-planetype,
           mv_weight    TYPE saplane-weight,
           mv_tankcap   TYPE saplane-tankcap.

    TYPES : ty_plabetoye TYPE TABLE OF saplane.
    CLASS-DATA :  gv_n_o_airplanes TYPE i.    " 얘는 static 변수
    CLASS-DATA : gt_planetype TYPE ty_plabetoye.
    CONSTANTS : c_pos_i TYPE i VALUE 30.   " 없어도 되는 데 책에서 쓰라고 하니 쓴다.  ..

    CLASS-METHODS : get_technical_attributes
      IMPORTING  iv_type    TYPE saplane-planetype
      EXPORTING  ev_weight  TYPE saplane-weight
                 ev_tankcap TYPE saplane-tankcap
      EXCEPTIONS wrong_planetye.
    "



ENDCLASS.

CLASS lcl_ariplane IMPLEMENTATION.

  METHOD  get_technical_attributes.

    DATA: ls_planetype TYPE saplane.
    READ TABLE gt_planetype INTO ls_planetype
    WITH KEY planetype = iv_type.

    IF  sy-subrc = 0.
      ev_weight = ls_planetype-weight.
      ev_tankcap = ls_planetype-tankcap.

    ENDIF.

  ENDMETHOD.


  METHOD class_constructore.  " 이니셜라이제이션처럼 사용할 수도 있다.
    SELECT * INTO TABLE gt_planetype FROM saplane.
  ENDMETHOD.


  METHOD constructor.
    DATA : ls_planetype TYPE saplane.
    mv_name = iv_name.
    mv_planetype = iv_planetype.

    CALL METHOD get_technical_attributes
      EXPORTING
        iv_type    = iv_planetype
      IMPORTING
        ev_weight  = mv_weight
        ev_tankcap = mv_tankcap
      EXCEPTIONS
       wrong_planetye = 1.
**    SELECT SINGLE * INTO ls_planetype  " method get_technical_attributes 부분
**      FROM saplane
**      WHERE planetype = iv_planetype.
**
**    IF sy-subrc NE 0.
**
**      RAISE wrong_planetype.
**    ELSE.
**
**      mv_weight = ls_planetype-weight.
**      mv_tankcap = ls_planetype-tankcap.

    IF sy-subrc = 0..
      gv_n_o_airplanes = gv_n_o_airplanes + 1.

      ELSE.
        raise wrong_planetype.
    ENDIF.



ENDMETHOD.

METHOD  get_n_o_airplanes.
  rv_count = gv_n_o_airplanes. " 비행기가 몇 대인지 알려준다.
ENDMETHOD.


METHOD set_attributes.
  mv_name = iv_name.
  mv_planetype = iv_planetype.
  gv_n_o_airplanes = gv_n_o_airplanes + 1.
ENDMETHOD.

METHOD display_attributes.
  WRITE : / icon_ws_plane AS ICON,
          / 'Name of airplane', AT c_pos_i mv_name,
          / 'Type of ariplane', AT c_pos_i mv_planetype,
          / 'Weight'          , AT c_pos_i mv_weight.
ENDMETHOD.

METHOD display_n_o_ariplanes.
  WRITE : / 'Number of Airplanes' , AT c_pos_i gv_n_o_airplanes.
ENDMETHOD.

ENDCLASS.





DATA : go_ariplane TYPE REF TO lcl_ariplane.
DATA : gt_ariplanes TYPE TABLE OF REF TO lcl_ariplane.  " ref to 해서 만든 table 이기 때문에 이렇게

START-OF-SELECTION.

  CALL METHOD lcl_ariplane=>display_n_o_ariplanes. "= lcl_ariplane=>display_n_o_ariplanes(). 이렇게 선언해도 된다. 이게 최신형.

  CREATE OBJECT go_ariplane
    EXPORTING
      iv_name         = 'LH Berlin'
      iv_planetype    = 'A321'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_ariplane TO gt_ariplanes.
  ENDIF.


*  CALL METHOD go_ariplane->set_attributes
*    EXPORTING
*      iv_name      = 'LH Berlin'
*      iv_planetype = 'A321'.


  CREATE OBJECT go_ariplane
    EXPORTING
      iv_name         = 'AA New york'
      iv_planetype    = '747-400'
    EXCEPTIONS
      wrong_planetype = 1.
  IF sy-subrc = 0.
    APPEND go_ariplane TO gt_ariplanes.
  ENDIF.

*  CALL METHOD go_ariplane->set_attributes
*    EXPORTING
*      iv_name      = 'AA New york'
*      iv_planetype = '747-400'.

*  CREATE OBJECT go_ariplane.
*  APPEND go_ariplane TO gt_ariplanes.
*  CALL METHOD go_ariplane->set_attributes
*    EXPORTING
*      iv_name      = 'US Herculs'
*      iv_planetype = '747-200F'.

  LOOP AT gt_ariplanes INTO go_ariplane.

    CALL METHOD go_ariplane->display_attributes.
  ENDLOOP.

  DATA : gv_count TYPE i.

  gv_count = lcl_ariplane=>get_n_o_airplanes( ).
  WRITE : / 'Number of ariplane', gv_count.
