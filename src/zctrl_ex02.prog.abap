*&---------------------------------------------------------------------*
*& Report ZCTRL_EX02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zctrl_ex02.
" IF, CASE 조건문 실전 적용
" LOOP 활용
" 누적 계산
" CONTINUE, EXIT 활용

" 1. 데이터 타입 정의
TYPES: BEGIN OF ty_mat,
         matnr   TYPE zmat_cbo-matnr,
         mtart   TYPE zmat_cbo-mtart,
         matdesc TYPE zmat_cbo-matdesc,
         price   TYPE zmat_cbo-price,
       END OF ty_mat.

DATA : gs_mat TYPE ty_mat,
       gt_mat TYPE TABLE OF ty_mat.

" 2. 초기 데이터 세팅.
gs_mat-matnr = 'Z1001'.
gs_mat-mtart = 'FERT'.
gs_mat-matdesc = '이지 아밥 교재'.
gs_mat-price = '125.50'.
APPEND gs_mat TO gt_mat.

gs_mat-matnr = 'Z1002'.
gs_mat-mtart = 'HALV'.
gs_mat-matdesc = '이지 아밥 교재2'.
gs_mat-price = '122.22'.
APPEND gs_mat TO gt_mat.

gs_mat-matnr = 'Z1003'.
gs_mat-mtart = 'HVAL'.
gs_mat-matdesc = '이지 아밥 교재3'.
gs_mat-price = '111.11'.
APPEND gs_mat TO gt_mat.

gs_mat-matnr = 'Z1004'.
gs_mat-mtart = '타입12'.
gs_mat-matdesc = '이지 아밥 교재4'.
gs_mat-price = '222.22'.
APPEND gs_mat TO gt_mat.

" 3. 조건문 + 반복문 활용
DATA : gv_sum   TYPE p DECIMALS 2 VALUE '0',
       gv_count TYPE i VALUE 0,
       gv_avg   TYPE p DECIMALS 2.

WRITE: / '--- 자재별 단가 점검---'.

LOOP AT gt_mat INTO gs_mat.

  " 1) 단가별 조건 메시지
  IF gs_mat-price >= 100.
    WRITE: / gs_mat-matnr,
             gs_mat-matdesc, '=> 고가 자재입니다.'.
  ELSEIF gs_mat-price >= 50.
    WRITE: / gs_mat-matnr,
             gs_mat-matdesc, '=> 중간 가격대 자재입니다.'.
  ELSE.
    WRITE: / gs_mat-matnr,
             gs_mat-matdesc, '=> 저가 자재입니다.'.
  ENDIF.

  "2) 가격 누적 합계 계산
  gv_sum = gv_sum + gs_mat-price.
  gv_count = gv_count + 1.

  "3) 특정 조건에서 루프 건너뛰기 (필터링)
  IF gs_mat-price < 20.
    WRITE: / '-> 가격이 너무 낮아 계산에서 제외됩니다.'.
    CONTINUE.
  ENDIF.

ENDLOOP.


" 4. 평균 단가 계산
IF gv_count > 0.
  gv_avg = gv_sum / gv_count.
  WRITE: /,
         / '-----------------------------------',
         / '총 지제 수:', gv_count,
         / '단가 합계:', gv_sum,
         / '평균 단가:', gv_avg,
         / '-----------------------------------'.
ENDIF.


" 5. case 문으로 자재유형별 메시지
WRITE: /,
       / '--- 자재 유형별 메시지 ---'.

LOOP AT gt_mat INTO gs_mat.

  CASE gs_mat-mtart.
    WHEN 'FERT'.
      WRITE: / gs_mat-matnr, '완제품(FERT): 판매용 자재입니다.'.
    WHEN 'HALB'.
      WRITE: / gs_mat-matnr, '반제품 : 중간 공정 자재입니다.'.
    WHEN 'ROH'.
      WRITE: / gs_mat-matnr, '원자재: 제조에 투입되는 자재입니다.'.
    WHEN OTHERS.
      WRITE: / gs_mat-matnr, ' 기타 자재 유형입니다.'.
  ENDCASE.

ENDLOOP.
