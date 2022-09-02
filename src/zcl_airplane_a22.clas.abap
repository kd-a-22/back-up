class ZCL_AIRPLANE_A22 definition
  public
  final
  create public .

public section.

  methods DISPLAY_ATTRIBUTE .
  class-methods CLASSCONSTRUCTOR .
  methods CONSTRUCTOR
    importing
      !IV_NAME type STRING
      !IV_PLANETYPE type SAPLANE-PLANETYPE
    exceptions
      WRONG_PLANETYPE .
  class-methods DISPLAY_N_O_AIRPLANES .
protected section.
private section.

  class-data C_POS_1 type I value 30 ##NO_TEXT.
  data MV_NAME type STRING .
  data MV_PLANETYPE type SAPLANE-PLANETYPE .
  data MV_WEIGHT type SAPLANE-WEIGHT .
  data MV_TANKCAP type SAPLANE-TANKCAP .
  class-data GV_N_O_AIRPLANES type I .
  class-data MT_PLANETYPES type TY_PLANETYPES .
ENDCLASS.



CLASS ZCL_AIRPLANE_A22 IMPLEMENTATION.


  method CLASSCONSTRUCTOR.

    SELECT * INTO TABLE MT_PLANEtypes FROM saplane.


  endmethod.


  method CONSTRUCTOR.


    mv_name = iv_name.
    mv_planetype = iv_planetype.

    DATA : ls_planetype TYPE saplane.

    READ TABLE mt_planetypes INTO ls_planetype
           WITH KEY planetype = iv_planetype.


    IF sy-subrc EQ 0.
      gv_n_o_airplanes =  gv_n_o_airplanes + 1.
      mv_weight = ls_planetype-weight.
      mv_tankcap = ls_planetype-tankcap.
    ELSE.


      RAISE wrong_planetype.

    ENDIF.


  endmethod.


  method DISPLAY_ATTRIBUTE.
     WRITE : / icon_ws_plane AS ICON ,
        / 'Name of airplane', AT c_pos_1 mv_name,
        / 'Type of airplane', AT c_pos_1 mv_planetype,
        / 'Weight/Tank capacity'          , AT c_pos_1 mv_weight,  mv_tankcap.


  endmethod.


  method DISPLAY_N_O_AIRPLANES.

      WRITE : / 'Number of Airplanes', AT c_pos_1 gv_n_o_airplanes.
  endmethod.
ENDCLASS.
