*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA2202
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa2202_top                            .    " Global Data

INCLUDE mzsa2202_o01                            .  " PBO-Modules
INCLUDE mzsa2202_i01                            .  " PAI-Modules
INCLUDE mzsa2202_f01                            .  " FORM-Routines

LOAD-OF-PROGRAM.  " INITALINZATION 과 같은 기능.. 이니셜라이제이션은 1번 프로그램에서만 가능 하다.
  PERFORM set_default.
