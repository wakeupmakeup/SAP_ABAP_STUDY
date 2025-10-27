*&---------------------------------------------------------------------*
*& Report ZSAPA01_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsapa01_2.
TABLES : sairport.

DATA : gv_grid TYPE REF TO cl_gui_alv_grid.
DATA : gv_container TYPE REF TO cl_gui_custom_container.
DATA : gt_airport TYPE TABLE OF sairport.
SELECT-OPTIONS : s_aport FOR sairport-id.

START-OF-SELECTION.
  SELECT *
    FROM sairport
    WHERE id IN @s_aport
    INTO TABLE @gt_airport.

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
*& Module PBO100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo100 OUTPUT.

  create object gv_container
  EXPORTING
    container_name = 'CC1'.

  create object gv_grid
  EXPORTING
    i_parent = gv_container.

  call METHOD gv_grid->set_table_for_first_display
  EXPORTING
    i_structure_name = 'SAIRPORT'

  CHANGING
   it_outtab = gt_airport[].

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
leave to screen 0.
ENDMODULE.
