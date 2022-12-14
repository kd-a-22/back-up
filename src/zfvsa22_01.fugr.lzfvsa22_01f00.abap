*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSA2203........................................*
FORM GET_DATA_ZVSA2203.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSA2201 WHERE
(VIM_WHERETAB) .
    CLEAR ZVSA2203 .
ZVSA2203-MANDT =
ZTSA2201-MANDT .
ZVSA2203-PERNR =
ZTSA2201-PERNR .
ZVSA2203-ENAME =
ZTSA2201-ENAME .
ZVSA2203-ENTDT =
ZTSA2201-ENTDT .
ZVSA2203-GENDER =
ZTSA2201-GENDER .
ZVSA2203-DEPID =
ZTSA2201-DEPID .
<VIM_TOTAL_STRUC> = ZVSA2203.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVSA2203 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSA2203.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSA2203-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTSA2201 WHERE
  PERNR = ZVSA2203-PERNR .
    IF SY-SUBRC = 0.
    DELETE ZTSA2201 .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTSA2201 WHERE
  PERNR = ZVSA2203-PERNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSA2201.
    ENDIF.
ZTSA2201-MANDT =
ZVSA2203-MANDT .
ZTSA2201-PERNR =
ZVSA2203-PERNR .
ZTSA2201-ENAME =
ZVSA2203-ENAME .
ZTSA2201-ENTDT =
ZVSA2203-ENTDT .
ZTSA2201-GENDER =
ZVSA2203-GENDER .
ZTSA2201-DEPID =
ZVSA2203-DEPID .
    IF SY-SUBRC = 0.
    UPDATE ZTSA2201 ##WARN_OK.
    ELSE.
    INSERT ZTSA2201 .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVSA2203-UPD_FLAG,
STATUS_ZVSA2203-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZVSA2203.
  SELECT SINGLE * FROM ZTSA2201 WHERE
PERNR = ZVSA2203-PERNR .
ZVSA2203-MANDT =
ZTSA2201-MANDT .
ZVSA2203-PERNR =
ZTSA2201-PERNR .
ZVSA2203-ENAME =
ZTSA2201-ENAME .
ZVSA2203-ENTDT =
ZTSA2201-ENTDT .
ZVSA2203-GENDER =
ZTSA2201-GENDER .
ZVSA2203-DEPID =
ZTSA2201-DEPID .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSA2203 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSA2203-PERNR TO
ZTSA2201-PERNR .
MOVE ZVSA2203-MANDT TO
ZTSA2201-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA2201'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA2201 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA2201'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*...processing: ZVSA2204........................................*
FORM GET_DATA_ZVSA2204.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSA2202_1 WHERE
(VIM_WHERETAB) .
    CLEAR ZVSA2204 .
ZVSA2204-MANDT =
ZTSA2202_1-MANDT .
ZVSA2204-DEPID =
ZTSA2202_1-DEPID .
ZVSA2204-PHONE =
ZTSA2202_1-PHONE .
    SELECT SINGLE * FROM ZTSA2202_T WHERE
DEPID = ZTSA2202_1-DEPID AND
SPRAS = SY-LANGU .
    IF SY-SUBRC EQ 0.
ZVSA2204-DTEXT =
ZTSA2202_T-DTEXT .
    ENDIF.
<VIM_TOTAL_STRUC> = ZVSA2204.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVSA2204 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSA2204.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSA2204-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTSA2202_1 WHERE
  DEPID = ZVSA2204-DEPID .
    IF SY-SUBRC = 0.
    DELETE ZTSA2202_1 .
    ENDIF.
    DELETE FROM ZTSA2202_T WHERE
    DEPID = ZTSA2202_1-DEPID .
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTSA2202_1 WHERE
  DEPID = ZVSA2204-DEPID .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSA2202_1.
    ENDIF.
