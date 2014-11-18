<CODEGEN_FILENAME><structure_name>mnt.dbl</CODEGEN_FILENAME>
;//****************************************************************************
;//
;// Title:       tk_maint_simple.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: This template generates a simple Synergy UI Toolkit
;//              maintenance program. The program has a tab set containing a
;//              search list and a maintenance input window.
;//
;// Date:        19th March 2007
;//
;// Author:      Steve Ives, Synergex Professional Services Group
;//              http://www.synergex.com
;//
;//****************************************************************************
;//
;// Copyright (c) 2012, Synergex International, Inc.
;// All rights reserved.
;//
;// Redistribution and use in source and binary forms, with or without
;// modification, are permitted provided that the following conditions are met:
;//
;// * Redistributions of source code must retain the above copyright notice,
;//   this list of conditions and the following disclaimer.
;//
;// * Redistributions in binary form must reproduce the above copyright notice,
;//   this list of conditions and the following disclaimer in the documentation
;//   and/or other materials provided with the distribution.
;//
;// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
;// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;// POSSIBILITY OF SUCH DAMAGE.
;//
;//****************************************************************************
;//
;// Notes:        To generate code from the template:
;//
;//               - Must specify a Repository structure
;//               - Structure must be assigned to a Repository file definition
;//
;//               To compile generated program
;//
;//               - Must be in same directory as source code, or edit source
;//                 code and change all includes use an environment variable.
;//
;//               To link generated program
;//
;//               - Must link against WND:tklib.elb
;//
;//               To execute generated program
;//
;//               - Environment variable EXE: must point to location of
;//                 generated source.
;//               - EXE directory must contain a window library called
;//                 <structure_name>mnt.ism
;//               - Window library must containin:
;//                 - A two line list input window called <STRUCTURE_NAME>_LUP
;//                   with list fields on the first line and column headings on
;//                   the second line. The title of this window is used as the
;//                   text on the list's tab.
;//                 - An input window called <STRUCTURE_NAME> containing the
;//                   structures fields for maintenance.  The window must
;//                   contain sets ALL (containing all fields) and KEY\
;//                   (containing the primary key field. The window title is
;//                   used for the tab text for the input tab.
;//
;//
;//               The program and tab set titles will be set to the description
;//               of the Repository structure, plus the text " Maintenance".
;//
;;*****************************************************************************
;;
;; Routine:     <structure_name>mnt
;;
;; Description: <STRUCTURE_DESC> Maintenance
;;
;; Author:      <AUTHOR>
;;
;; Company:     <COMPANY>
;;
;;*****************************************************************************
;;
;; WARNING:     This code was generated by CodeGen. Any changes that you make
;;              to this file will be lost if the code is regenerated.
;;
;;*****************************************************************************
;;
.ifndef <STRUCTURE_NAME>MNT_DATA
;;
;;*****************************************************************************
;;
;; Maintenance program main-line
;;
main <structure_name>mnt

    .define PROGRAM_TITLE   "<STRUCTURE_DESC> Maintenance"
    .define PROGRAM_VERSION "1.0"
    .define PROGRAM_FONT    "MS Sans Serif",8,"A"
    .define PROGRAM_WIDTH   100
    .define PROGRAM_WINLIB  "EXE:<structure_name>mnt.ism"

    ;.undefine D_GUI        ;Uncomment to emulate cell based system

    .define <STRUCTURE_NAME>MNT_DATA
    .define <STRUCTURE_NAME>MNT_INIT
    .include "<structure_name>mnt.dbl"

    record
        mbcontrol       ,a1024
        axlist          ,i4
        listhead        ,a256
    endrecord

