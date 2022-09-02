*&---------------------------------------------------------------------*
*& Report ZRSA22_55
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_55.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-to1.

SELECTION-SCREEN END OF BLOCK bl1.
PARAMETERS pa_carr TYPE sflight-carrid OBLIGATORY.


DATA : BEGIN OF gs_scarr,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
       END OF gs_scarr,
       gt_scarr LIKE TABLE OF gs_scarr.

SELECT carrid carrname
  INTO CORRESPONDING FIELDS OF TABLE gt_scarr
  FROM scarr.

READ TABLE gt_scarr INTO gs_scarr WITH KEY carrid = 'AA'.

*★ NEW SYNTAX   " SELECT 하면서 데이터를 선언한다.
****  폼 안에서 테이블을 사용할 때 ... 일시적으로 테이블을 만들 때 인 것 같다. 당연히 헤더가 없는 놈으로 생성된다.
* * ** 어디서나 다 되는 것이 아니라 S4HANA나 버전이 좀 높은 곳에서만 된다. 오픈 SQL에서는 골뱅이가 들어가야 한다. 아밥 문법에서는 골뱅이 없어도 된다.
SELECT carrid , carrname
  INTO TABLE @DATA(lt_scarr2)
  FROM scarr.
*))1) STRUCTURE를 바로 선언
*READ TABLE lt_scarr2 INTO DATA(ls_scarr2) WITH KEY carrid = 'AA'.


**2)) STRUCTURE 바로 선언
LOOP AT lt_scarr2 INTO DATA(ls_scarr2).  " 여기서도 이렇게 스트럭쳐를 바로 선언할 수 있다.

ENDLOOP.



************************************************************
DATA: lv_carrid   TYPE scarr-carrid,
      lv_carrname TYPE scarr-carrname.

SELECT SINGLE carrid carrname
  INTO (lv_carrid, lv_carrname)
  FROM scarr
  WHERE carrid = 'AA'.

*★ NEW SYNTAX
SELECT SINGLE carrid , carrname
  FROM scarr
  WHERE carrid = @pa_carr  " 파라미터도 이렇게 헌언할 수 있는가바... ㅎ 오류 뜨네..
INTO (@DATA(lv_carrid2), @DATA(lv_carrname2)).


*************************************************************
DATA : BEGIN OF ls_scarr3,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         url      TYPE scarr-url,
       END OF ls_scarr3.

ls_scarr3-carrid = 'AA'.
ls_scarr3-carrname = 'America Airline'.
ls_scarr3-url = 'WWW.aa.com'.

ls_scarr3-carrid = 'KA'.

*★ NEW SYNTAX.
ls_scarr3 = VALUE #( carrid  = 'AAA'   " #을 붙이면 LS_SCARR3의 구조체에 값을 바로 넣을 수 있다??
                     carrname = 'America Airline'
                     url      = 'www.aacom' ).

ls_scarr3 = VALUE #( carrid = 'KA' ).  "    기술되지 않은 필드는 CLEAR된다.

ls_scarr3 = VALUE #( BASE ls_scarr3    " -> 기술되지 않은 필드는 모두 유지시켜줌.
                     carrid = 'KA' ).


DATA : BEGIN OF ls_scarr4,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         url      TYPE scarr-url,
       END OF ls_scarr4,

       lT_scarr4 LIKE TABLE OF ls_scarr4.

ls_scarr4-carrid = 'AA'.
ls_scarr4-carrname = 'America Airline'.
ls_scarr4-url = 'WWW.aa.com'.

APPEND ls_scarr4 to lt_scarr4.
* *new
REFRESH lt_scarr4.

lt_scarr4 = VALUE #(
                    (
                     carrid = 'AA'
                     CARRNAME = 'America Airline '
                     url  = 'www.aa.com' )
                    ( carrid = 'KA'
                      CARRNAME = 'korea airline'
                      url = 'www.ka.com')
                   ).
  lt_scarr4 = VALUE #( BASE lt_scarr4
                       ( carrid = 'LH'
                         carrname = 'Lufr Hansa'
                         url  = 'www.lh.com')
                          ) .
*  " 이런식으로도 사용할 수 있다. base를 붙이지 않으면 VAUE를 쓸 때마다 리프레시 되기때문에 만드시 BASE를 잊지 말고 써주어야 한다.

* LOOP AT itab into wa.
*   lt_scarr4 = VALUE #( BASE lt_scarr4
*                      ( carrid = wa-carrid
*                        carrname = wa-carrname
*                        url = wa-url
*                        )
*                      ).
*
* ENDLOOP.
*


****************************************************************
MOVE-CORRESPONDING LS_SCARR3 TO LS_SCARR4.
*★ NEW SYNTAX
LS_SCARR4 = CORRESPONDING #( LS_SCARR3 ).



***************************************************************
*DB Table과 internal taable 을 join하는 방법.



BREAK-POINT.
