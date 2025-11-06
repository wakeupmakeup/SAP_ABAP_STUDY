*&---------------------------------------------------------------------*
*& Report ZCALL_MSG_DEMO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCALL_MSG_DEMO.

data: gv_price type p DECIMALS 2 value '100',
      gv_qty type i value 0,
      gv_total type p decimals 2.

call function 'Z_CALC_TOTAL'
  EXPORTING
    iv_price = gv_price
    iv_qty = gv_qty
  IMPORTING
    ev_total = gv_total.
