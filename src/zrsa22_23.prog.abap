*&---------------------------------------------------------------------*
*& Report ZRSA22_23
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa22_23_top                           .    " Global Data



* INCLUDE ZRSA22_23_O01                           .  " PBO-Modules
* INCLUDE ZRSA22_23_I01                           .  " PAI-Modules
 INCLUDE zrsa22_23_f01                           .  " FORM-Routines



 " EVENT
 "LOAD-OF-PROGRAM   " INITIALIZATION와 비슷 딱 한 번만 실행된다 프로그램이 런타임 될 때 한 번만 사용된다. 둘은 같이 사용되지 않는다.
 INITIALIZATION.               " TYPE 이 1일 때만 사용 가능.. 즉 EXCUTABLEPROGRAM에서만 사용 가능 . 최조에 딱 한 번 실행  런타임시 (프로그르ㅐㅁ이 딱 시작하면 딱 한번 실행되는 이벤트)
  IF SY-UNAME = 'KD-A-22'.
    PA_CAR ='AA'.
    PA_CON = '0017'.
  ENDIF.
*   SELECT SINGLE CARRID CONNID
*     FROM SPFLI
*     INTO( PA_CAR, PA_CON).

 AT SELECTION-SCREEN OUTPUT.   " 1000번 화면.. 이 화면에 보이기 전에 실행되라. 화면이 뜨기 전에 하는 것이 얘.  PBO 라고 한다. A-S-S-O 라고도 하는데 거희 쓰지 않는다.

 AT SELECTION-SCREEN.          " PAI역할. 지금은 그냥 알고만 있으라.
   IF PA_CON IS INITIAL.

     " E / W 시ㅏ용을 권장
     MESSAGE W016(PN) WITH 'CHECK'.
     STOP.  "멈춰라.. 메시지타입 I를 부려주지만 약간 비정상적이다.


   ENDIF.

 START-OF-SELECTION.


   " GET INFO LIST
   PERFORM GET_INFO.
   WRITE 'TEST'.

IF GT_INFO IS INITIAL.
  " S(성공여부. 셀랙션스크린 하단에 뜬다. ), I(팝업창.. 멈춘다.), E(프로그램이 종료가 된다. 뒤로 가면 홈으로 가짐), W(얘도 E와 마찬가지), A(e보다 강하다. 무조건 확인 누르면 홈으로 돌아간다.), X(SHORT덤프를 띄운다.쓰는 경우 거희 없다. )
MESSAGE I016(PN) WITH 'DATA IS NOT FOUND'.
ELSE.

RETURN.  " 이걸 타면 블럭을 ㅂ바져 나간다. 즉 스타트오브셀렉션을 ㅏ져나간다. 즉 새랙션스크린을 다시 타고  셀렉션스크린을 보여준다.
ENDIF.
CL_DEMO_OUTPUT=>DISPLAY_DATA( GT_info ).

*IF GT_INFO IS NOT INITIAL.
*CL_DEMO_OUTPUT=>DISPLAY_DATA( GT_info ).
*ELSE.
*
*ENDIF.
