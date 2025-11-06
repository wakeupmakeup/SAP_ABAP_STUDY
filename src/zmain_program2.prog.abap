*&---------------------------------------------------------------------*
*& Report ZMAIN_PROGRAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMAIN_PROGRAM2.

" 예외처리가 필요한 이유
" 계산용 함수 모듈이 있다고 하자. 그런데 수량이 0이면 0으로 나눌 수 없음이 난다.
" 이런 상황을 단순하게 write 처리해서 error로 처리하면 호출한 쪽은 오류를 감지하지 못한다.
" 그래서 함수 모듈 내부에서 예외를 던지고 (ralse), 호출한 프로그램에서 잡아야(exceptions)
" 한다.

INCLUDE ZMAIN2_TOP.
*include zmain_top.
INCLUDE ZMAIN2_F01.
*include zmain_f01.

START-OF-SELECTION.
perform calc_total.


INCLUDE ZMAIN2_O01.
*include zmain_o01.
INCLUDE ZMAIN2_I01.
*INCLUDE zmain_i01.
