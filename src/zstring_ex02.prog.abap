*&---------------------------------------------------------------------*
*& Report ZSTRING_EX02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstring_ex02.

" 문자열 합치기
" 기본 구조
*CONCATENATE <문자1> <문자2> ... INTO <결과> [SEPARATED BY <구분자>].

DATA : gv_name   TYPE c LENGTH 10 VALUE 'Taekyung',
       gv_field  TYPE c LENGTH 10 VALUE 'ABAP',
       gv_lang   TYPE c LENGTH 5 VALUE 'KOR',
       gv_result TYPE string.

CONCATENATE gv_name gv_field gv_lang INTO gv_result SEPARATED BY '-'.

WRITE : / '결과 :', gv_result.

" CONCATENATE는 메모리 버퍼를 새로 만들어 각 문자열을 순서대로 복사한다.
" SEPARTED BY를 사용하면 각 요소 사이에 한 번만 구분자를 삽입한다.
" String타입이면 자동으로 길이에 맞춰 동적으로 메모리를 할당한다.

" 문자열 나누기
" SPLIT <문자열> AT <구분자> INTO <변수1> <변수2> ...
data: gv_text type string value 'ABAP-BC-FI-MM',
      gv_mod1 type string,
      gv_mod2 type string,
      gv_mod3 type string,
      gv_mod4 type string.

split gv_text at '-' into gv_mod1 gv_mod2 gv_mod3 gv_mod4.

WRITE: / gv_mod1, gv_mod2, gv_mod3, gv_mod4.

" 원리는 내부적으로 DO ... SERACH ... OFFSET 루프를 돌면서 구분자의 위치를 찾아 각 부분 문자열을 잘라낸다.
" 잘린 문자열은 새로운 메모리 공간에 복사된다.
" 구분자 개수보다 변수가 덕으면 나머지는 마지막 변수에 모두 저장된다.


" 문자열 이동
" SHIFT <문자열> [LEFT|RIGHT] [BY <n> PLACES].
" SHIFT <문자열> UP TO <패턴>.

data gv_shift type string value '----ABAP----'.

SHIFT gv_shift left DELETING LEADING '-'.
WRITE: / gv_shift.

shift gv_shift RIGHT DELETING TRAILING '-'.
WRITE: / gv_shift.

" 시프트는 문자열 내부에서 문자 배열을 이동시키는 연산이다.
" lending, trailing 옵션을 쓰면 해당 문자를 삭제하면서 이동한다.


" 문자열 교체
" REPLACE <패턴> WITH <새문자> INTO <결과> [ALL OCCURRENCES].

DATA gv_text2 type string value 'ABAP is ABAP!'.

REPLACE 'ABAP' WITH 'SAP ABAP' INTO gv_text2.

WRITE: / gv_text2.
