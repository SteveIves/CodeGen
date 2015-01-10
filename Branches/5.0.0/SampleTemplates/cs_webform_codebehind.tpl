<CODEGEN_FILENAME>frm<WindowName>.aspx.cs</CODEGEN_FILENAME>
;//****************************************************************************
;//
;// Title:       cs_webform_codebehind.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Template to generate the code-behind for a a C# / ASP.NET
;//              2.0 Web From to represent a Synergy repository structure.
;//
;// Date:        22nd October 2007
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
//*****************************************************************************
//
// Class:       frm<WindowName>.aspx.cs
//
// Author:      <AUTHOR>
//
// Company:     <COMPANY>
//
//*****************************************************************************
//
// WARNING:     This code was generated by CodeGen. Any changes that you make
//              to this file will be lost if the code is regenerated.
//
//*****************************************************************************
//
using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class frm<WindowName> : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        <FIELD_LOOP>
        <IF COMBOBOX>
        if (!IsPostBack)
        {
            cbo<Field_Sqlname>_load(<FIELD_SELECTIONS>);
        }
        </IF>
    </FIELD_LOOP>

    }

    protected void btnOk_Click(object sender, EventArgs e)
    {

    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {

    }

/*
    private void LoadForm(ref <Structure_Name> obj<Structure_Name>)
    {
        <FIELD_LOOP>
        txt<Field_Sqlname>.Text = obj<Structure_Name>.<Field_Sqlname>
        </FIELD_LOOP>
    }
*/

/*
    private void UnloadForm(ref <Structure_Name> obj<Structure_Name>)
    {
        <FIELD_LOOP>
        obj<Structure_Name>.<Field_Sqlname> = txt<Field_Sqlname>.Text
        </FIELD_LOOP>
    }
*/

    <FIELD_LOOP>
    <IF COMBOBOX>
    private void cbo<Field_Sqlname>_load(params string[] values)
    {
        for (int i = 0; i < values.Length; i++)
        {
            cbo<Field_Sqlname>.Items.Add(values[i]);
        }
    }

    </IF>
    </FIELD_LOOP>
}

