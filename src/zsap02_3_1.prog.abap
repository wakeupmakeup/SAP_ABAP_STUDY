*&---------------------------------------------------------------------*
*& Report ZSAP02_3_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsap02_3_1.
" 스플릿을 만들기 위해서는 뭘 해야 할까?
" 첫번쨰로 변수들을 선언한다.

" 가장 처음으로 사용할 테이블을 가져와야 한다.
TABLES : sflight, scustom.
DATA : gv_grid1 TYPE REF TO cl_gui_alv_grid.
DATA : gv_grid2 TYPE REF TO cl_gui_alv_grid.

" 컨테이너를 선언한다.
" 이때 커스텀 컨테이너는 하나만 있으면 되고
" 왼쪽 오른쪽에 들어갈 컨테이너를 각각 만들어 주면 된다.
DATA : gv_custom TYPE REF TO cl_gui_custom_container.
DATA : gv_container1 TYPE REF TO cl_gui_container.
DATA : gv_container2 TYPE REF TO cl_gui_container.

" 스플릿 선언도 하나 해줘야 한다.
DATA : gv_split TYPE REF TO cl_gui_splitter_container.

" 이제 조회 화면을 만들어 주자.
SELECT-OPTIONS : s_flight FOR sflight-carrid.
SELECT-OPTIONS : s_custom FOR scustom-id.

" 변수 선언이 모두 끝났다.
" 이제 데이터를 가져와야 한다.

START-OF-SELECTION.
  SELECT *
    FROM sflight
    WHERE carrid IN @s_flight
  INTO TABLE @DATA(gt_carrid).

  SELECT *
    FROM scustom
    WHERE id IN @s_custom
  INTO TABLE @DATA(gt_custom).

  " 데이터 조회가 끝났으면 밑에 명령어를 써야함.

END-OF-SELECTION.
  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'TITLE'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PBO100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo100 OUTPUT.

  " 이제 여기서 pbo 작업을 해줘야 한다.
  " 먼저 컨테이너를 이용해서 하나 만들어 줘야 한다.
  CREATE OBJECT gv_custom
    EXPORTING
      container_name = 'CC1'.

  " 스플릿 컨테이너를 하나 만들어야 한다.
  " 이때 스플릿 작업을 어떻게 나눌지 고민해봐야 한다.
  " 1/2로 나눠야 하니 row = 1, column = 2로 한다.
  CREATE OBJECT gv_split
    EXPORTING
      parent  = gv_custom " Parent Container
      rows    = 1         " Number of Rows to be displayed
      columns = 2.        " Number of Columns to be Displayed

  " 이제 왼쪽, 오르쪽으로 나뉜 컨테이너에 작업을 해줘야 한다.
  " 메서드를 하나 불러서 해야한다.
  CALL METHOD gv_split->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = gv_container1.

  CALL METHOD gv_split->get_container
    EXPORTING
      row       = 1
      column    = 2
    RECEIVING
      container = gv_container2.

  " 이제 grid를 생성해야 한다.
  CREATE OBJECT gv_grid1
    EXPORTING
      i_parent = gv_container1.

  CREATE OBJECT gv_grid2
    EXPORTING
      i_parent = gv_container2.

  " grid를 모두 만들었다면 이제 출력을 해야한다.
  " 메소드를 불러서 출력한다.
  " 출력하는 것은 grid를 이용해서 해야한다.
  CALL METHOD gv_grid1->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SFLIGHT'
    CHANGING
      it_outtab        = gt_carrid[].

  CALL METHOD gv_grid2->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SCUSTOM'
    CHANGING
      it_outtab        = gt_custom[].




ENDMODULE.
