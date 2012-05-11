$ ! ***************************************************************************
$ !
$ ! Title:       BUILD.COM
$ !
$ ! Type:        OpenVMS DCL Command Procedure
$ !
$ ! Description: Builds CodeGen and utilities under OpenVMS
$ !
$ ! Date:        11th May 2012
$ !
$ ! Author:      Steve Ives, Synergex Professional Services Group
$ !              http://www.synergex.com
$ !
$ ! ***************************************************************************
$ !
$ ! Copyright (c) 2012, Synergex International, Inc.
$ ! All rights reserved.
$ !
$ ! Redistribution and use in source and binary forms, with or without
$ ! modification, are permitted provided that the following conditions are met:
$ !
$ ! * Redistributions of source code must retain the above copyright notice,
$ !   this list of conditions and the following disclaimer.
$ !
$ ! * Redistributions in binary form must reproduce the above copyright notice,
$ !   this list of conditions and the following disclaimer in the documentation
$ !   and/or other materials provided with the distribution.
$ !
$ ! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
$ ! AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
$ ! IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
$ ! ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
$ ! LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
$ ! CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
$ ! SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
$ ! INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
$ ! CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
$ ! ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
$ ! POSSIBILITY OF SUCH DAMAGE.
$ !
$ ! ***************************************************************************
$ !
$ BUILDLOC = F$PARSE(F$ENVIRONMENT("PROCEDURE"),,,"DEVICE") + F$PARSE(F$ENVIRONMENT("PROCEDURE"),,,"DIRECTORY")
$ SET DEF 'BUILDLOC
$ !
$ ROOT = F$EXTRACT(0,F$LOCATE("TRADITIONALSYNERGY.OPENVMS]",BUILDLOC),BUILDLOC)
$ !
$ RPSPATH     = ROOT + "REPOSITORYAPI]"
$ ENGINEPATH  = ROOT + "CODEGENENGINE]"
$ MAINPATH    = ROOT + "CODEGEN]"
$ MAPPREPPATH = ROOT + "MAPPREP]"
$ RPSINFOPATH = ROOT + "RPSINFO]"
$ HDRPATH     = ROOT + "TRADITIONALSYNERGY.OPENVMS.HDR]
$ OBJPATH     = ROOT + "TRADITIONALSYNERGY.OPENVMS.OBJ]
$ EXEPATH     = ROOT + "TRADITIONALSYNERGY.OPENVMS.EXE]
$ !
$ DEFINE/NOLOG VMS_ROOT         'BUILDLOC
$ DEFINE/NOLOG REPOSITORY_SRC   'RPSPATH
$ DEFINE/NOLOG CODEGEN_SRC      'ENGINEPATH
$ DEFINE/NOLOG MAINLINE_SRC     'MAINPATH
$ DEFINE/NOLOG MAPPREP_SRC      'MAPPREPPATH
$ DEFINE/NOLOG RPSINFO_SRC      'RPSINFOPATH
$ DEFINE/NOLOG CODEGEN_LIB      'OBJPATH
$ DEFINE/NOLOG CODEGEN_OBJ      'OBJPATH
$ DEFINE/NOLOG CODEGEN_EXE      'EXEPATH
$ DEFINE/NOLOG SYNEXPDIR        'HDRPATH
$ DEFINE/NOLOG SYNIMPDIR        'HDRPATH
$ DEFINE/NOLOG SYNXML_SH        DBLDIR:SYNXML.EXE
$ !
$ !Check that the directories that are not created by the CodePlex download
$ !exist on the system
$ !
$ SET MESSAGE/NOFAC/NOSEV/NOID/NOTEXT
$ SET NOON
$ CREATE/DIR CODEGEN_OBJ:
$ CREATE/DIR CODEGEN_EXE:
$ CREATE/DIR SYNEXPDIR:
$ ON ERROR THEN EXIT
$ SET MESSAGE/FAC/SEV/ID/TEXT
$ !
$ IF "''P1'".EQS."ALL"       THEN GOTO RPSAPI
$ IF "''P1'".EQS."RPSAPI"    THEN GOTO RPSAPI
$ IF "''P1'".EQS."ENGINE"    THEN GOTO ENGINE
$ IF "''P1'".EQS."CODEGEN"   THEN GOTO CODEGEN
$ IF "''P1'".EQS."UTILITIES" THEN GOTO UTILITIES
$ !
$ WRITE SYS$OUTPUT "Specify ALL, RPSAPI, ENGINE, CODEGEN or UTILITIES"
$ EXIT
$ !
$ !----------------------------------------------------------------------------
$ RPSAPI:
$ !
$ ! Concatenate the partial class files
$ !
$ IF F$SEARCH("REPOSITORY_SRC:RpsField.dbl").NES."" .AND. F$SEARCH("REPOSITORY_SRC:RpsField_CodeGen.dbl").NES.""
$ THEN
$    PURGE/NOLOG/NOCONF REPOSITORY_SRC:RpsField.dbl
$    PURGE/NOLOG/NOCONF REPOSITORY_SRC:RpsField_CodeGen.dbl
$    RENAME REPOSITORY_SRC:RpsField.dbl REPOSITORY_SRC:RpsField.original
$    RENAME REPOSITORY_SRC:RpsField_CodeGen.dbl REPOSITORY_SRC:RpsField_CodeGen.original
$    COPY REPOSITORY_SRC:RpsField.original+REPOSITORY_SRC:RpsField_CodeGen.original REPOSITORY_SRC:RpsField.dbl
$ ENDIF
$ !
$ IF F$SEARCH("REPOSITORY_SRC:RpsStructure.dbl").NES."" .AND. F$SEARCH("REPOSITORY_SRC:RpsStructure_CodeGen.dbl").NES.""
$ THEN
$    PURGE/NOLOG/NOCONF REPOSITORY_SRC:RpsStructure.dbl
$    PURGE/NOLOG/NOCONF REPOSITORY_SRC:RpsStructure_CodeGen.dbl
$    RENAME REPOSITORY_SRC:RpsStructure.dbl REPOSITORY_SRC:RpsStructure.original
$    RENAME REPOSITORY_SRC:RpsStructure_CodeGen.dbl REPOSITORY_SRC:RpsStructure_CodeGen.original
$    COPY REPOSITORY_SRC:RpsStructure.original+REPOSITORY_SRC:RpsStructure_CodeGen.original REPOSITORY_SRC:RpsStructure.dbl
$ ENDIF
$ !
$ WRITE SYS$OUTPUT "Prototyping repository API ..."
$ IF F$SEARCH("SYNEXPDIR:CODEGEN-REPOSITORYAPI-*.DBP").NES."" THEN DELETE/NOLOG/NOCONF SYNEXPDIR:CODEGEN-REPOSITORYAPI-*.DBP;*
$ DBLPROTO REPOSITORY_SRC:*.DBL
$ !
$ WRITE SYS$OUTPUT "Creating library CODEGEN_LIB:REPOSITORYAPI.OLB ..."
$ LIB/CREATE CODEGEN_LIB:REPOSITORYAPI.OLB
$ !
$ WRITE SYS$OUTPUT "Compiling repository API ..."
$ RPS_LOOP:
$     FILE = F$SEARCH("REPOSITORY_SRC:*.DBL")
$     IF FILE .EQS. "" THEN GOTO RPSAPI_DONE
$     NAME = F$PARSE(FILE,,,"NAME")
$     CALL REPOSITORY_BUILD 'NAME
$     GOTO RPS_LOOP
$ !
$ RPSAPI_DONE:
$ !
$ IF "''P1'".EQS."RPSAPI" THEN GOTO DONE
$ !
$ !----------------------------------------------------------------------------
$ ENGINE:
$ !
$ WRITE SYS$OUTPUT "Prototyping CodeGen Engine ..."
$ IF F$SEARCH("SYNEXPDIR:CODEGEN-ENGINE-.DBP").NES."" THEN DELETE/NOLOG/NOCONF SYNEXPDIR:CODEGEN-ENGINE-*.DBP;*
$ DBLPROTO CODEGEN_SRC:*.DBL
$ !
$ WRITE SYS$OUTPUT "Creating library LIB:CODEGENENGINE.OLB ..."
$ LIB/CREATE CODEGEN_LIB:CODEGENENGINE.OLB
$ !
$ WRITE SYS$OUTPUT "Compiling CodeGen Engine ..."
$ ENGINE_LOOP:
$     FILE = F$SEARCH("CODEGEN_SRC:*.DBL")
$     IF FILE .EQS. "" THEN GOTO ENGINE_DONE
$     NAME = F$PARSE(FILE,,,"NAME")
$     CALL ENGINE_BUILD 'NAME
$     GOTO ENGINE_LOOP
$ !
$ ENGINE_DONE:
$ !
$ IF "''P1'".EQS."ENGINE" THEN GOTO DONE
$ !
$ !----------------------------------------------------------------------------
$ CODEGEN:
$ !
$ WRITE SYS$OUTPUT " - Building CodeGen ..."
$ DIB/OPT/OBJ=CODEGEN_OBJ:CODEGEN.OBJ MAINLINE_SRC:CODEGEN.DBL
$ LINK/EXE=CODEGEN_EXE:CODEGEN.EXE CODEGEN_OBJ:CODEGEN.OBJ,VMS_ROOT:CODEGEN/OPT
$ !
$ IF "''P1'".EQS."CODEGEN" THEN GOTO DONE
$ !
$ !----------------------------------------------------------------------------
$ UTILITIES:
$ !
$ WRITE SYS$OUTPUT " - Building MapPrep ..."
$ DIB/OPT/OBJ=CODEGEN_OBJ:MAPPREP.OBJ MAPPREP_SRC:MAPPREP.DBL
$ LINK/EXE=CODEGEN_EXE:MAPPREP.EXE CODEGEN_OBJ:MAPPREP.OBJ,VMS_ROOT:CODEGEN/OPT
$ !
$ WRITE SYS$OUTPUT " - Building RpsInfo ..."
$ DIB/OPT/OBJ=CODEGEN_OBJ:RPSINFO.OBJ RPSINFO_SRC:RPSINFO.DBL
$ LINK/EXE=CODEGEN_EXE:RPSINFO.EXE CODEGEN_OBJ:RPSINFO.OBJ,VMS_ROOT:CODEGEN/OPT
$ !
$ IF "''P1'".EQS."UTILITIES" THEN GOTO DONE
$ !
$ !----------------------------------------------------------------------------
$ ! SUBROUTINES
$ !
$ REPOSITORY_BUILD: SUBROUTINE
$ !
$ WRITE SYS$OUTPUT " - Building ''P1'"
$ DIB/OPT/OBJ=CODEGEN_OBJ:'P1.OBJ REPOSITORY_SRC:'P1.DBL
$ LIB/REPLACE CODEGEN_LIB:REPOSITORYAPI.OLB CODEGEN_OBJ:'P1.OBJ
$ !
$ EXIT
$ ENDSUBROUTINE
$ !
$ ENGINE_BUILD: SUBROUTINE
$ !
$ WRITE SYS$OUTPUT " - Building ''P1'"
$ DIB/OPT/OBJ=CODEGEN_OBJ:'P1.OBJ CODEGEN_SRC:'P1.DBL
$ LIB/REPLACE CODEGEN_LIB:CODEGENENGINE.OLB CODEGEN_OBJ:'P1.OBJ
$ !
$ EXIT
$ ENDSUBROUTINE
$ !
$ !----------------------------------------------------------------------------
$ DONE:
$ !
$ EXIT