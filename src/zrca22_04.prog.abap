*&---------------------------------------------------------------------*
*& Report ZRCA22_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca22_04.

*PARAMETERS pa_car TYPE scarr-carrid.  "C type length 3
**parameters pa_car1 type c LENGTH 3.
*
*DATA gs_info TYPE scarr." stuructuer valuable의 약자.. structuer type 과 혼동하지 말 것.
*
*CLEAR gs_info.
*SELECT SINGLE carrid carrname
*  FROM scarr
*INTO CORRESPONDING FIELDS OF gs_info
*  WHERE carrid = pa_car.
*
*  write : gs_info-mandt, gs_info-carrid, gs_info-carrname.
*
*  data sdf type sy-subrc.

  PARAMETERS : p_int type i DEFAULT 2,
               p_int2 type scarr-carrid.
