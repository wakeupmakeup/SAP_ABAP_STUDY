*&---------------------------------------------------------------------*
*& Report ZSAPA02_3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsapa02_3.
TABLES : spfli, saplane.

" 일단 먼저 컨테이너랑 스플릿을 만들어야 한다.
DATA : gv_grid1 TYPE REF TO cl_gui_alv_grid.
DATA : gv_grid2 TYPE REF TO cl_gui_alv_grid.
DATA : gv_container1 TYPE REF TO cl_gui_container.
DATA : gv_container2 TYPE REF TO cl_gui_container.
DATA : gv_splitter TYPE REF TO cl_gui_splitter_container.
DATA : gv_custom TYPE REF TO cl_gui_custom_container.

SELECT-OPTIONS : s_spfil FOR spfli-carrid.
SELECT-OPTIONS : s_plane FOR saplane-planetype.

START-OF-SELECTION.

  SELECT *
    FROM spfli
    WHERE carrid IN @s_spfil
    INTO TABLE @DATA(gt_carrid).

  SELECT *
    FROM saplane
    WHERE planetype IN @s_plane
    INTO TABLE @DATA(gt_plane).

END-OF-SELECTION.

  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'S100'.
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

  " 스플릿 컨테이너를 만들기 위해서는 뭐 부터 해야할까?
  " 먼저 커스텀 컨테이너 하나를 만들어야 한다.
  CREATE OBJECT gv_custom
    EXPORTING
      container_name = 'MY_CC1'.

  " 2. 스플릿 설정을 해야 한다.
  " 먼저 스플릿을 하나 만들자.
  CREATE OBJECT gv_splitter
    EXPORTING
      parent  = gv_custom " 이때 내가 출력할 커스텀 컨테이너 하나를 부모로 삼아서 만들어야 한다.
      rows    = 1
      columns = 2. " 이렇게 하면 컬럼을 2개 만든다는 의미이니 세로로 화면이 분할된다.

  " 3. 이제 각각 왼쪽, 오른쪽으로 분할된 컨테이너에 각각 뭐가 올지 지정해야 한다.
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

  " 4. 이제 grid를 각각 생성한다. 2개로 분할되어 있으니 2개를 만들어야 한다.
  CREATE OBJECT gv_grid1
    EXPORTING
      i_parent = gv_container1.

  CREATE OBJECT gv_grid2
    EXPORTING
      i_parent = gv_container2.

  " 5. 이제 출력을 해보자.
  CALL METHOD gv_grid1->set_table_for_first_display
    EXPORTING
      i_structure_name = 'SPFLI'
    CHANGING
      it_outtab        = gt_carrid[].

  CALL METHOD gv_grid2->set_table_for_first_display
    EXPORTING
      i_structure_name = 'saplane'
    CHANGING
      it_outtab        = gt_plane[].



ENDMODULE.
