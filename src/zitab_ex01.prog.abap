*&---------------------------------------------------------------------*
*& Report ZITAB_EX01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zitab_ex01.

" 학습 목표
" 스탠다드 테이블 이해 -> 기본 선형 탐색 방식
" 정렬 테이블 이해   -> 정렬 + 이진 탐색
" 해시 테이블 이해   -> Key 기반 해시 탐색
" 성능차이 실습     -> READ 속도 및 Key 중봅 차이 체험하기.

" 개념 정리.
" 스탠다드.
" 삽입 순서 그대로 저장한다. 탐색 방식은 선형 탐색이다. 중복 가능. 사용 목적으로는 Loop 중심,. 순차처리
" Sorted 항상 Key 기준 정렬, 이진 탐색. 중복은 가능 또는 불가. 빠른 검색 + 정렬 유지
" 해시 Hash 알고리즘으로 관리함. 해시 탐색. 중복 불가. Key 기반 고속 검색

" 1. CBO 자재 구조 참조하기.
TYPES: BEGIN OF ty_mat,
         matnr TYPE zmat_cbo-matnr,
         price TYPE zmat_cbo-price,
       END OF ty_mat.

DATA: gs_mat TYPE ty_mat.

" 3가지 형태의 내부 테이블 선언하기.
DATA: gt_std  TYPE STANDARD TABLE OF ty_mat,
      gt_sort TYPE SORTED TABLE OF ty_mat WITH UNIQUE KEY matnr,
      gt_hash TYPE HASHED TABLE OF ty_mat WITH UNIQUE KEY matnr.

" 2. 데이터 입력
gs_mat-matnr = 'Z1001'.
gs_mat-price = '120.50'.
APPEND gs_mat TO gt_std.

gs_mat-matnr = 'Z1002'.
gs_mat-price = '99.90'.
APPEND gs_mat TO gt_std.

gs_mat-matnr = 'Z1003'.
gs_mat-price = '35.20'.
APPEND gs_mat TO gt_std.

" 스탠다드 -> Sorted, HASH 에도 동일 데이터 삽입하기.
LOOP AT gt_std INTO gs_mat.
  INSERT gs_mat INTO TABLE gt_sort.
  INSERT gs_mat INTO TABLE gt_hash.
ENDLOOP.

WRITE: / '--- 데이터 입력 완료 ---'.

" 3. READ 비교하기
DATA gs_found TYPE ty_mat.
*DATA gv_start TYPE i VALUE sy-uzeit. "시작시간 저장용

WRITE: /,
       / '--- READ TABLE 비교 ---'.

" 스탠다드 테이블 : 선형 탐색
READ TABLE gt_std INTO gs_found WITH KEY matnr = 'Z1002'.
WRITE: / '스탠다드 테이블->', gs_found-matnr, gs_found-price.

" Sorted 테이블 : 이진탐색
READ TABLE gt_sort INTO gs_found WITH KEY matnr = 'Z1002'.
WRITE: / '정렬 테이블->', gs_found-matnr, gs_found-price.

" hash 테이블 : 해시탐색
READ TABLE gt_hash INTO gs_found WITH KEY matnr = 'Z1002'.
WRITE: / '해시 테이블 ->', gs_found-matnr, gs_found-price.

" 4. 중복 테스트

WRITE: /,
       / '--- 종복 입력 테스트 ---'.

CLEAR gs_mat.
gs_mat-matnr = 'Z1001'.
gs_mat-price = '130.00'.

WRITE: / '스탠다드 테이블 중복 가능?'.
append gs_mat to gt_std.
WRITE: / ' -> OK'.

WRITE: / 'Sotred 테이블 중복 가능?'.
insert gs_mat into table gt_sort.
WRITE: /' -> 오류 발생 안함. (중복 key 허용시)'.

WRITE: / 'Hash 테이블 중복 가능?'.
insert gs_mat into table gt_hash.
if sy-subrc <> 0.
  WRITE : / '중복 불가! sy-subrc:', sy-subrc.
endif.

" 새롭게 안 사실.
" sort와 hash에서는 append를 사용하면 오류가 난다.
" 이 테이블은 인덱스가 없다거나 자동 정렬처리가 되는데 그래서 append 대신 insert into를 사용해야 한다.

" 다시 정리하는 내부 테이블 3종 개념
" 1. 스탠다드 테이블
" 저장/정렬: 삽입 순서 그대로(정렬 유지 X)
" 인덱스 있음. 따라서 read tablew, modify index, loop from to 사용 가능.
" key : 지정은 할 수 있지만 유일성은 강제되지 않음.
" 탐색 성능 : 기본은 선형 탐색 O(n). 정렬해 둔뒤 이진탐색으로 쓰면 O(log n).
" 대표 용도 : 순차 처리, ALV 덤프, 간단 목록.

" 2. Sorted table
" 저장/정렬 : 항상 키 기준으로 자동 정렬
" 인덱스 있음 (정렬된 순서의 인덱스) -> read index, modify index는 가능한데 정렬 기준이 바뀌면 인덱스 의미도 바뀐다.
" Key : 중복 불가 또는 중봅 허용 둘다 가능.
" 탐색 성능 : 키로 read 하면 성능은 O(log n)
" 대표 용도 : 정렬 보존 + 빠른 키 검색이 동시에 필요한 목록.

" 3. Hashed table
" 인덱스 : 없음.
" READ table, MODIFY INDEX, APPEND, LOOP FROM / TO 전부 불가.
" key : 반드시 UNIQUE KEY (중복 불가)
" 탐색 성능: 키로 READ시 해시 탐색 O(1) 수준임.
" 대표 용도 : 키 중복을 막으면서 매우 빠른 조회가 필요할 때 사용한다.

" APPEND와 INSERT 차이
" APPEND는 마지막에 하나를 붙인다. 그러므로 암묵적으로 인덱스에 의존한다.
" 스탠다드 테이블에만 적용되는데 그 이유는 정렬이나 해시 테이블 같은 경우 구조상 마지막 개념이 모순이므로 금지한다.


" insert
" 테이블에 한 행을 넣어라 라는 의미. (테이블 타입에 맞는 규칙으로 들어감).
" 허용: 세타입 모두 허용한다.
" 스탠다드 : 사실상 끝에 추가와 같다. 또는 특정 위치를 가르킬 수도 있다.
" 정렬 : 키 순서에 맞는 위치로 자동 삽입된다.
" 해시 : 해시 키로 삽입 된다. 단, 중복이면 안된다.
