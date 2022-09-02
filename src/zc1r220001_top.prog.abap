*&---------------------------------------------------------------------*
*& Include ZC1R220001_TOP                           - Report ZC1R220001
*&---------------------------------------------------------------------*
REPORT ZC1R220001 MESSAGE-ID zmcsa22.

TABLES : sflight.

data : BEGIN OF gs_data,
      carrid   type sflight-carrid  ,
      connid   type sflight-connid  ,
      fldate   type sflight-fldate  ,
      price    type sflight-price   ,
      currency type sflight-currency,
     planetype type sflight-Planetype,
  END OF gs_data,

   gt_data like TABLE OF gs_data.


* ALV 관련 DATA
DATA : GCL_CONTAINER TYPE REF TO cl_gui_docking_container,  " 따로 컨테이너 영역을 그리지 않는다. 크기도 마음만 먹으면 엄청나게 커진다. ALV전용을 쓸 때는 대부분 도킹을 쓴다.
       GCL_GRID TYPE REF TO CL_GUI_ALV_GRID,
       GS_FCAT TYPE LVC_S_FCAT,
       GT_FCAT TYPE LVC_T_FCAT,
       GS_LAYOUT TYPE LVC_S_LAYO,
       GS_VARIANT TYPE disvariant..


DATA : GV_OKCODE TYPE SY-UCOMM.
