*&---------------------------------------------------------------------*
*& Report ZSTRING_EX03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSTRING_EX03.

" 공백 정리
" condense <문자열> [no-gaps].
" 기본은 연속된 공백을 한칸으로 축소 하는 것이다.
" 이때 no-gaps는 모든 공백을 삭제한다.

data: gv_text type string value '    abap   is greate    '.

condense gv_text.
WRITE : / 'CONDENSE 기본 :', gv_text.

gv_text = '  abap is great '.
condense gv_text no-gaps.
WRITE : / 'CONDENSE 전부 공백 제거:', gv_text.

" 원리
" 문자열에서 왼쪽에서 오른쪽으로 스캔하며 공백을 카운트한다.
" 첫 번쨰 공백만 유지하고 나머지는 삭제한다.
" no-gaps일 경우 모든 공백을 제거한다.

" 대소문자 변환하기
data gv_name type string value 'abap programming'.

TRANSlate gv_name to upper case.
WRITE : / '대문자 변환:', gv_name.

TRANSLATE gv_name to LOWER CASE.
WRITE : / '소문자 변환:', gv_name.

" 원리 설명
" abap 내부적으로 유니코드 표준 테이블을 참조해 각 문자 코드를 변환한다.
" sap 시스템의 언어 설정에 따라 특수문자 변환 규칙이 다를 수 있다.


" 문자열 검색

data gv_text2 type string value 'SAP ABAP Programming'.
data gv_offset type i.
data gv_len type i.

" 공백 무시하고 검색
SEARCH gv_text2 FOR 'ABAP'.


" 문자열 길이 확인

data gv_len2 type string value '아밥은 짱이야'.
data gv_length type i.

gv_length = strlen( gv_len2 ).
WRITE : / '문자열 길이:', gv_length.
