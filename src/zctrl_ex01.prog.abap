*&---------------------------------------------------------------------*
*& Report ZCTRL_EX01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zctrl_ex01.
" 이제 아밥 프로그램의 흐름을 결정하는 구문들을 배운다.

" 개념 이해
" abap은 기본적으로 순차 실행 언어이다.
" 하지만 조건이나 반복이 들어가면 흐름을 제어해야 한다.

* 변수 선언
DATA : gv_score TYPE i VALUE 85,
       gv_grade TYPE c LENGTH 1,
       gv_index TYPE i.

" 조건 분기
IF gv_score >= 90.
  gv_grade = 'A'.
ELSEIF gv_score >= 80.
  gv_grade = 'B'.
ELSEIF gv_score >= 70.
  gv_grade = 'C'.
ELSE.
  gv_grade = 'F'.
ENDIF.

WRITE : / '점수:', gv_score, '-> 학점:', gv_grade.

*--------------------------------------------------------------------*
* 3. case / when (다중 조건)
*--------------------------------------------------------------------*
CASE gv_grade.
  WHEN 'A'.
    WRITE: / '우수한 성적입니다!'.
  WHEN 'B'.
    WRITE: /'좋은 성적입니다!'.
  WHEN 'C'.
    WRITE: /'보통 수준입니다!'.
  WHEN OTHERS.
    WRITE: / '노력이 필요합니다!'.
ENDCASE.

*--------------------------------------------------------------------*
*4. 반복문
*--------------------------------------------------------------------*
WRITE: / '--- DO 반복문 ---'.
DO 5 TIMES.
  WRITE: / '반복 중입니다. 횟수:', sy-index.
ENDDO.

WRITE: / '--- WHIEL 반복문 ---'.
gv_index = 1.
WHILE gv_index <= 3.
  WRITE: / gv_index, '번째 반복문입니다.'.
  gv_index = gv_index + 1.
ENDWHILE.


*--------------------------------------------------------------------*
* Loop At 내부 테이블
*--------------------------------------------------------------------*
TYPES: BEGIN OF ty_student,
         name  TYPE c LENGTH 10,
         score TYPE i,
       END OF ty_student.

DATA : gs_stu TYPE ty_student,
       gt_stu TYPE STANDARD TABLE OF ty_student.

* 학생 데이터 추가
gs_stu-name = 'Kim'.  gs_stu-score = 95. APPEND gs_stu TO gt_stu.
gs_stu-name = 'Lee'.  gs_stu-score = 82. APPEND gs_stu TO gt_stu.
gs_stu-name = 'Park'. gs_stu-score = 67. APPEND gs_stu TO gt_stu.
gs_stu-name = 'Choi'. gs_stu-score = 45. APPEND gs_stu TO gt_stu.

WRITE: / '--- LOOP 반복문 ---'.
LOOP AT gt_stu INTO gs_stu.

   IF gs_stu-score < 50.
    WRITE: / gs_stu-name, ': 재시험 대상입니다.'.
    CONTINUE.  "이번 루프 건너뛰기
  ENDIF.

  IF gs_stu-score >= 90.
    WRITE: / gs_stu-name. " : 우등생!'.
    exit. " 첫 우등생 찾으면 루프 중단
  ENDIF.

  WRITE: / gs_stu-name, ': 점수는', gs_stu-score, '점'.
ENDLOOP.

WRITE: / '루프 종료'.
