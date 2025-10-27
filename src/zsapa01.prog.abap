*&---------------------------------------------------------------------*
*& Report ZSAPA01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsapa01.
TABLES : saplane.  " 이 테이블을 사용하겠습니다. 라고 선언 해두는 것.
DATA : gv_grid1 TYPE REF TO cl_gui_alv_grid. " alv를 만들기 위해 필요한 클래스 1
DATA : gv_container1 TYPE REF TO cl_gui_custom_container. " ALV를 담기 위한 컨테이너

SELECT-OPTIONS : s_pltype FOR saplane-planetype.  " 조회조건 화면 만들기.
" 이 타입은 파라미터와 달리 범위를 지정할 수 있으며 자동으로 내부 테이블로 변환되어 진다.
" 지금같은 레포트 프로그램은 기본적으로 1000번 스크린으로 작동하게 된다.
" 따라서 직접 스크린을 만들지 않고도 데이터를 조회할 수 있다.
" 하지만 select-options를 만들어서 조회화면을 1000번 스크린으로 자동으로 만드렁 지는 것과 달리
" 결과 화면은 직접 만들어 줘야 한다.
" 그리고 그 화면을 부르는 것을 call screen 이라고 한다.

START-OF-SELECTION. " 이제 데이터를 준비할께요 라는 소리.
  SELECT *
  FROM saplane
  WHERE planetype IN @s_pltype
  INTO TABLE @DATA(gt_saplane).


END-OF-SELECTION. " 데이터 조회가 끝났다는 의미이다.
call screen 100. " 조회가 끝났으면 결과를 보여줄 화면을 불러오자. (없으면 생성해야 한다)

INCLUDE zsapa01_status_0100o01.

INCLUDE zsapa01_user_command_0100i01.

INCLUDE zsapa01_pbo_100o01.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
LEAVE TO SCREEN 0.
ENDMODULE.
