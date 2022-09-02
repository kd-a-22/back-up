*&---------------------------------------------------------------------*
*& Include ZBC405_A22_SOL_TOP                       - Report ZBC405_A22_SOL
*&---------------------------------------------------------------------*
REPORT zbc405_a22_sol.

TABLES  : dv_flights.

DATA : gs_flt TYPE dv_flights ."TABLE OF dv_flights WITH HEADER LINE.
DATA : GT_FLT LIKE TABLE OF SFLIGHTS WITH HEADER LINE.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.

  PARAMETERS : p_car TYPE s_carr_id MEMORY ID car OBLIGATORY DEFAULT 'LH' VALUE CHECK,
               p_con TYPE s_conn_id VALUE CHECK. " value check 라는 키워드는 테크테이블로 연결된 필드에 없는 값을 입력시 오류메시지 뜸.

*set PARAMETER ID 'Z01' FIELD p_car.  " 이렇게 memory id를 내가 만들 수도 있다. 이 이름을 쓰는 파라미터는 이 값을 메모리 아이디로 하겠다. ? 생성은 안 함.
*get PARAMETER ID 'z01' field p_car.   " 이거 설명은 놓침..
  SELECT-OPTIONS : s_fldate FOR dv_flights-fldate.
SELECTION-SCREEN END OF BLOCK b1.
PARAMETERS : p_str TYPE string LOWER CASE
                  MODIF ID mod.

PARAMETERS : p_chk AS CHECKBOX DEFAULT 'X'
                   MODIF ID mod.

PARAMETERS : p_radi1 RADIOBUTTON GROUP rd1,
             p_radi2 RADIOBUTTON GROUP rd1,
             p_radi3 RADIOBUTTON GROUP rd1.
