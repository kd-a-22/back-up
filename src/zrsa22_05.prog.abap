*&---------------------------------------------------------------------*
*& Report ZRSA22_05
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa22_05.





* 11시
" FIELLD SYMBOL. 같은 문자를 한 번에 변경하거나 할 때 사용
write 'First Name'(t02).  " 이렇게만 적는 게 아니라 더블클릭 해서 생성을 해 주어야 한다... 값이 밖에도 나와있는 것.
write 'First Name'(t02).

*WRITE TEXT-T01.  " Last Name   " 값이 안에만 들어있는 것.
*WRITE TEXT-T01.  "Last Name


*"         상수 conctants
*DATA gv_ecode TYPE c LENGTH 4 VALUE 'sync'.
*CONSTANTS GC_ECODE TYPE C LENGTH 4 VALUE 'SYNC'.  "상수.. 값을 바꿀 수 없다. 출력을 한 뒤
*WRITE gC_ecode.
*
*GV_ECODE = 'TEST'.







*types: t_name type c length  10.
*
*data gv_name type t_name.  types로 타입을 선언할 수 도 있다. c  type 의 10 자리 변수를 선언한 것. 하지만 로컬타입으로 해당 프로그램에서만 사용 가능하다. c type은 글로벌 변수로 다른 프로그램에서도 사용 가능.
*
*data gv_cname type t_name.





**<================N 과 I의 차이..N은 연산이 가능한가?? 가능하다.
*DATA gv_n TYPE n LENGTH 3.
*DATA gv_n2 TYPE n LENGTH 3.
*DATA gv_n3 TYPE n LENGTH 3.
*
*DATA gv_i TYPE i .
*gv_n = 005.
*gv_n2 = 002.
*gv_n3 = gv_n + gv_n2.
*gv_i = 001.
*
*WRITE: gv_n3, gv_i.





*DATA gv_d1 TYPE d.
*DATA gv_d2 TYPE sy-datum.

*data: gv_n1 type n LENGTH 2,
*      gv_n2 type n,
*      gv_i type i.
*
*WRITE: gv_n1, gv_n2,  gv_i.

*data gv_p type p LENGTH 2 DECIMALS 2.
*
*gv_p = '1.23'.   " P에서 length 를 잘 쓰지 않는다. ㅣlength를 쓰면 길이는 2n-1 이 된다. 즉 여기서는 3이 되는 듯.
*                  " length를 지정할 수 있다 = incompelet type 이다. 하지만 길이지정 하지 않을 수도 있는 경우도 있다.
*
*write gv_p.