proc

    ;Start UI Toolkit and setup environment
    xcall u_start(PROGRAM_WINLIB,1,0,,,PROGRAM_WIDTH)
    xcall e_sect(PROGRAM_TITLE,D_HEADER)
    xcall e_state(D_ON,D_RETURNBTN,D_VALSTCHG)
    xcall e_method(D_METH_ENTRST,"<structure_name>mnt_entrst")
    xcall u_wndfont(D_SETFONT,DF_CURRENT,PROGRAM_FONT)

    .ifndef D_GUI
    g_plc_col_args=TRUE
    .endc

    ;Open the maser file for update (used to read & write master file records)
    xcall u_open(idf_<structure_name>_upd,"U:I","<FILE_NAME>",,,error)
    if (error)
        xcall u_abort("Failed to open file <FILE_NAME>")

    ;Open the maser file for input (used in the list load method)
    xcall u_open(idf_<structure_name>_inp,"I:I","<FILE_NAME>")

    ;Load the maintenance input window
    xcall i_ldinp(idi_<structure_name>,,"<STRUCTURE_NAME>",D_NOPLC,,error)
    if (error)
        xcall u_abort("Failed to load input window <STRUCTURE_NAME>")

    ;Disable the primary key field
    xcall i_disable(D_SET,idi_<structure_name>,"KEY")

    ;Load the list input window
    xcall i_ldinp(idi_<structure_name>_lup,,"<STRUCTURE_NAME>_LUP",D_NOPLC,,error)
    if (error)
        xcall u_abort("Failed to load input window <STRUCTURE_NAME>_LUP")

    ;Retrieve list column headings from list input window
    xcall list_headings(idi_<structure_name>_lup,listhead)

    ;Create the list class
    xcall l_class(lstclass,"<STRUCTURE_NAME>_CLS",,,15,1,,,,,,"<structure_name>mnt_load","ACTIVEX",error)
    if (error)
        xcall u_abort("Failed to create list class <STRUCTURE_NAME>_CLS")

    ;Create the list
    xcall l_create(idl_<structure_name>,idi_<structure_name>_lup,<structure_name>,,"<STRUCTURE_NAME>_CLS",,,D_NOPLC,,,,error)
    if (error)
        xcall u_abort("Failed to create list!")

    ;Set list to row mode and set alternate row background colors
    xcall l_status(idl_<structure_name>,D_LAXCTRL,axlist)
    xcall ax_set(axlist,"RowMode",1)
    xcall ax_set(axlist,"LightItemColor",RGB_VALUE(215,250,215))

    ;Set list column headings
    xcall l_sect(idl_<structure_name>,listhead,D_HEADER)

    ;Build file menu
    xcall mb_column(mbcontrol,"FILE","File",D_GLOBAL)
    xcall mb_entry(mbcontrol,"CREATE","Create",F62_KEY,,,,1)
    xcall mb_entry(mbcontrol,"AMEND","Amend",,,,,1)
    xcall mb_entry(mbcontrol,"DELETE","Delete",F63_KEY,,,,1)
    xcall mb_line(mbcontrol)
    xcall mb_entry(mbcontrol,"ABOUT","About",F1_KEY)
    xcall mb_line(mbcontrol)
    xcall mb_entry(mbcontrol,"QUIT","Exit",F3_KEY)
    xcall mb_list(mbcontrol,"MAIN_OPT",3,"CREATE","AMEND","DELETE")
    xcall mb_end(mbcontrol,idc_file)

    ;Build edit menu
    xcall mb_column(mbcontrol,"EDIT","Edit",D_GLOBAL)
    xcall mb_entry(mbcontrol,"E_CUT","Cut",CTRL_X_KEY,,"T",,1)
    xcall mb_entry(mbcontrol,"E_COPY","Copy",CTRL_C_KEY,,"C",,1)
    xcall mb_entry(mbcontrol,"E_PASTE","Paste",CTRL_V_KEY,,"P",,1)
    xcall mb_list(mbcontrol,"EDIT_OPT",3,"E_CUT","E_COPY","E_PASTE")
    xcall mb_end(mbcontrol,idc_edit)

    .ifndef D_GUI
    ;Build input menu column
    xcall mb_column(mbcontrol,"INPUT","Navigate",,D_NOPLC)
    xcall mb_entry(mbcontrol,"I_PREV","Previous Field",UP_KEY,,"P")
    xcall mb_entry(mbcontrol,"I_NEXT","Next Field",DOWN_KEY,,"N")
    xcall mb_line(mbcontrol)
    xcall mb_entry(mbcontrol,"TS_TABPREV","Previous Tab",F5_KEY)
    xcall mb_entry(mbcontrol,"TS_TABNEXT","Next Tab",F6_KEY)
    xcall mb_line(mbcontrol)
    xcall mb_entry(mbcontrol,"I_DRILL","Lookup",F7_KEY)
    xcall mb_entry(mbcontrol,"EXIT","Close",F3_KEY)
    xcall mb_entry(mbcontrol,"SAVE","Save",F4_KEY)
    xcall mb_end(mbcontrol,idc_input)

    ;Build list menu column
    xcall mb_column(mbcontrol,"LIST","Navigate",,D_NOPLC)
    xcall mb_entry(mbcontrol,"S_UP","Previous Row",UP_KEY,,"P")
    xcall mb_entry(mbcontrol,"S_DOWN","Next Row",DOWN_KEY,,"N")
    xcall mb_line(mbcontrol)
    xcall mb_entry(mbcontrol,"TS_TABPREV","Previous Tab",F5_KEY)
    xcall mb_entry(mbcontrol,"TS_TABNEXT","Next Tab",F6_KEY)
    xcall mb_end(mbcontrol,idc_list)

    ;Build select menu column
    xcall mb_column(mbcontrol,"SELECT","Select",,D_NOPLC)
    xcall mb_entry(mbcontrol,"S_UP","Up",UP_KEY,,"U")
    xcall mb_entry(mbcontrol,"S_DOWN","Down",DOWN_KEY,,"D")
    xcall mb_entry(mbcontrol,"S_LEFT","Left",LEFT_KEY,,"L")
    xcall mb_entry(mbcontrol,"S_RIGHT","Right",RIGHT_KEY,,"R")
    xcall mb_end(mbcontrol,idc_select)
    .endc

    ;Create the tabset and set the title
    tabset=%ts_tabset(DTS_CREATE,"<STRUCTURE_NAME>_TAB",15,94)
    xcall w_brdr(tabset,WB_TITLE,PROGRAM_TITLE)

    ;Add a close event handler to the tabset
    close_method=%u_wndevents(D_CREATE,,D_EVENT_CLOSE,"<structure_name>mnt_close")
    xcall u_wndevents(D_ASSIGN,close_method,tabset)

    ;Add tab pages to the tabset
    xcall ts_tabset(DTS_LIST,tabset,idl_<structure_name>,"<structure_name>mnt_list")
    xcall ts_tabset(DTS_WINDOW,tabset,idi_<structure_name>,"<structure_name>mnt_input")

    ;Add buttons to the tabset
    xcall ts_tabset(DTS_BUTTON,tabset,"CREATE",DSB_TEXT,"Create",,,"C")
    xcall ts_tabset(DTS_BUTTON,tabset,"AMEND",DSB_TEXT,"Amend",,,"A")
    xcall ts_tabset(DTS_BUTTON,tabset,"DELETE",DSB_TEXT,"Delete",,,"D")
    xcall ts_tabset(DTS_BUTTON,tabset,"SAVE",DSB_TEXT,"Save",,,"S")
    xcall ts_tabset(DTS_BUTTON,tabset,"EXIT",DSB_TEXT,"Exit",,,"X")
    xcall ts_tabset(DTS_BUTTONSET,tabset,,,DSB_END,"AMEND")
    xcall b_disable(tabset,"SAVE")

    ;Place the tabset on the screem
    xcall u_window(D_PLACE,tabset,3,3)

    ;Process the tabset
    repeat
    begin

        xcall ts_process(tabset)

        ;Process menu events

        using g_entnam select
        ("CREATE"),
            call create_record
        ("AMEND"),
            xcall ts_tabset(DTS_ACTIVE,tabset,2)
        ("DELETE"),
            call delete_record
        ("SAVE"),
            call save_record
        ("ABOUT"),
            xcall u_about(PROGRAM_TITLE,PROGRAM_VERSION,%datecompiled)
        ("EXIT"),
            if (%ts_tabset(DTS_ACTIVE,tabset)==2) then
                xcall ts_tabset(DTS_ACTIVE,tabset,1)
            else
                exitloop
        ("QUIT"),
            exitloop
        endusing

    end

    ;Clean up and close down UI Toolkit
    xcall u_close(idf_<structure_name>_upd,idf_<structure_name>_inp)
    xcall u_finish

    stop

