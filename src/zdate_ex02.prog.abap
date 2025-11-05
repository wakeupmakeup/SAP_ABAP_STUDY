*&---------------------------------------------------------------------*
*& Report ZDATE_EX02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDATE_EX02.

" SAP는 국가별/ 사용자 별로 날짜 포맷이 다르기 때문에 당야한 형식이 자동 변환된다.
" 이것을 직접 제어할 수 있어야 한다.

data: gv_date type d,
      gv_text type c length 20.

gv_date = sy-datum.

" 1. 기본 출력
" 여기서 로컬 자동 포맷 적용이 일어 난다.
" 사용자의 언어 설정에 맞게 자동으로 변환이 된다.
WRITE : / '기본 형식:', gv_date.

" 2. 사용자 로컬 형식 (자동 변환됨)
WRITE : / '사용자 포맷 방식:', gv_date using edit mask '__.__.____'.

" 3. write to 구문 (문자열로 변환)
WRITE gv_date to gv_text using edit mask '____/__/__'.
WRITE: / 'write to 형식:', gv_text.

" 4. reverse 변환 (문자->날짜)
gv_text = '2025/12/25'.
WRITE gv_text to gv_date using edit mask '____/__/__'.
WRITE: / '문자 -> 날짜 변환 결과:', gv_date.

" 원리 알아보기
" ABAP의 모든 날짜 타입은 내부적으로 YYYYMMDD로 저장된다.
" 포맷팅은 단지 출력 시 버퍼를 이용해 마스크를 입히는 과정이다.
" WRITE TO는 출력 대신 결과를 변수에 저장하는 WRITE 구문이다.
" USING EDIT MASK는 출력 자리 마다 문자 패턴을 적용하는 포맷을 지정한다.
