*&---------------------------------------------------------------------*
*& Include          ZC1R220004_CLASS
*&---------------------------------------------------------------------*









*CLASS lcl_handler DEFINITION.
*
*  PUBLIC SECTION .
*    CLASS-METHODS :
*      on_doubleclick FOR EVENT double_click
*        OF cl_gui_alv_grid
*        IMPORTING e_row e_column es_row_no.
*ENDCLASS.
*
*CLASS lcl_handler IMPLEMENTATION.
*
*  METHOD: on_doubleclick.
*
*    PERFORM on_doubleclick USING e_column.
*
*
*
*
*  ENDMETHOD.
*
*ENDCLASS.
*&---------------------------------------------------------------------*
*& Class lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION FINAL.   " FINAL "더이상 상속할 수 없다. 여기서 끝,, 누구에게도 상속해 줄 수 없다.

* 클래스의  특징
*   상속성  : inheritance
*   캡슐화  : incapsulation
*   다형성  : Polymorphism  " 이름이 같은 메소드를 여러개 만들 수 있다. 단 파라미터나 형태가 달라야 한다. 같은 이름에 다른 형태의 메소드 존재 가능. 오버로딩 개념과 이어진다.


  PUBLIC SECTION.
  METHODS :
      HANDLE_DOUBLE_CLICK FOR EVENT double_click OF cl_gui_alv_grid " CL_...클래스의 double_click을 위한 메소드를 선언하는 것.
      IMPORTING e_row e_column,
      HANDLE_HOTSPOT FOR EVENT HOTSPOT_click of cl_gui_alv_grid
      IMPORTING e_row_id e_column_id.




ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_event_handler
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.
  method HANDLE_DOUBLE_CLICK .

    PERFORM HANDLE_DOUBLE_CLICK USING e_row  e_column.

    ENDMETHOD.
METHOD handle_hotspot.
  PERFORM HANDLE_HOTSPOT USING e_row_id e_column_id.

  ENDMETHOD.



ENDCLASS.
