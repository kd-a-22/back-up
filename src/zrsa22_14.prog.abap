*&---------------------------------------------------------------------*
*& Report ZRSA22_14
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA22_14.

"tranparent table = structure type
data gs_carr type scarr.
PARAMETERS pa_carr like gs_carr-carrid.  "type 으로 주었을 때와 차이가 없다.

select SINGLE carrid carrname CURRCODE   "여기에 입력하는 필드위치가 테이블과 일치하지 않을 경우 좀 이상.. 필드에 맞춰 들어가게 하는 방법이 두 가지 있는데 하나는 SINGLE 뒤에 필드이름이 아닌 *를 붙이는 것이고(대신 모든 필들를 다 가져온다) 다른 하나는 INto CORRESPONDING FIELDS OF를 사용하는 것.
  FROM scarr
  INto CORRESPONDING FIELDS OF gs_carr
   WHERE carrid = pa_CARR.

  WRITE: GS_CARR-CARRID, GS_CARR-CARRNAME, GS_CARR-CURRCODE.


**types : BEGIN OF ts_cat,
**           home type c LENGTH 10,
**           name type c LENGTH 10,
**           age type i,
**         END OF ts_cat.
**
**data gs_cat type ts_cat.
**
***data : gv_cat_name type c LENGTH 10,
***       gv_get_age type i .
***
***data: BEGIN OF gs_cat,
***        name type c LENGTH 10,   "스트럭쳐라는 변수에 name과 age라는 컴포넌트가 있는 것이다. 속칭 필드라고 하기도 하는데 둘은 차이가 있긴 하다. 그건 다음에 말해주신대.
***        age type i,
***  end of gs_cat.
***
**
***write gs_cat-age.  "0이 출력된다. 즉 스트럭쳐변수에 각각에 컴포넌트에 따른 이니셜 밸류는 각각 컴포넌트의 타입에 따라 다르다.
**
***gs_cat-age = 2.
**IF gs_cat is not INITIAL.
**write 'Check'.
**ENDIF.