;-------------------------------------------------------------------------------
;
create_record,

    if (%u_msgbox("Create a new record ?",D_MYESNO+D_MICONQUESTION,"Confirm Create",idc_select)==D_MIDYES)
    begin
        create=TRUE
        xcall ts_tabset(DTS_ACTIVE,tabset,2)
    end

    return

;-------------------------------------------------------------------------------
;
delete_record,

    if (%u_msgbox("Delete record "+%atrim(%keyval(idf_<structure_name>_upd,
    &       <structure_name>,0))+" ?",D_MYESNO+D_MICONQUESTION,
    &       "Confirm Delete",idc_select)==D_MIDYES)
    begin
        read(idf_<structure_name>_upd,<structure_name>,
        &           %keyval(idf_<structure_name>_upd,<structure_name>,0))
        delete(idf_<structure_name>_upd)
        xcall l_process(idl_<structure_name>,req=D_LDELITEM,<structure_name>)
    end

    return

;-------------------------------------------------------------------------------
;
save_record,

    if (create) then
    begin
        ;Save new record to file
        store(idf_<structure_name>_upd,new<structure_name>) [ERR=crefl]

        ;Add a new list row
        xcall l_process(idl_<structure_name>,req=D_LINSERT,<structure_name>)

        ;Add new record to list
        <structure_name>=new<structure_name>
        xcall l_process(idl_<structure_name>,req=D_LNOP,<structure_name>)
        xcall i_display(idi_<structure_name>_lup,,<structure_name>)

        ;Switch back to list
        xcall ts_tabset(DTS_ACTIVE,tabset,1)

        clear create

        if (FALSE)
        begin
