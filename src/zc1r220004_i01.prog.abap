*&---------------------------------------------------------------------*
*& Include          ZC1R220004_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.

  call METHOD : gcl_grid->free( ), gcl_container->free( ).
  free : gcl_grid, gcl_container.
  LEAVE to screen 0.

*  CASE GV_OKCODE.
*    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
*      LEAVE TO SCREEN 0.
*
*  ENDCASE.

ENDMODULE.
