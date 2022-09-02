class ZCL_IM_BADI_BOOK22_A22 definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_BOOK22 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BADI_BOOK22_A22 IMPLEMENTATION.


  method IF_EX_BADI_BOOK22~CHANGE_VLINE.

c_pos = c_pos + 37.

  endmethod.


  method IF_EX_BADI_BOOK22~OUTPUT.
    data : name type s_custname.
    select SINGLE name from scustom INTO name
      WHERE id = i_booking-customid.
      WRITE : name, i_booking-order_date.

  endmethod.
ENDCLASS.
