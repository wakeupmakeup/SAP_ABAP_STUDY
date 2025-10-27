*&---------------------------------------------------------------------*
*& Report ZSAPA01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsapa02.
TABLES : scarr, sairport.  " 이 테이블을 사용하겠습니다. 라고 선언 해두는 것.
DATA : gv_grid1 TYPE REF TO cl_gui_alv_grid. " alv를 만들기 위해 필요한 클래스 1
DATA : gv_container1 TYPE REF TO cl_gui_custom_container. " ALV를 담기 위한 컨테이너
DATA : gv_grid2 TYPE REF TO cl_gui_alv_grid.
DATA : gv_container2 TYPE REF TO cl_gui_custom_container.

SELECT-OPTIONS : s_id FOR sairport-id.  " 조회조건 화면 만들기.
SELECT-OPTIONS : s_carrid FOR scarr-carrid.


START-OF-SELECTION. " 이제 데이터를 준비할께요 라는 소리.
  SELECT *
    FROM scarr
    WHERE carrid IN @s_carrid
    INTO TABLE @DATA(gt_scarr).

  SELECT *
    FROM sairport
    WHERE id IN @s_id
    INTO TABLE @DATA(gt_sairport).



END-OF-SELECTION. " 데이터 조회가 끝났다는 의미이다.
  CALL SCREEN 100. " 조회가 끝났으면 결과를 보여줄 화면을 불러오자. (없으면 생성해야 한다)

MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'TITLE100'.
ENDMODULE.



MODULE pbo_100 OUTPUT.

  " 이제 이 코드에서 PBO의 기능을 해야 한다.
  " 앞서 데이터를 조회를 했꼬 그 결과를 100번 스크린에 띄워야 한다.
  " 그런데 100번 스크린을 call 했다면 화면이 뜨게 전에 해야할 일을 이곳에 코딩한다.

  CREATE OBJECT gv_container1
    EXPORTING
      container_name = 'CC1'.

  CREATE OBJECT gv_container2
    EXPORTING
      container_name = 'CC2'.

  CREATE OBJECT gv_grid1
    EXPORTING
      i_parent = gv_container1.

  CREATE OBJECT gv_grid2
    EXPORTING
      i_parent = gv_container2.

  CALL METHOD gv_grid1->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SCARR'
    CHANGING
      it_outtab        = gt_scarr[].

  CALL METHOD gv_grid2->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SAIRPORT'
    CHANGING
      it_outtab        = gt_sairport[].

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
LEAVE TO SCREEN 0.
ENDMODULE.