crefl,      xcall u_msgbox("Failed to save new record!",D_MICONEXCLAM,"Error")
            xcall ts_tabset(DTS_ACTIVE,tabset,2)
        end
    end
    else
    begin
        if (new<structure_name>!=<structure_name>)
        begin
            if (%u_msgbox("Save changes ?",D_MYESNO+D_MICONQUESTION,
            &               "Confirm Save",idc_select)==D_MIDYES) then
            begin
                <structure_name> = new<structure_name>
                write(idf_<structure_name>_upd,<structure_name>)
                xcall i_display(idi_<structure_name>_lup,,<structure_name>)
            end
            else
                unlock idf_<structure_name>_upd
            clear new<structure_name>
        end
        xcall ts_tabset(DTS_ACTIVE,tabset,1)
    end

    return

endmain

;*******************************************************************************
;
;
subroutine <structure_name>mnt_list

    a_lstid     ,n

.define <STRUCTURE_NAME>MNT_DATA
.include "<structure_name>mnt.dbl"

proc

    ;Setup UI for list processing
    xcall b_enable(tabset,"CREATE")
    xcall b_enable(tabset,"AMEND")
    xcall b_enable(tabset,"DELETE")
    xcall m_enable(D_LIST,idc_file,"MAIN_OPT")

    ;Process the list
    req = D_LNOP
    xcall l_select(a_lstid,req,<structure_name>,,,,,,idc_list)

    ;If the user selected a record, go to the input page
    if (!g_select)
        xcall m_signal("TS_TAB2")

    ;Reset UI
    xcall b_disable(tabset,"CREATE")
    xcall b_disable(tabset,"AMEND")
    xcall b_disable(tabset,"DELETE")
    xcall m_disable(D_LIST,idc_file,"MAIN_OPT")

    xreturn

endsubroutine

;*******************************************************************************
;
;
subroutine <structure_name>mnt_input

    a_inpid     ,n

.define <STRUCTURE_NAME>MNT_DATA
.include "<structure_name>mnt.dbl"

record
    all_done    ,i4

