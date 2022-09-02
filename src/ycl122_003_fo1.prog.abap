*&---------------------------------------------------------------------*
*& Include          YCL122_002_FO1
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form REFRESH_GRID_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM REFRESH_GRID_0100 .

  CHECK GR_ALV IS  BOUND.
*  IF GR_ALV IS BOUND.  "= CHECK GR_ALV IS  BOUND.같은 의미 .. 바운드가 되지 않았다면 현재 구간을 나가겠다
*    ELSE.
*      EXIT.           " 현재 이프를 떠나겠다.
*
*  ENDIF.


DATA : LS_STABLE TYPE LVC_S_STBL.
      LS_STABLE-ROW = ABAP_OFF.
      LS_STABLE-COL = ABAP_ON.

  CALL METHOD GR_ALV->REFRESH_TABLE_DISPLAY
    EXPORTING
      IS_STABLE      = LS_STABLE
      I_SOFT_REFRESH = SPACE       " SPACE : 설정된 필터나 정렬 정보를 초기화 한다.
                                   "    X  : 설정된 필터나 정렬 정보를 유지   한다.
    EXCEPTIONS
      FINISHED       = 1
      OTHERS         = 2
.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_OBJECT_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_OBJECT_0100 .

  GR_CON = NEW CL_GUI_CUSTOM_CONTAINER(
    CONTAINER_NAME = 'MY_CONTAINER'
  ).

  GR_ALV = NEW CL_GUI_ALV_GRID(
    I_PARENT = GR_CON
  ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECT_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SELECT_DATA .

REFRESH GT_SCARR.

RANGES LR_CARRID   FOR SCARR-CARRID.    " SELECT-OPTION 과 같은 방식으로 선언. TABLES를 필요로 함.
RANGES LR_CARRNAME FOR SCARR-CARRNAME.   "둘의 차이는 SELECT-OPTIN은 화면에 출력이 되지만 RANGES는 그냥 변수만 선언하는 것.   얘도 마찬가지고 헤더라인 있는 ITAB이다.

IF SCARR-CARRID   IS INITIAL AND
   SCARR-CARRNAME IS INITIAL.

  ELSEIF SCARR-CARRID IS INITIAL.

    LR_CARRNAME-SIGN = 'I'.
    LR_CARRNAME-OPTION = 'EQ'.   " EQ 같음.
    LR_CARRNAME-LOW = SCARR-CARRNAME.
    APPEND LR_CARRNAME.
    CLEAR  LR_CARRNAME.

  ELSEIF SCARR-CARRNAME IS INITIAL.

   LR_CARRID-SIGN = 'I'.
    LR_CARRID-OPTION = 'EQ'.
    LR_CARRID-LOW = SCARR-CARRID.
    APPEND LR_CARRID.
    CLEAR  LR_CARRID.

  ELSE.

      LR_CARRNAME-SIGN = 'I'.
    LR_CARRNAME-OPTION = 'EQ'.   " EQ 같음.
    LR_CARRNAME-LOW = SCARR-CARRNAME.
    APPEND LR_CARRNAME.
    CLEAR  LR_CARRNAME.

       LR_CARRID-SIGN = 'I'.
    LR_CARRID-OPTION = 'EQ'.
    LR_CARRID-LOW = SCARR-CARRID.
    APPEND LR_CARRID.
    CLEAR  LR_CARRID.


ENDIF.

*   SELECT *
*    FROM  SCARR
*   WHERE CARRID IN @LR_CARRID
*     AND CARRNAME IN @LR_CARRNAME
*    INTO TABLE @GT_SCARR.

   SELECT *
    FROM  SCARR
   WHERE CARRID IN @S_CARRID
     AND CARRNAME IN @S_CARRNM
    INTO TABLE @GT_SCARR.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_LAYOUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_LAYOUT .

  CLEAR GS_LAYOUT.

  GS_LAYOUT-ZEBRA = 'X'.
  GS_LAYOUT-SEL_MODE = 'D'.
  GS_LAYOUT-CWIDTH_OPT = 'X'.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_ALV_FIELDCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_ALV_FIELDCAT .

DATA :LT_FIELDCAT TYPE KKBLO_T_FIELDCAT.

CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
  EXPORTING
    I_CALLBACK_PROGRAM     =  SY-REPID            " Internal table declaration program
*    I_TABNAME             =                  " Name of table to be displayed
    I_STRUCNAME            =  'SCARR'
    I_INCLNAME             =  SY-REPID
    I_BYPASSING_BUFFER     =  ABAP_ON              " Ignore buffer while reading
    I_BUFFER_ACTIVE        =  ABAP_OFF
  CHANGING
    CT_FIELDCAT            =  LT_FIELDCAT           " Field Catalog with Field Descriptions
  EXCEPTIONS
    INCONSISTENT_INTERFACE = 1
    OTHERS                 = 2
  .
IF LT_FIELDCAT[] IS INITIAL.
  MESSAGE 'ALV 필드카탈로그 구성이 실패했습니다' TYPE 'E'.
  ELSE.
    CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
      EXPORTING
*        I_TECH_COMPLETE           =
*        I_STRUCTURE_NAME          =
        IT_FIELDCAT_KKBLO         = LT_FIELDCAT
      IMPORTING
        ET_FIELDCAT_LVC           = GT_FCAT
      EXCEPTIONS
        IT_DATA_MISSING           = 1
        OTHERS                    = 2
      .

ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_100 .

 CALL METHOD GR_ALV->SET_TABLE_FOR_FIRST_DISPLAY
   EXPORTING
     IS_LAYOUT                     = GS_LAYOUT
   CHANGING
     IT_OUTTAB                     = GT_SCARR[]
     IT_FIELDCATALOG               = GT_FCAT[]
   EXCEPTIONS
     INVALID_PARAMETER_COMBINATION = 1
     PROGRAM_ERROR                 = 2
     TOO_MANY_LINES                = 3
     OTHERS                        = 4
         .


ENDFORM.
