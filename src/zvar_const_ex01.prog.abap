*&---------------------------------------------------------------------*
*& Report ZVAR_CONST_EX01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvar_const_ex01.
" 이제부터는 챕터 2에서 데이터의 구조와 그릇 모양을 배웠다면
" 이번에는 그 그릇 안에 값을 담고 유지하거나 바꾸는 방법을 배운다.

" 변수 - 실행 중 값이 변하는 데이터
" 상수 - 프로그램이 실행 동안 값이 바뀌지 않는 데이터
" value 구문 - 선언시 초기값 설정하기
" 메모리와 생명주기 - 변수의 존재 범위를 이해해야함.

" 변수 선언하기
DATA gv_price TYPE p DECIMALS 2 VALUE '100.00'. "상품 단가
DATA gv_qty TYPE i VALUE 3. " 수량
DATA gv_total TYPE p DECIMALS 2. " 총액

" 상수 선언하기
CONSTANTS gc_tax_rate TYPE p DECIMALS 2 VALUE '0.10'. "부가세율(10%)
CONSTANTS gv_currency TYPE c LENGTH 3 VALUE 'KRW'. " 통화단위

" 계산 로직
gv_total = gv_price * gv_qty * ( 1 + gc_tax_rate ).

" 출력
WRITE : / '단가: ', gv_price,
        / '수량: ', gv_qty,
*        / '부가세율:', gc_tax_rate * 100, '%', " 오류임 상수는 변경불가
        / '총액:', gv_total,
        / '통화:', gv_currency.

" 변수 값 변경 테스트
gv_qty = gv_qty + 2.
*WRITE :/,
*       / '수량 변경 후 총액:', gv_price * gv_qty * ( 1 + gc_tax_rate ).

" data로 만든 변수는 RAM에 저장되고 실행 중 계속 변한다.
" 상수는 프로그램 로딩 시 고정 값으로 메모리에 올라간다.
