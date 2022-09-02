*&---------------------------------------------------------------------*
*& Report ZRSA22_15
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA22_15.

data: BEGIN OF gs_std ,

        STDNO TYPE N LENGTH 8,
        SNAME TYPE C LENGTH 40,
        GENDER TYPE C LENGTH 1,
        gender_t type c LENGTH 10,

      end OF gs_STD.
      DATA GT_STD LIKE TABLE OF GS_STD.

*      PERFORM appenstd

    GS_STD-STDNO = '2020001'.
    GS_STD-SNAME = 'KANG'.
    GS_STD-GENDER = 'M'.
    GS_STD-STDNO = '2020002'.
    APPEND gs_std to gt_std.

    clear gs_std.
    gs_std-stdno = '2020003'.
    gs_std-sname = 'HAN'.
    gs_std-gender = 'F'.
    APPEND gs_std to gt_std.



" modify
LOOP AT gt_std into gs_std.
  gs_std-gender_t = 'male'(t01).
  MODIFY gt_std from gs_std.  " loop 밖에서 modify하면 몇 번째를 해야하는 지 모르니 오류가 난다. 그래서 index 번호를 지정해 주어야 한다. 그래서 잘 사용하지 않는다. 루프에서 사용하는 것은 index sy-tabis를 생략하는 것.


  clear gs_std.
ENDLOOP.

*    write gt_std-stdno.   " 이게 불가... 인터널 테이블은 창고같은 용도. 임시로 잠시 담아두는 것ㅇ. 테이블애 있는 것을 자깐 담아두고 사라진다.
    cl_demo_output=>display_data( gt_std ). "이렇게 하면 인터널테이블의 내용물을 write를 쓰지 않고도 확인할 수 있다.
    "                  스세틱어쩌구    파라미터로 값을 준것


clear gs_std.
*1)
*read table gt_std INDEX 1 into gs_std.   " gt_std table에 있는 것을 gs_std 스트럭쳐애 집어 넣는 것
*2)
*read TABLE gt_std WITH KEY stdno = '20220001'   "
*into gs_std.   " 여기서는 structure에 담으니 한 건만 가져온다.
*3)   " key 조건을 여러개 줄 수도 있다.
read TABLE gt_std WITH KEY stdno = '20220001'   "
                          gender = 'F'
into gs_std.   " 여기서는 structure에 담으니 한 건만 가져온다.




*
*loop at gt_std into gs_std.
*
*  write : sy-tabix, gs_std-stdno,
*          gs_std-sname, gs_std-gender.
*  NEW-LINE.
*
*  clear gs_std.
*
*  endloop.
*  write : / sy-tabix, gs_std-stdno,
*          gs_std-sname, gs_std-gender.











Data : g1 type scarr,  "structure 생성
       G2 like table of g1."table생성

Data: g3 like G2 ,      "table생성
      G4 like line of g3."table 생성

Data: g5 type table of scarr,"인터널 테이블
     G6 like line of G5.     "테이블 타입

Data : g7 like line of  G2, " 스트럭쳐타입
   G8 like table of g7.     "table생성.


*data: gs_xxx9 type line of scarr,
*       gt_xxx10 type scarr.
*
*    BREAK-POINT.
