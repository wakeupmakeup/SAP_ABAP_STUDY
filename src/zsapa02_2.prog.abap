*&---------------------------------------------------------------------*
*& Report ZSAPA01
*&---------------------------------------------------------------------*
*& 스플릿 alv를 만드는 법을 배워본다. 스플릿 같은 경우 커스텀 컨테이너가 하나만 있으면 된다.
*&---------------------------------------------------------------------*
REPORT zsapa02_2.
TABLES : scarr, sairport.  " 이 테이블을 사용하겠습니다. 라고 선언 해두는 것.
DATA : gv_grid1 TYPE REF TO cl_gui_alv_grid. " alv를 만들기 위해 필요한 클래스
DATA : gv_grid2 TYPE REF TO cl_gui_alv_grid.
DATA : gv_container1 TYPE REF TO cl_gui_container. " ALV를 담기 위한 컨테이너
DATA : gv_container2 TYPE REF TO cl_gui_container.
DATA : gv_splitter TYPE REF TO cl_gui_splitter_container.
data : gv_docking type ref to cl_gui_docking_container.
*DATA : gv_custom TYPE REF TO cl_gui_custom_container.



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
  " 그런데 100번 스크린을 call 했다면 화면이 뜨게 전에 해야할 일을 이곳에 코딩한다.\

*  CREATE OBJECT gv_custom
*    EXPORTING
*      container_name = 'CC1'.

  create object gv_docking
    EXPORTING
      repid = sy-cprog  " 닻을 내릴 프로그램
      dynnr = sy-dynnr  " 스크린 번호
      side  = gv_docking->dock_at_left  " 해당 스크린의 어디서 부터 닻을 내릴지를 정하는 파라미터
      extension = 1800.  " extension은 해당 지점에서 얼마의 폭을 최초 영역으로 지정할지 정하는 곳.

  CREATE OBJECT gv_splitter
    EXPORTING
      parent  = gv_docking
      rows    = 1
      columns = 2.

  CALL METHOD gv_splitter->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = gv_container1.

  CALL METHOD gv_splitter->get_container
    EXPORTING
      row       = 1
      column    = 2
    RECEIVING
      container = gv_container2.

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
MODULE exit INPUT.
  LEAVE TO SCREEN 0.
ENDMODULE.
