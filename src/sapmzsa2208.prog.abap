*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA2208
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE MZSA2208_TOP                            .    " Global Data

 INCLUDE MZSA2208_O01                            .  " PBO-Modules
 INCLUDE MZSA2208_I01                            .  " PAI-Modules
 INCLUDE MZSA2208_F01                            .  " FORM-Routines

 load-OF-PROGRAM.
 SELECT SINGLE *
   from ztsa2201
   INTO CORRESPONDING FIELDS OF zssa2270.
*   WHERE pernr > 2022010 .
