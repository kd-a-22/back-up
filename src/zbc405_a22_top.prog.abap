*&---------------------------------------------------------------------*
*& Include ZBC405_A22_TOP                           - Report ZBC405_A22
*&---------------------------------------------------------------------*
REPORT zbc405_a22.
tables  : dv_flights.

DATA : gs_flt TYPE dv_flights ."TABLE OF dv_flights WITH HEADER LINE.

 SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME title text-t01.

PARAMETERS : p_car TYPE s_carr_id MEMORY ID car OBLIGATORY DEFAULT 'LH' VALUE CHECK,
             p_con TYPE s_conn_id VALUE CHECK. " value check 라는 키워드는 테크테이블로 연결된 필드에 없는 값을 입력시 오류메시지 뜸.

*set PARAMETER ID 'Z01' FIELD p_car.  " 이렇게 memory id를 내가 만들 수도 있다. 이 이름을 쓰는 파라미터는 이 값을 메모리 아이디로 하겠다. ? 생성은 안 함.
*get PARAMETER ID 'z01' field p_car.   " 이거 설명은 놓침....+아마도 GET이라니까 내가 설정한 것을 가져오겠다는 거 아닐까?
SELECT-OPTIONS : s_fldata for dv_flights-fldate.
SELECTION-SCREEN END OF BLOCK b1.
PARAMETERS : p_str TYPE string LOWER CASE
                  MODIF ID mod.

PARAMETERS : p_chk AS CHECKBOX DEFAULT 'X'
                   MODIF ID mod.

PARAMETERS : p_radi1 RADIOBUTTON GROUP rd1,
             p_radi2 RADIOBUTTON GROUP rd1,
             p_radi3 RADIOBUTTON GROUP rd1.

CASE 'X'.
  WHEN p_radi1.
  WHEN p_radi2.
  WHEN p_radi3.
  WHEN OTHERS.
ENDCASE.

INITIALIZATION.
  LOOP AT SCREEN.
    IF screen-group1 = 'MOD'.
      screen-input = 0.
      screen-output = 1.
      MODIFY SCREEN.

    ENDIF.
  ENDLOOP.
*MODIFY id  screen 에 입력을 가능하게 / 불가능 하게 할 때 사용.
*이 아이디가 설정된 아이는 스크린이 실행되면서 자동으로 생기는 SCREEN이라는 인터널 테이블에서 입력이 되게 할 수도 있고 안되게 할 수도 있다.
*screen-group1에서 modyfi id가 들어간다.
