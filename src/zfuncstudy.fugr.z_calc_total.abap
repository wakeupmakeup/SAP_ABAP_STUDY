FUNCTION Z_CALC_TOTAL.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_PRICE)
*"     REFERENCE(IV_QTY)
*"  EXPORTING
*"     REFERENCE(EV_TOTAL)
*"  EXCEPTIONS
*"      QTY_ZERO
*"      PRICE_ZERO
*"----------------------------------------------------------------------

" 예외 정의
" 1) qty_zero : 수량이 0일때
" 2) price_zero : 단가가 0일때

if iv_qty = 0.
*RAISE qty_zero.
  MESSAGE e001(zmsg_demo). " 수량이 0입니다.
ELSEIF iv_price = 0.
*  raise price_zero.
  MESSAGE e002(zmsg_demo). "단가가 0입니다.
endif.

ev_total = iv_price * iv_qty * '1.1'. " 부가새 포함.
message s003(zmsg_demo). " 계산 완료

ENDFUNCTION.