ZTSA2202_1-MANDT =
ZVSA2204-MANDT .
ZTSA2202_1-DEPID =
ZVSA2204-DEPID .
ZTSA2202_1-PHONE =
ZVSA2204-PHONE .
    IF SY-SUBRC = 0.
    UPDATE ZTSA2202_1 ##WARN_OK.
    ELSE.
    INSERT ZTSA2202_1 .
    ENDIF.
    SELECT SINGLE FOR UPDATE * FROM ZTSA2202_T WHERE
    DEPID = ZTSA2202_1-DEPID AND
    SPRAS = SY-LANGU .
      IF SY-SUBRC <> 0.   "insert preprocessing: init WA
        CLEAR ZTSA2202_T.
ZTSA2202_T-DEPID =
ZTSA2202_1-DEPID .
ZTSA2202_T-SPRAS =
SY-LANGU .
      ENDIF.
ZTSA2202_T-DTEXT =
ZVSA2204-DTEXT .
    IF SY-SUBRC = 0.
    UPDATE ZTSA2202_T ##WARN_OK.
    ELSE.
    INSERT ZTSA2202_T .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVSA2204-UPD_FLAG,
STATUS_ZVSA2204-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZVSA2204.
  SELECT SINGLE * FROM ZTSA2202_1 WHERE
DEPID = ZVSA2204-DEPID .
ZVSA2204-MANDT =
ZTSA2202_1-MANDT .
ZVSA2204-DEPID =
ZTSA2202_1-DEPID .
ZVSA2204-PHONE =
ZTSA2202_1-PHONE .
    SELECT SINGLE * FROM ZTSA2202_T WHERE
DEPID = ZTSA2202_1-DEPID AND
SPRAS = SY-LANGU .
    IF SY-SUBRC EQ 0.
ZVSA2204-DTEXT =
ZTSA2202_T-DTEXT .
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVSA2204-DTEXT .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSA2204 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSA2204-DEPID TO
ZTSA2202_1-DEPID .
MOVE ZVSA2204-MANDT TO
ZTSA2202_1-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA2202_1'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA2202_1 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA2202_1'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

MOVE ZTSA2202_1-DEPID TO
ZTSA2202_T-DEPID .
MOVE SY-LANGU TO
ZTSA2202_T-SPRAS .
MOVE ZVSA2204-MANDT TO
ZTSA2202_T-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA2202_T'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA2202_T TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA2202_T'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*...processing: ZVSA2205........................................*
FORM GET_DATA_ZVSA2205.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSA22_PRO WHERE
(VIM_WHERETAB) .
    CLEAR ZVSA2205 .
ZVSA2205-MANDT =
ZTSA22_PRO-MANDT .
ZVSA2205-PCODE =
ZTSA22_PRO-PCODE .
ZVSA2205-PKIND =
ZTSA22_PRO-PKIND .
ZVSA2205-PCOST =
ZTSA22_PRO-PCOST .
ZVSA2205-WAERS =
ZTSA22_PRO-WAERS .
ZVSA2205-PCHAR =
ZTSA22_PRO-PCHAR .
<VIM_TOTAL_STRUC> = ZVSA2205.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVSA2205 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSA2205.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSA2205-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTSA22_PRO WHERE
  PCODE = ZVSA2205-PCODE .
    IF SY-SUBRC = 0.
    DELETE ZTSA22_PRO .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTSA22_PRO WHERE
  PCODE = ZVSA2205-PCODE .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSA22_PRO.
    ENDIF.
ZTSA22_PRO-MANDT =
ZVSA2205-MANDT .
ZTSA22_PRO-PCODE =
ZVSA2205-PCODE .
ZTSA22_PRO-PKIND =
ZVSA2205-PKIND .
ZTSA22_PRO-PCOST =
ZVSA2205-PCOST .
ZTSA22_PRO-WAERS =
ZVSA2205-WAERS .
ZTSA22_PRO-PCHAR =
ZVSA2205-PCHAR .
    IF SY-SUBRC = 0.
    UPDATE ZTSA22_PRO ##WARN_OK.
    ELSE.
    INSERT ZTSA22_PRO .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVSA2205-UPD_FLAG,
STATUS_ZVSA2205-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZVSA2205.
  SELECT SINGLE * FROM ZTSA22_PRO WHERE
