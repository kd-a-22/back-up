*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSA22VEN.......................................*
TABLES: ZVSA22VEN, *ZVSA22VEN. "view work areas
CONTROLS: TCTRL_ZVSA22VEN
TYPE TABLEVIEW USING SCREEN '0040'.
DATA: BEGIN OF STATUS_ZVSA22VEN. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA22VEN.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA22VEN_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA22VEN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA22VEN_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA22VEN_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA22VEN.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA22VEN_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSA22VEN                      .
