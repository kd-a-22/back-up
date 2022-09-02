*&---------------------------------------------------------------------*
*& Report ZRSA22_30
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRSA22_30.


*PARAMETERS PA_NAME TYPE ZENAME_A22. " 프로그램에서 DOMAIN은 안 되지만T

*TYPES: BEGIN OF TS_INFO,
*  STDNO TYPE N LENGTH 8,
*  SNAME TYPE N LENGTH 40,
*  END OF TS_INFO.

*DATA GS_STD TYPE TS_INFO.

DATA GS_STD TYPE ZSSA2201.

GS_STD-STDNO = '2020001'.
GS_STD-SNAME = 'Kang SK'.
