<CODEGEN_FILENAME>Frm<WindowName>.xaml.vb</CODEGEN_FILENAME>
;//****************************************************************************
;//
;// Title:       vb_xaml_codebehind.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Template to generate the code-behind file for a a VB.NET
;//              WPF From representing a Synergy repository structure.
;//
;// Date:        24th March 2008
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
'******************************************************************************
'
' Title:        Frm<WindowName>.xaml.vb
'
' Author:       <AUTHOR>
'
' Company:      <COMPANY>
'
'******************************************************************************
'
' WARNING:      This code was generated by CodeGen.  Any changes that you make
'               to this file will be lost if the code is regenerated.
'
'******************************************************************************
'
Partial Public Class Frm<WindowName>

    Private Sub Frm<WindowName>_Loaded(ByVal sender As System.Object, ByVal e As System.Windows.RoutedEventArgs)

        'Add any required form initialization code

    End Sub

    Private Sub BtnOK_Click(ByVal sender As System.Object, ByVal e As System.Windows.RoutedEventArgs)

        'The user clicked the OK button

        'Perform field validations
        IF ValidateFields() Then

            'TODO: Add any additional OK button code

            Me.Close()

        End If

    End Sub

    Private Sub BtnCancel_Click(ByVal sender As System.Object, ByVal e As System.Windows.RoutedEventArgs)

        'The user clicked the Cancel button

        'TODO: Add any additional Cancel button code

        Me.Close()

    End Sub

    Private Function ValidateFields() as Boolean

        <FIELD_LOOP>
        <IF TEXTBOX>
        If Not Validate_txt<Field_sqlname>() Then Return False
        </IF>
        </FIELD_LOOP>

        Return True

    End Function

    <FIELD_LOOP>
    <IF TEXTBOX>
    Private Function Validate_Txt<Field_sqlname>() As Boolean

        <IF REQUIRED>
        '<FIELD_PROMPT> (Txt<Field_sqlname>) is a required field and must contain a value
        If (Txt<Field_sqlname>.Text.Length = 0) Then
            MessageBox.Show(me, "<FIELD_PROMPT> is a required field.", "Validation failed")
            Txt<Field_sqlname>.Focus()
            Return False
        End If

        </IF>
        <IF NUMERIC>
        'If <FIELD_PROMPT> (Txt<Field_sqlname>) contains a value then it must be numeric
        If ((Txt<Field_sqlname>.Text.Length <> 0) And (Not IsNumeric(Txt<Field_sqlname>.Text)))
            MessageBox.Show(me, "Employee must be numeric.", "Validation failed")
            Txt<Field_sqlname>.Clear()
            Txt<Field_sqlname>.Focus()
            Return False
        End If

        </IF>
        Return True

    End Function
    </IF>

    </FIELD_LOOP>

End Class
