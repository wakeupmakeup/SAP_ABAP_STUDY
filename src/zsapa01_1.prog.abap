*&---------------------------------------------------------------------*
*& Report ZSAPA01_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsapa01_1.
TABLES : scarr.

DATA : gv_grid TYPE REF TO cl_gui_alv_grid.
DATA : gv_container TYPE REF TO cl_gui_custom_container.
DATA : gt_scarr TYPE TABLE OF scarr.

SELECT-OPTIONS : s_carrid FOR scarr-carrid.

START-OF-SELECTION.
  SELECT *
    FROM scarr
    WHERE carrid IN @s_carrid
    INTO TABLE @gt_scarr.

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

INCLUDE zsapa01_1_pbo100o01.
*&---------------------------------------------------------------------*
*& Module PBO100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo100 OUTPUT.

" ALV를 띄우는 조건 첫 번쨰.
" 컨테이너 영역을 만들 것.
CREATE OBJECT gv_container
  EXPORTING
    container_name = 'CC1'.

" 두 번쨰
" ALV 그리드 영역을 만들 것.
CREATE OBJECT gv_grid
  EXPORTING
    i_parent = gv_container.

" 세 번째
" 메소드 하나 불러와서 출력하기
CALL METHOD gv_grid->set_table_for_first_display
  EXPORTING
    i_structure_name = 'SCARR'
  CHANGING
    it_outtab   = gt_scarr[].
  endmodule.
