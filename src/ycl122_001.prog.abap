*&---------------------------------------------------------------------*
*& Report YCL122_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YCL122_001.

INCLUDE  YCL122_001_TOP.     " 전역 변수 선언
INCLUDE  YCL122_001_CLS.     " ALV 관련 선언
INCLUDE  YCL122_001_SCR.     " 검색화면
INCLUDE  YCL122_001_PBO.     " Process Befor Output
INCLUDE  YCL122_001_PAI.     " Process After Input
INCLUDE  YCL122_001_F01.     " Subroutions


INITIALIZATION.              " 프로그램 실행 시 가장 처음에 1회만 수행되는 이벤트 구간
TEXT01 = '검색조건'.

AT SELECTION-SCREEN OUTPUT.  " 검색화면에서 화면이 출력되기 직전에 수행되는 구간
                             " 주용도는 검색화면에 대한 제어 ( 특정필드 숨김 또는 읽기 전용 )


AT SELECTION-SCREEN.         " 검색화면이 뜬 다음
                             " 검색화면에서 사용자가 특정 이벤트를 발생시겼을 때 수행되는 구간
                             " 상단의 펑션키 이벤트. 특정 필드의 클릭, 엔터 드으이 이벤트에서 입력값에 대한 점검, 실행 권한 점검

START-OF-SELECTION.          " 실행버튼을 누른 다름
                             " 검색화면에서 실행버튼 눌렀을 때 수행도는 구간.   " 데이터 조회가 주 용도 end-of-selection과 구분하지 않는 경우도 있다.
PERFORM SELECT_DATA.

END-OF-SELECTION  .          " strart-of-seletion 이 끝나고 실행되는 구간. 데이터 출력

IF GT_SCARR IS INITIAL.
  MESSAGE '데이터가 없습니다.' TYPE 'S' DISPLAY LIKE 'W'.
  " 프로그램을 계속 이어서 진행되도록 만드는 타입  S , I  (하단에 메시지 출력하면서 계속, 팝업창을 출력하면서 일시정지)
  " 프로그램을 중단시키는 타입                     W , E , X
  ELSE.
    CALL SCREEN 0100.
ENDIF.
