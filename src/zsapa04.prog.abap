*&---------------------------------------------------------------------*
*& Report ZSAPA03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsapa04.

" 프로그램에서 가장 먼저 할 일은 변수를 선언하는 것이다.
" 먼저 내가 사용할 테이블을 여기에 선언하여 올려둔다.
TABLES: sflight, scarr, spfli.

DATA : gv_container TYPE REF TO cl_gui_custom_container.
DATA : gv_grid TYPE REF TO cl_gui_alv_grid.
DATA : gv_docking TYPE REF TO cl_gui_docking_container.
DATA : BEGIN OF gs_seats,
         carrid     TYPE sflight-carrid,
         carrname   TYPE scarr-carrname,
         connid     TYPE sflight-connid,
         fldate     TYPE sflight-fldate,
         cityfrom   TYPE spfli-cityfrom,
         airpfrom   TYPE spfli-airpfrom,
         cityto     TYPE spfli-cityto,
         airpto     TYPE spfli-airpto,
         seatsmax    TYPE sflight-seatsmax,
         seatsocc   TYPE sflight-seatsocc,
         seatsmax_b TYPE sflight-seatsmax_b,
         seatsocc_b TYPE sflight-seatsocc_b,
         seatsmax_f TYPE sflight-seatsmax_f,
         seatsocc_f TYPE sflight-seatsocc_f,
       END OF gs_seats.

