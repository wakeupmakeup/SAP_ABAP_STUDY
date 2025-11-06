*&---------------------------------------------------------------------*
*& Report ZITAB_ADV01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zitab_adv01.
*---------------------------------------------------------------------*
* Internal Table Advanced – Step 1
* 학습목표:
*  (1) READ TABLE: 조건으로 행 검색하고 sy-subrc로 성공/실패 판단
*  (2) TRANSPORTING NO FIELDS: 존재 여부만 빠르게 확인(구조 복사 생략)
*  (3) 표준/핵심 개념: 내부 테이블은 메모리 상 배열 구조, READ는 기본 선형탐색
*---------------------------------------------------------------------*

" 실무에서 성능 최적화와 데이터 가공을 다루는 핵심이다.
" 지금까지 문자열, 날짜, 함수 모듈 보다도 가장 자주 쓰이는 부분이다.

" [A] 샘플 구조와 데이터 준비하기.
" 현업에서는 db에서 select로 읽지만 학습 편의상 하드 코딩으로 한다.

TYPES: BEGIN OF ty_user,
         uname TYPE string, " 사용자 아이디
         dept  TYPE string, " 부서코드
       END OF ty_user.

DATA : gt_user TYPE STANDARD TABLE OF ty_user WITH EMPTY KEY, " 키 없음
       gs_user TYPE ty_user.

DATA gt_dept TYPE STANDARD TABLE OF string.


" 샘플 데이터 적재 하기.
APPEND VALUE #( uname = '태경' dept = 'IT' ) TO gt_user.
APPEND VALUE #( uname = '희진' dept = 'BC' ) TO gt_user.
APPEND VALUE #( uname = '현지' dept = 'HR' ) TO gt_user.

WRITE : / '--- [A] 데이터 적재 완료 ---'.
WRITE : / |행수: { lines( gt_user ) }|.

" [B] READ TABLE - 특정 키로 한 행 가져오기
" - 원리 : 선형 탐색 -> 앞에서부터 조건을 비교한다. 만나면 종료한다.
" - 결과 : sy-subrc = 0 (성공) / 4 (실패)
" 데이터가 많을 때는 sorted, hashed table을 사용하면 탐색 속도가 수십배 빨라진다.

CLEAR gs_user.

READ TABLE gt_user INTO gs_user WITH KEY uname = '현지'.
IF sy-subrc = 0.
  WRITE: / '--- [B] 결과 --- '.
  WRITE: / |찾은 사용자: { gs_user-uname } / 부서: { gs_user-dept }|.
ELSE.
  WRITE: /' --- [B] 결과 미존재 --- '.
ENDIF.

" [C] TRANSPORTING NO FIELDS - 존재 여부만 확인하기 (속도, 메모리 최적화 하는 방법)
" READ TABLE을 쓸 때 행 전체를 읽지 않고 존재 여부만 확인할 때 사용한다.
" 메모리 접근이 최소화 되고 속도가 향상 된다.
READ TABLE gt_user WITH KEY uname = '태경' TRANSPORTING NO FIELDS.
IF sy-subrc = 0.
  WRITE : / ' ---[C] 존재확인 : 태경 존재함 --- '.
ELSE.
  WRITE : / ' ---[C] 존재확인 : 태경 미존재함 --- '.
ENDIF.

" 비교 케이스 : 없는 사용자.
READ TABLE gt_user WITH KEY uname = '미상' TRANSPORTING NO FIELDS.
IF sy-subrc = 0.
  WRITE : / '--- [C] 존재확인: 미상 존재(예상 외) --- '.
ELSE.
  WRITE : / '--- [C] 존재확인 : 미상 미존재(정상) --- '.
ENDIF.


" [D] 요약 출력하기.
ULINE.
WRITE: / '요약) READ는 선형탐색, TRANSPORTING NO FIELDS는 존재 여부만 확인해서 복사 비용 절감'.

" [step 2-a] 정렬 + 인접 중복 제거 실습
gt_dept = VALUE #( ( |IT| ) ( |HR| ) ( |IT| ) ( |FI| ) ( |HR| ) ).

WRITE : / '--- [Step 2-A] 원본 부서 목록(중복 포함) ---'.

LOOP AT gt_dept INTO DATA(lv_dept).
  WRITE : / lv_dept.
ENDLOOP.

" 핵심 로직 : 정렬 + 인접 중복 제거
" delete adjacent duplicates로 인접 중복 제거
SORT gt_dept ASCENDING.
DELETE ADJACENT DUPLICATES FROM gt_dept.

ULINE.
WRITE: / '--- [Step 2-A] 중복 제거 후 (정렬된 상태) --- '.

LOOP AT gt_dept INTO DATA(lv_unique).
  WRITE : / lv_unique.
ENDLOOP.

*--------------------------------------------------------------------*
* part 3
*Loop at GROUP by
*--------------------------------------------------------------------*

" 과거에는 부서별 합계를 구할떄 아래 처럼 했다.
*sort gt_emp by dept.
*loop at gt_emp into gs_emp.
*  at new dept.
*    clear lv_total.
*  endat.
*
*  lv_total += gs_emp-sal.
*
*  at end of dept.
*    WRITE: / gs_emp-dept, lv_total.
*  endat.
* endloop.
*
*그런데 at new, at end of는 가독성이 낮고 순서 의존적이었다.
*그래서 내부적으로는 선형 루프 + 조건 분기로 효율이 떨어진다.
*그래서 abap 7.40 이후 그룹 바이 문법이 도입되었다.
* 이것을 이용하면 루프 한번으로 그룹핑 + 집계가 동시에 가능하다.
* 즉  sort가 필요없고 내부적으로 해시 기반 처리를 할 수 있다.

* --- [step 3] LOOP AT GROUP BY 실습 ===

TYPES: BEGIN OF ty_emp,
         dept TYPE string,
         sal  TYPE i,
       END OF ty_emp.

DATA gt_emp TYPE STANDARD TABLE OF ty_emp WITH EMPTY KEY.

gt_emp = VALUE #(
( dept = 'IT' sal = 3000 )
( dept = 'HR' sal = 2000 )
( dept = 'IT' sal = 4000 )
( dept = 'HR' sal = 2500 )
).

WRITE : / ' -- [Step 3] 부서별 급여 목록 -- '.
LOOP AT gt_emp INTO DATA(ls_emp).
  WRITE : / ls_emp-dept, ls_emp-sal.
ENDLOOP.

ULINE.
WRITE: / '--- [Step 3] 그룹바이로 부서별 합계 구하기 ---'.

" Group By (dept = ls_emp-dept) : 부서별 그룹 생성
" <group> : 현재 그룹 헤더
" <member> : 그룹 안에 개별 행 접근용 필드 심볼
LOOP AT gt_emp INTO ls_emp
  GROUP BY ( dept = ls_emp-dept )
  ASCENDING
  ASSIGNING FIELD-SYMBOL(<group>).

  DATA(lv_total) = 0.

  LOOP AT GROUP <group> ASSIGNING FIELD-SYMBOL(<member>).
    lv_total = lv_total + <member>-sal.
  ENDLOOP.

  WRITE : / <group>-dept, ' 부서 합계 :', lv_total.

ENDLOOP.
