*&---------------------------------------------------------------------*
*& Report ZRSA22_51
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa22_51_top                           .    " Global Data

INCLUDE zrsa22_51_o01                           .  " PBO-Modules
INCLUDE zrsa22_51_i01                           .  " PAI-Modules
INCLUDE zrsa22_51_f01                           .  " FORM-Routines

INITIALIZATION.  " event

  "기본값 설정.
  PERFORM set_init.

AT SELECTION-SCREEN OUTPUT. " pbo  screen을 제공한다는 것 자체가 멈춘다는 것.
  MESSAGE s000(zmcsa22) with 'PBO'.

AT SELECTION-SCREEN.        " pai  이 세 문장은 순서를 다르게 선언해도 순서에 맞춰서 로직을 탄다.  사용자가 입력한 값을 처리.

START-OF-SELECTION.         " end-of-selection 을 쓰기도 하는데 크게 다르지 않다.
  SELECT SINGLE *
    FROM sflight
*    INTO sflight   " into 생략 가능. top에 sflight가 선언되어있기 때문에
    WHERE carrid = pa_car
    AND connid = pa_con
    AND fldate IN so_dat[].
  CALL SCREEN 100.
  MESSAGE s000(zmcsa22) with 'After call screen'.