DATA : gt_seats LIKE TABLE OF gs_seats.

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS handle_double_click
                FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING e_row e_column es_row_no.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_double_click.
    READ TABLE gt_seats INTO gs_seats INDEX e_row-index.

    SELECT *
      INTO TABLE @DATA(lt_stock)
      FROM sbook
      WHERE carrid = @gs_seats-carrid
      AND connid = @gs_seats-connid
      AND fldate = @gs_seats-fldate.
    IF sy-subrc = 0.
      DATA : g_table TYPE REF TO cl_salv_table.

      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = g_table
        CHANGING
          t_table      = lt_stock[].

      g_table->set_screen_popup(
      start_column = 10
      end_column = 150
      start_line = 10
      end_line = 25 ).
      g_table->display( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.

DATA: g_event_handler TYPE REF TO lcl_event_handler.


" 조회 화면을 구성한다.
" 파라미터와 셀렉트 옵션즈를 사용한다.
PARAMETERS :p_from TYPE spfli-cityfrom OBLIGATORY  " OBLIGATORY 이 키워드는 필수값을 말한다.
          DEFAULT 'NEW YORK',
            p_to   TYPE spfli-cityto OBLIGATORY
              DEFAULT 'SAN FRANCISCO'.

SELECT-OPTIONS : s_fldate FOR sflight-fldate.

" 이제 데이터를 가지고 놀아야 한다.
" OPEN SQL을 이용해서 데이터를 가지고 놀아보자.
" 일반적인 SQL문은 아니고 ABAP만의 문법을 사용한다.

START-OF-SELECTION.

  " 여기에 데이터를 만들자.
  SELECT a~carrid, a~connid, a~fldate,
    c~carrname, b~cityfrom, b~airpfrom,
    b~cityto, b~airpto, a~seatsmax,
    a~seatsocc, a~seatsmax_b, a~seatsocc_f
    FROM sflight AS a INNER JOIN spfli AS b
    ON a~carrid = b~carrid
    AND a~connid = b~connid
    INNER JOIN scarr AS c
    ON a~carrid = c~carrid
  WHERE a~fldate IN @s_fldate
    AND b~cityfrom = @p_from
    AND b~cityto = @p_to
   into CORRESPONDING FIELDS OF table @gt_seats[].

  " 위에 있는 데이터는 select 구문에서 필드를 정의하기 위해서는 테이블 명 뒤에 ~를 붙이고 그 뒤에 테이블 필드명을 적는다.
  " 그리고 각각의 from 절에 테이블 마다 별칭을 사용한다.
  " 그리고 gt_seats 라는 변수가 갑자기 나왔는데 이는 '묵시적 선언'이라는 것을 통해서 위에서 변수를 선언하지 않아도 사용할 수 있게 한다.
  " *묵시적 선언* -> 아밥의 새로운 문법이다.

  " 문법에 두 가지가 있다.
  " 첫 번째는 프로그램 앞부분에 미리 선언해놓는 명시적 선언이 있고
  " 두 번째가 미리 선언하지 않고 필요한 곳에서 선언하는 묵시적 선언 방법이 존재한다.

*sap가 HANA 데이터베이스를 가지기 전에는 데이터베이스와 연계된 무언가를 마음대로 시도할 수 없엇따.
*그래서 데이터베이스에 처리하는 시간을 최대한 줄이고 마음대로 제어할 수 있는 내부 테이블에서 많은 작업을 했었다.
*예를 들어 DB에서 한번에 가져온 데이터를 내부 테이블에서 Loop문을 돌리면서 가공하는 일이 많았다. 그러나 HANA가 본격적으로 활용되면서
*인메모리 데이터베이스의 장점을 최대한 활용하기 위해 새로운 아밥 문법이 필요하게 되었고 그 결과물이 이것이다.

END-OF-SELECTION.
  CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Module PBO100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE pbo100 OUTPUT.

  " 도킹으로 시작했으니 이것으로 만들자.
  " 도킹은 컨테이너가 필요없다. 직접 만들어주면 되기 때문.
  CREATE OBJECT gv_docking
    EXPORTING
      repid     = sy-repid
      dynnr     = sy-dynnr
      side      = gv_docking->dock_at_left
      extension = 1800.

  " 항상 컨테이너 작업을 하면 grid 작업을 해야한다는 것을 잊지말자.
  CREATE OBJECT gv_grid
    EXPORTING
      i_parent = gv_docking.

  " 동적 필드 카탈로그 작성하기.
  DATA : lr_tabdescr TYPE REF TO cl_abap_structdescr,
         lr_data     TYPE REF TO data,
         lt_dfies    TYPE ddfields,
         ls_dfies    TYPE dfies,
         ls_fieldcat TYPE lvc_s_fcat,
         lt_fieldcat TYPE lvc_t_fcat.

  CREATE DATA lr_data LIKE LINE OF gt_seats.
  lr_tabdescr ?= cl_abap_structdescr=>describe_by_data_ref( lr_data ).
  lt_dfies = cl_salv_data_descr=>read_structdescr( lr_tabdescr ).
  LOOP AT lt_dfies INTO ls_dfies.
    CLEAR ls_fieldcat.
    MOVE-CORRESPONDING ls_dfies TO ls_fieldcat.
    APPEND ls_fieldcat TO lt_fieldcat.
  ENDLOOP.

  " 보통 alv를 구성할 떄 보통 lvc_t_fcat에 필드 목록을 직접 작성한다.(수동)
  " 하지만 이 방법은 필드가 많을땐느 비효율적인데 이래서 동적으로 작성할 수 있게 한다.
* lr_tabdescr -> 테이블 구조 설명 객체 참조
* lr_data -> 동적으로 생성되는 라인 데이터 참조
* lt_dfies / ls_dfies -> DDIC 필드 정보 구조
* lt_fieldcat / ls_fieldcat -> ALV 필드 카탈로그 구조.
*
* 1. 내부 테이블 구조 참조 얻기.
* create data lr_data like line of gt_seats.
* gt_seats 라는 내부 테이블의 한 줄 구조를 기반으로 lr_data를 생성한다.
*
* 그후
* lr_tabdescr ?= cl_abap_structdescr=>describe_by_data_ref( lr_data ).
* 이런 객체 방식으로 구조 정보를 가져온다.
*
* 3. DDIC 구조를 DFIES로 가져오기.
* lt_dfies = cl_salv_data_descr=>read_structdescr( lr_tabdescr ).
* - salv 라이브러리를 통해 구조 설명을 DFIES 테이블 형태로 변환한다.
* - DFIES는 SAP에서 필드 메타 정보 저장 형식을 가진다.
*
*
* 4. DFIRS -> LVC 필드 카탈로그 매핑하기.
* LOOP AT lt_dfies INTO ls_dfies.
*  CLEAR ls_fieldcat.
*  MOVE-CORRESPONDING ls_dfies TO ls_fieldcat.
*  APPEND ls_fieldcat TO lt_fieldcat.
*ENDLOOP.
* - DFIES의 필드 속성들을 ALV 필드 카탈로그 구조로 복사한다.
* - 필요한 필드들은 자동으로 매핑한다.
* - 필드 카탈로그 완성!


" [NEW!] 이벤트 헨들러 등록하기
create object g_event_handler.
SET HANDLER g_event_handler->handle_double_click FOR gv_grid.

" 이제 출력을 해보자.
" 출력은 grid를 출력하는 것이니 gv_grid를 이용한다.
CALL METHOD gv_grid->set_table_for_first_display
" EXPORTING
" i_structure_name = ???  " 데이터의 필드들이 너무 많이 섞여버려서 어떤것을 기준으로 해야할지 모를때 필드 카탈로그를 사용하면 된다.
" 수동으로 하나하나 만들어서 처리하는 방법과 그냥 동적으로 처리하는 방법 이렇게 2가지로 나뉜다.
  CHANGING
    it_fieldcatalog = lt_fieldcat
    it_outtab       = gt_seats[].

ENDMODULE.
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
  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'EXIT' OR 'CANCEL'.
      LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.