PCODE = ZVSA2205-PCODE .
ZVSA2205-MANDT =
ZTSA22_PRO-MANDT .
ZVSA2205-PCODE =
ZTSA22_PRO-PCODE .
ZVSA2205-PKIND =
ZTSA22_PRO-PKIND .
ZVSA2205-PCOST =
ZTSA22_PRO-PCOST .
ZVSA2205-WAERS =
ZTSA22_PRO-WAERS .
ZVSA2205-PCHAR =
ZTSA22_PRO-PCHAR .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSA2205 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSA2205-PCODE TO
ZTSA22_PRO-PCODE .
MOVE ZVSA2205-MANDT TO
ZTSA22_PRO-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA22_PRO'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA22_PRO TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA22_PRO'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*...processing: ZVSA2299........................................*
FORM GET_DATA_ZVSA2299.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSA2299 WHERE
(VIM_WHERETAB) .
    CLEAR ZVSA2299 .
ZVSA2299-MANDT =
ZTSA2299-MANDT .
ZVSA2299-LIFNR =
ZTSA2299-LIFNR .
ZVSA2299-LAND1 =
ZTSA2299-LAND1 .
ZVSA2299-NAMD1 =
ZTSA2299-NAMD1 .
ZVSA2299-NAMD2 =
ZTSA2299-NAMD2 .
ZVSA2299-VWNCA =
ZTSA2299-VWNCA .
ZVSA2299-CARRID =
ZTSA2299-CARRID .
ZVSA2299-MEALNUMBER =
ZTSA2299-MEALNUMBER .
ZVSA2299-PRICE =
ZTSA2299-PRICE .
ZVSA2299-WEARS =
ZTSA2299-WEARS .
<VIM_TOTAL_STRUC> = ZVSA2299.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVSA2299 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSA2299.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSA2299-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTSA2299 WHERE
  LIFNR = ZVSA2299-LIFNR .
    IF SY-SUBRC = 0.
    DELETE ZTSA2299 .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTSA2299 WHERE
  LIFNR = ZVSA2299-LIFNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSA2299.
    ENDIF.
ZTSA2299-MANDT =
ZVSA2299-MANDT .
ZTSA2299-LIFNR =
ZVSA2299-LIFNR .
ZTSA2299-LAND1 =
ZVSA2299-LAND1 .
ZTSA2299-NAMD1 =
ZVSA2299-NAMD1 .
ZTSA2299-NAMD2 =
ZVSA2299-NAMD2 .
ZTSA2299-VWNCA =
ZVSA2299-VWNCA .
ZTSA2299-CARRID =
ZVSA2299-CARRID .
ZTSA2299-MEALNUMBER =
ZVSA2299-MEALNUMBER .
ZTSA2299-PRICE =
ZVSA2299-PRICE .
ZTSA2299-WEARS =
ZVSA2299-WEARS .
    IF SY-SUBRC = 0.
    UPDATE ZTSA2299 ##WARN_OK.
    ELSE.
    INSERT ZTSA2299 .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVSA2299-UPD_FLAG,
STATUS_ZVSA2299-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZVSA2299.
  SELECT SINGLE * FROM ZTSA2299 WHERE
LIFNR = ZVSA2299-LIFNR .
ZVSA2299-MANDT =
ZTSA2299-MANDT .
ZVSA2299-LIFNR =
ZTSA2299-LIFNR .
ZVSA2299-LAND1 =
ZTSA2299-LAND1 .
ZVSA2299-NAMD1 =
ZTSA2299-NAMD1 .
ZVSA2299-NAMD2 =
ZTSA2299-NAMD2 .
ZVSA2299-VWNCA =
ZTSA2299-VWNCA .
ZVSA2299-CARRID =
ZTSA2299-CARRID .
ZVSA2299-MEALNUMBER =
ZTSA2299-MEALNUMBER .
ZVSA2299-PRICE =
ZTSA2299-PRICE .
ZVSA2299-WEARS =
ZTSA2299-WEARS .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSA2299 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSA2299-LIFNR TO
ZTSA2299-LIFNR .
MOVE ZVSA2299-MANDT TO
ZTSA2299-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA2299'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA2299 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA2299'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
