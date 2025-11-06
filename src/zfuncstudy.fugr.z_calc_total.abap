FUNCTION Z_CALC_TOTAL.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_PRICE)
*"     REFERENCE(IV_QTY)
*"  EXPORTING
*"     REFERENCE(EV_TOTAL)
*"----------------------------------------------------------------------

ev_total = iv_price * iv_qty * '1.1'. " 부가새 포함.

ENDFUNCTION.
