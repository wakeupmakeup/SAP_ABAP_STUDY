*&---------------------------------------------------------------------*
*& Report ZDATE_EX01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDATE_EX01.

" 시스템 필드의 구조
" SAP에서는 전역적으로 시스템 필드라는 특수 변수가 항상 메모리에 존재한다.
" sy-datum : 현재 날짜
" sy-UZEIT : 현재 시간
" sy-datst : 현재 요일
" sy-tzone : 시스템 타임존

" 내부저긍로 문자형 숫자 데이터 (CHAR) 형태로 저장된다. 그러니 계산하려면 형 변환이 필요하다.

WRITE: / '현재 시스템 날짜:', sy-datum,
       / '현재 시스템 시간:', sy-uzeit,
       / '요일 코드:', sy-dayst.


" 날짜 계산
" 아밥 에서는 날짜를 숫자처럼 더하거나 뺼 수 있다.

data gv_today type d.
data gv_future type d.
data gv_past type d.

gv_today = sy-datum.
" value를 사용할 수 없는 이유는 시스템 필드는 프로그램 실행 시 자동으로 채워지는 변수이다.
" 그러니 현재 날짜 값이 들어있는 전역 변수이지 상수가 아니다.
" value 구문은 컴파일 시점에서 상수 또는 리터릴만 허용하는데 시스템필드는 실행 시점에서 결정되므로
" 아밥 컴파일러가 컴파일 시점에 확정되지 않았으니 상수 초기값으로 쓸 수 없다는 것이다.

gv_future = gv_today + 7. " 7일 후
gv_past  = gv_today - 30. " 30일 전

WRITE : / '오늘 : ', gv_today,
        / '7일 후 : ', gv_future,
        / '30일 전 : ', gv_past.


" 시간 변환과 포맷팅
data: gv_time type t,
      gv_char type c length 8.

gv_time = sy-uzeit.

WRITE : / '현재 시간(원본):', gv_time.

WRITE gv_time to gv_char using edit mask '__:__:__'.
WRITE : /'형식화된 시간:', gv_char.

" 내부적으로 write to는 문자 버퍼를 이용해서 패턴대로 포맷팅한다.


" 날짜 차이 계산
data : gv_date1 type d value '20250101',
       gv_date2 type d value '20250115',
       gv_diff type i.

gv_diff = gv_date2 - gv_date1.

WRITE : / '두 날짜의 차이(일수):', gv_diff.

" type d는 내부적으로 정수형이므로 이렇게 빼면 자동으로 일수 차이가 계산된다.
" SAP에서는 월 계산을 할떄 자동으로 그 말일로 계산이 된다.
" 이것이 EOM 규칙의 대표 사례이다.

" 예를들어 3월 15일 + 1달로 했다면 4월 15일이 되지만
" 1월 31 + 1달로 하면 2월 28일이 된다.
