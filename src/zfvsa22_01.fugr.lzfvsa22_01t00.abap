*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVSA2203........................................*
TABLES: ZVSA2203, *ZVSA2203. "view work areas
CONTROLS: TCTRL_ZVSA2203
TYPE TABLEVIEW USING SCREEN '0010'.
DATA: BEGIN OF STATUS_ZVSA2203. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA2203.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA2203_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA2203.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA2203_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA2203_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA2203.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA2203_TOTAL.

*...processing: ZVSA2204........................................*
TABLES: ZVSA2204, *ZVSA2204. "view work areas
CONTROLS: TCTRL_ZVSA2204
TYPE TABLEVIEW USING SCREEN '0020'.
DATA: BEGIN OF STATUS_ZVSA2204. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA2204.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA2204_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA2204.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA2204_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA2204_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA2204.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA2204_TOTAL.

*...processing: ZVSA2205........................................*
TABLES: ZVSA2205, *ZVSA2205. "view work areas
CONTROLS: TCTRL_ZVSA2205
TYPE TABLEVIEW USING SCREEN '0030'.
DATA: BEGIN OF STATUS_ZVSA2205. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA2205.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA2205_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA2205.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA2205_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA2205_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA2205.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA2205_TOTAL.

*...processing: ZVSA2299........................................*
TABLES: ZVSA2299, *ZVSA2299. "view work areas
CONTROLS: TCTRL_ZVSA2299
TYPE TABLEVIEW USING SCREEN '0040'.
DATA: BEGIN OF STATUS_ZVSA2299. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVSA2299.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVSA2299_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVSA2299.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA2299_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVSA2299_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVSA2299.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVSA2299_TOTAL.

*.........table declarations:.................................*
TABLES: ZTSA2201                       .
TABLES: ZTSA2202_1                     .
TABLES: ZTSA2202_T                     .
TABLES: ZTSA2299                       .
TABLES: ZTSA22_PRO                     .
