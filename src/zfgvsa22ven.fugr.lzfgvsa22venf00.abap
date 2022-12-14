*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSA22VEN.......................................*
FORM GET_DATA_ZVSA22VEN.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSA22VEN WHERE
(VIM_WHERETAB) .
    CLEAR ZVSA22VEN .
ZVSA22VEN-MANDT =
ZTSA22VEN-MANDT .
ZVSA22VEN-LIFNR =
ZTSA22VEN-LIFNR .
ZVSA22VEN-LAND1 =
ZTSA22VEN-LAND1 .
ZVSA22VEN-NAME1 =
ZTSA22VEN-NAME1 .
ZVSA22VEN-NAME2 =
ZTSA22VEN-NAME2 .
ZVSA22VEN-VENCA =
ZTSA22VEN-VENCA .
ZVSA22VEN-CARRID =
ZTSA22VEN-CARRID .
ZVSA22VEN-MEALNO =
ZTSA22VEN-MEALNO .
ZVSA22VEN-PRICE =
ZTSA22VEN-PRICE .
ZVSA22VEN-WEARS =
ZTSA22VEN-WEARS .
<VIM_TOTAL_STRUC> = ZVSA22VEN.
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
FORM DB_UPD_ZVSA22VEN .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSA22VEN.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSA22VEN-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZTSA22VEN WHERE
  LIFNR = ZVSA22VEN-LIFNR .
    IF SY-SUBRC = 0.
    DELETE ZTSA22VEN .
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
  SELECT SINGLE FOR UPDATE * FROM ZTSA22VEN WHERE
  LIFNR = ZVSA22VEN-LIFNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSA22VEN.
    ENDIF.
ZTSA22VEN-MANDT =
ZVSA22VEN-MANDT .
ZTSA22VEN-LIFNR =
ZVSA22VEN-LIFNR .
ZTSA22VEN-LAND1 =
ZVSA22VEN-LAND1 .
ZTSA22VEN-NAME1 =
ZVSA22VEN-NAME1 .
ZTSA22VEN-NAME2 =
ZVSA22VEN-NAME2 .
ZTSA22VEN-VENCA =
ZVSA22VEN-VENCA .
ZTSA22VEN-CARRID =
ZVSA22VEN-CARRID .
ZTSA22VEN-MEALNO =
ZVSA22VEN-MEALNO .
ZTSA22VEN-PRICE =
ZVSA22VEN-PRICE .
ZTSA22VEN-WEARS =
ZVSA22VEN-WEARS .
    IF SY-SUBRC = 0.
    UPDATE ZTSA22VEN ##WARN_OK.
    ELSE.
    INSERT ZTSA22VEN .
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
CLEAR: STATUS_ZVSA22VEN-UPD_FLAG,
STATUS_ZVSA22VEN-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ENTRY_ZVSA22VEN.
  SELECT SINGLE * FROM ZTSA22VEN WHERE
LIFNR = ZVSA22VEN-LIFNR .
ZVSA22VEN-MANDT =
ZTSA22VEN-MANDT .
ZVSA22VEN-LIFNR =
ZTSA22VEN-LIFNR .
ZVSA22VEN-LAND1 =
ZTSA22VEN-LAND1 .
ZVSA22VEN-NAME1 =
ZTSA22VEN-NAME1 .
ZVSA22VEN-NAME2 =
ZTSA22VEN-NAME2 .
ZVSA22VEN-VENCA =
ZTSA22VEN-VENCA .
ZVSA22VEN-CARRID =
ZTSA22VEN-CARRID .
ZVSA22VEN-MEALNO =
ZTSA22VEN-MEALNO .
ZVSA22VEN-PRICE =
ZTSA22VEN-PRICE .
ZVSA22VEN-WEARS =
ZTSA22VEN-WEARS .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSA22VEN USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSA22VEN-LIFNR TO
ZTSA22VEN-LIFNR .
MOVE ZVSA22VEN-MANDT TO
ZTSA22VEN-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSA22VEN'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSA22VEN TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSA22VEN'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
