*&---------------------------------------------------------------------*
*& Include          ZMAIN_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CALC_TOTAL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM calc_total .

*  gv_total = gv_price * gv_qty.
*  WRITE : / '출력 :', gv_total.

  " 위 처럼 할 수도 있지만 함수 모듈을 만들어서 코드를 재사용할 수 있게 할 수 있다
  CALL FUNCTION 'Z_CALC_TOTAL'
    EXPORTING
      iv_price   = gv_price
      iv_qty     = gv_qty
    IMPORTING
      ev_total   = gv_total
    EXCEPTIONS
      qty_zero   = 1
      price_zero = 2
      OTHERS     = 3.

  CASE sy-subrc.
    WHEN 0.
      WRITE : / '정상 실행 결과:', gv_total.
    WHEN 1.
      WRITE : /'오류 : 수량이 0입니다.'.
    WHEN 2.
      WRITE : /'오류 : 단가가 0입니다.'.
    WHEN OTHERS.
      WRITE : /'알 수 없는 오류 발생'.
  ENDCASE.


  " exception에서 1,2,3 이 값은 sy-subrc로 받는 값을 의미한다.
  " raise는 오류를 프로그램적으로 전달하고 메시지는 오류를 화면에 표시한다.
  " 그리고 이 들은 함께 사용이 가능하다.

ENDFORM.
