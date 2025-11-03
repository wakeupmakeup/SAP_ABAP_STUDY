*&---------------------------------------------------------------------*
*& Report ZDTYPE_EX01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zdtype_ex01.

DATA: gv_name  TYPE c LENGTH 10 VALUE '태경',
      gv_age   TYPE i VALUE 20,
      gv_date  TYPE d VALUE '20251103',
      gv_time  TYPE t VALUE '153000',
      gv_score TYPE p DECIMALS 2 VALUE '98.75'.

WRITE : / '이름 :', gv_name,
        / '나이 :', gv_age,
        / '날짜 :', gv_date,
        / '시간 :', gv_time,
        / '점수 :', gv_score.


*--------------------------------------------------------------------*
**2. 로컬 타입을 이용한 구조체 선언.
*--------------------------------------------------------------------*
TYPES: BEGIN OF ty_struct,
         name  TYPE c LENGTH 20,
         age   TYPE i,
         score TYPE p DECIMALS 1,
       END OF ty_struct.

data gs_student type ty_struct.

* 데이터 값 입력
gs_student-name = '이지 아밥'.
gs_student-age = 25.
gs_student-score = '87.5'.

* 결과 출력
write : /,
        / '학생 이름:', gs_student-name,
        / '학생 나이:', gs_student-age,
        / '학생 점수:', gs_student-score.


*--------------------------------------------------------------------*
* 설명부분
*--------------------------------------------------------------------*
*데이터 타입이라는 것은 아밥 프로그램에서 데이터를 저장하기 위한 형식을 정의하는 것이다.
*데이터가 들어갈 그릇의 형태를 정하는 일이다.
*
*- data type = 그릇의 모양
*- variable = 그릇 자체
*- value  = 그 안에 담긴 음식
*
*또 이 ABAP의 데이터 타입은 크게 3가지로 나뉜다.
*1. predefined type (기본형)
*2. Local type (로컬 타입)
*3. Global type (글로벌 타입)
*
*
*Predefined Type은 SAP에서 이미 만들어 놓은 타입을 의미한다.
*- C
*- N
*- D
*- T
*- I
*- P
*- F
*- X 등...
*
*Local type은 TYPES 구문으로 정의한다.
*예를들어 특정 프로그램 안에서만 쓸 구조체나 상수 집합을 만들때 사용한다.
*위에서 학생을 정의한 데이터 타입이 그것이다.
*
*Global type은 딕셔너리에 들어가 모든 프로그램에서 공통으로 사용 가능하다.
*데이터 엘리먼트, 스트럭처, 테이블 타입 등이 이에 해당된다. 즉, DDIC안에 들어가 있는 것들은 모두 글로벌 타입이다.
