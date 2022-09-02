*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSAPLANE_A22....................................*
DATA:  BEGIN OF STATUS_ZSAPLANE_A22                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSAPLANE_A22                  .
CONTROLS: TCTRL_ZSAPLANE_A22
            TYPE TABLEVIEW USING SCREEN '0080'.
*...processing: ZSCARR_A22......................................*
DATA:  BEGIN OF STATUS_ZSCARR_A22                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSCARR_A22                    .
CONTROLS: TCTRL_ZSCARR_A22
            TYPE TABLEVIEW USING SCREEN '0020'.
*...processing: ZTSFLIGHT_A22...................................*
DATA:  BEGIN OF STATUS_ZTSFLIGHT_A22                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSFLIGHT_A22                 .
CONTROLS: TCTRL_ZTSFLIGHT_A22
            TYPE TABLEVIEW USING SCREEN '0011'.
*...processing: ZTSPFLI_A22.....................................*
DATA:  BEGIN OF STATUS_ZTSPFLI_A22                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSPFLI_A22                   .
CONTROLS: TCTRL_ZTSPFLI_A22
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSAPLANE_A22                  .
TABLES: *ZSCARR_A22                    .
TABLES: *ZTSFLIGHT_A22                 .
TABLES: *ZTSPFLI_A22                   .
TABLES: ZSAPLANE_A22                   .
TABLES: ZSCARR_A22                     .
TABLES: ZTSFLIGHT_A22                  .
TABLES: ZTSPFLI_A22                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