proc

    ;Setup UI for input processing
    xcall b_enable(tabset,"SAVE")
    xcall m_enable(D_LIST,idc_edit,"EDIT_OPT")

    ;Setup record for editing
    if (create) then
    begin
        xcall i_enable(D_SET,idi_<structure_name>,"KEY")
        xcall i_init(idi_<structure_name>,"ALL",new<structure_name>)
    end
    else
    begin
        ;Re-read and lock master file record
        read(idf_<structure_name>_upd,new<structure_name>,%keyval(idf_<structure_name>_upd,<structure_name>,0))
        ;Update data in list input window (incase it's changed)
        xcall i_display(idi_<structure_name>_lup,,<structure_name>)
        ;Display data into input window
        xcall i_display(idi_<structure_name>,"ALL",<structure_name>)
        ;Work on a copy of the data
        new<structure_name> = <structure_name>
    end

    repeat
    begin
        xcall i_next(idi_<structure_name>,"ALL","*FRST*")
        xcall i_input(idi_<structure_name>,"ALL",new<structure_name>,idc_input,idc_select,,D_NOTERM)

        if (g_select)
            exitloop
    end

    if (!create)
        if (new<structure_name>!=<structure_name>)
            xcall m_signal("SAVE")

    ;Reset UI
    xcall b_disable(tabset,"SAVE")
    xcall m_disable(D_LIST,idc_edit,"EDIT_OPT")

    xreturn

endsubroutine

;*******************************************************************************
;
;
subroutine <structure_name>mnt_load
    a_listid    ,n          ; List id
    a_req       ,n          ; Request flag
    a_data      ,a          ; Item data
    a_inpid     ,n          ; Input window id
    a_disable   ,n          ; (Optional) Disable flag
    a_index     ,n          ; Loading index

.define <STRUCTURE_NAME>MNT_DATA
.include "<structure_name>mnt.dbl"

proc

    if (a_index==1)
        find(idf_<structure_name>_inp,,^FIRST) [ERR=nousr]

    reads(idf_<structure_name>_inp,a_data,nousr) [ERR=nousr]

    xcall i_display(a_inpid,,a_data)

    if (FALSE)
nousr,  a_req = D_LEOF

    xreturn

endsubroutine

;*******************************************************************************
;
;
function <structure_name>mnt_close ,^val

.define <STRUCTURE_NAME>MNT_DATA
.include "<structure_name>mnt.dbl"

proc

    xcall m_signal("EXIT")

    freturn TRUE

endfunction

;*******************************************************************************
;
;
subroutine <structure_name>mnt_entrst

    a_nomod     ,n      ;field is not modified
    a_reset     ,n      ;field does not need resetting

.define <STRUCTURE_NAME>MNT_DATA
.include "<structure_name>mnt.dbl"

proc

    if ((g_entnam!="I_CANCEL") && (!a_nomod))
        a_reset = 0

    xreturn

endsubroutine

;*******************************************************************************
;
;
subroutine list_headings

    a_wndid         ,n  ;Input window ID (IN)
    a_headings          ,a  ;Headings (from row 2) (OUT)

.include 'WND:system.def'
.include 'WND:setinf.def'
.include 'WND:windows.def'
.include 'DBLDIR:activex.def'

stack record avars
    window_text,    a5000
    win_area,       8d3
    num_col,        d3@win_area + 9

proc

    clear avars

    xcall w_info(WI_AREAS, a_wndid, win_area)
    xcall w_info(WI_XFR, a_wndid, WIX_DGET, window_text)

    a_headings = window_text(num_col+1:num_col)

    xcall w_proc(WP_RESIZE, a_wndid, 1, num_col)
    xcall w_area(a_wndid, WA_SET, 1, 1, 1, num_col)
    xcall w_area(a_wndid, WA_COPY, WAC_PTOD)

    xreturn

endsubroutine

;*******************************************************************************
.else ;<STRUCTURE_NAME>MNT_DATA
;*******************************************************************************
;
;
.undefine <STRUCTURE_NAME>MNT_DATA

.include "WND:tools.def"
.include "WND:tkctl.def"
.include "WND:inpctl.def"
.include "WND:windows.def"
.include "DBLDIR:activex.def"

.ifdef <STRUCTURE_NAME>MNT_INIT
.undefine <STRUCTURE_NAME>MNT_INIT
global data section <STRUCTURE_NAME>MNT_DATA, init
.else
global data section <STRUCTURE_NAME>MNT_DATA
.endc

record

    ;File channels
    idf_<structure_name>_upd    ,i4     ;Master file channel (update mode)
    idf_<structure_name>_inp    ,i4     ;Master file channel (input mode for load method)

    ;Menu columns
    idc_file            ,i4     ;File menu column ID
    idc_edit            ,i4     ;Edit menu column ID
    idc_input           ,i4     ;Input menu column ID (for cell-based)
    idc_list            ,i4     ;List menu column ID (for cell-based)
    idc_select          ,i4     ;Selection menu column ID (for cell-based)

    ;Input window data
    idi_<structure_name>        ,i4     ;Maintenance input window ID
    idi_<structure_name>_lup    ,i4     ;List input window ID

    ;List data
    idl_<structure_name>        ,i4     ;List ID
    lstclass            ,i4     ;List class ID
    req                 ,i4     ;List processor request flag

    ;Tabset data
    tabset              ,i4     ;Tabset ID

    ;Miscellaneous data
    error               ,i4     ;An error occurred
    create              ,i4     ;Are we creating a new record?
    close_method        ,i4     ;Close method set

.include "<STRUCTURE_NOALIAS>" repository, record="<structure_name>"
.include "<STRUCTURE_NOALIAS>" repository, record="new<structure_name>"

endglobal

;*******************************************************************************
.endc ;<STRUCTURE_NAME>MNT_DATA
;*******************************************************************************

