*----------------------------------------------------------------------*
***INCLUDE ZSAPA01_PBO_100O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module PBO_100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo_100 OUTPUT.

" 이제 이 코드에서 PBO의 기능을 해야 한다.
" 앞서 데이터를 조회를 했꼬 그 결과를 100번 스크린에 띄워야 한다.
" 그런데 100번 스크린을 call 했다면 화면이 뜨게 전에 해야할 일을 이곳에 코딩한다.

create object gv_container1
  EXPORTING
    container_name = 'CC1'.

create object gv_grid1
  EXPORTING
    i_parent = gv_container1.

call METHOD gv_grid1->set_table_for_first_display
  EXPORTING
    i_structure_name = 'SAPLANE'

  CHANGING
    it_outtab = gt_saplane[].


ENDMODULE.
