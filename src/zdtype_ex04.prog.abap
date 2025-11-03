*&---------------------------------------------------------------------*
*& Report ZDTYPE_EX04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdtype_ex04.
*1. 데이터를 조회한다.
*2. 특정 행을 수정한다.
*3. 조건에 맞는 행을 삭제한다.
*4. 데이터를 정렬하고 검색한다.


TYPES: BEGIN OF ty_mat,  " 내부 테이블 한 줄의 형태 (구조체)
         matnr   TYPE zmat_cbo-matnr,
         mtart   TYPE zmat_cbo-mtart,
         matdesc TYPE zmat_cbo-matdesc,
         price   TYPE zmat_cbo-price,
       END OF ty_mat.

DATA : gs_mat TYPE ty_mat, " 워크 에어리어 (한줄을 담는 그릇)
       gt_mat TYPE STANDARD TABLE OF ty_mat. " 내부 테이블 (여러 줄 저장하는 리스트)

*즉 ty_mat은 설계도
*  gs_mat은 한 줄
*  gt_mat은 여러 줄 데이터이다.

*--------------------------------------------------------------------*
*  초기 데이터 세팅
*--------------------------------------------------------------------*

gs_mat-matnr = 'Z1001'.
gs_mat-mtart = 'FERT'.
gs_mat-matdesc = '아밥 교재'.
gs_mat-price = '125.50'.
APPEND gs_mat TO gt_mat.

gs_mat-matnr = 'Z1002'.
gs_mat-mtart = 'EXP1'.
gs_mat-matdesc = '아밥 교재2'.
gs_mat-price = '100.00'.
APPEND gs_mat TO gt_mat.

gs_mat-matnr = 'Z1003'.
gs_mat-mtart = 'EXP2'.
gs_mat-matdesc = '아밥 교재3'.
gs_mat-price = '100.22'.
APPEND gs_mat TO gt_mat.

" 내부 테이블의 마지막 줄에 새로운 데이터를 추가한다.
" 이제 메모리 안에 데이터 한줄 한줄이 생기기 시작하는 것이다.


*--------------------------------------------------------------------*
* 3. Read Table (데이터 검색)
*--------------------------------------------------------------------*
DATA gs_found TYPE ty_mat.

READ TABLE gt_mat INTO gs_found WITH KEY matnr = 'Z102'.
" READ TABLE을 할시 무슨일이 생길까?
" 먼저 아밥이 gt_mat의 각 행을 차례로 검사한다.
" 이때 matnr의 값이 'Z1002'인 행을 찾으면 그 행을 gs_found에 담는다. (워크 에어리어)
" 찾았으면 sy-subrc = 0이 되고 못찾으면 4가 된다. 이것은 SAP의 시스템 변수로 성공 여부를 알려주는 return code이다.

IF sy-subrc = 0.
  WRITE: / 'READ 결과:',
         / '자재코드 :', gs_found-matnr,
         / '자재명 :', gs_found-matdesc,
         / '단가:', gs_found-price.
ELSE.
  WRITE: / '해당 자재코드를 찾을 수 없습니다.'.
ENDIF.

*--------------------------------------------------------------------*
* 데이터 수정
*--------------------------------------------------------------------*
READ TABLE gt_mat INTO gs_found WITH KEY matnr = 'Z102'.

IF sy-subrc = 0.
  gs_mat-price = gs_mat-price + 10. " 가격인상
  MODIFY gt_mat FROM gs_mat INDEX sy-tabix. "수정 반영 하기
  " read table이 성공하면 sy-tabix에서는 그 찾은 행 번호가 저장된다.
  " modify는 그 인덱스를 기준으로 그 줄을 바꾼다.
  " 이때 index가 없다면 어떤 줄을 바꿔야할지 모르기 때문에 혼란이 오며 오류가 발생한다.
  WRITE: / 'Z103 단가 인상 완료'.
ENDIF.

*--------------------------------------------------------------------*
*데이터 삭제
*--------------------------------------------------------------------*
DELETE gt_mat WHERE price < 50.
WRITE: / '단가 50 미만 자재 삭제 완료!'.

" 조건에 맞는 모든행을 삭제한다.
" 지금은 단가가 50미만인 자재를 전부 제거한다.
" 삭제 후에는 내부 테이블의 인덱스가 자동으로 재정렬된다.
" LOOP 안에서도 delete gt_mat index sy-tabix 형태로 사용할 수 있다.

*--------------------------------------------------------------------*
* SORT, LOOP 출력
*--------------------------------------------------------------------*
SORT gt_mat BY price DESCENDING.  " 정렬은 내부 테이블의 행 순서를 바꿀 뿐 데이터의 내용은 바꾸지 않는다.
" 지금은 단가 높은 순으로 내림차순 정렬하는 중이다.

WRITE: / '--------------------------------------',
       / '자재코드', 12 '자재유형', 25 '자재명', 50 '단가',
       / '--------------------------------------'.

LOOP AT gt_mat INTO gs_mat.
  WRITE: / gs_mat-matnr, 12 gs_mat-mtart, 25 gs_mat-matdesc, 50 gs_mat-price.
ENDLOOP.

*--------------------------------------------------------------------*
*검색. (이진검색)
*--------------------------------------------------------------------*
DATA gs_search TYPE ty_mat.

SORT gt_mat BY matnr. " 이진 탐색은 정렬이 필요하다.
READ TABLE gt_mat INTO gs_search WITH KEY matnr = 'Z1001' BINARY SEARCH.

" 이진탐색은 반으로 나누면서 탐색하는 방식이다.
" 스탠다드 테이블에서도 사용할 수 있지만 반드시 정렬되어 있어야 한다.

IF sy-subrc = 0.
  WRITE: / '이진 탐색으로 Z1001을 찾음. 가격:', gs_search-price.
ELSE.
  WRITE: / 'Z101 찾을 수 없슴.'.
ENDIF.
