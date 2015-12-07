<CODEGEN_FILENAME><Structure_name>_FileIO.CodeGen.dbc</CODEGEN_FILENAME>
<OPTIONAL_USERTOKEN>RPSDATAFILES= </OPTIONAL_USERTOKEN>
<OPTIONAL_USERTOKEN>DATAFILENAME="<FILE_NAME>"</OPTIONAL_USERTOKEN>
<OPTIONAL_USERTOKEN>TAGUNDEFINEOPTION=QAWSEDRFTGYH</OPTIONAL_USERTOKEN>
;//****************************************************************************
;//
;// Title:       Symphony_FileIO.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Template to provide structure based file IO
;//
;// Author:      Richard C. Morris, Synergex Professional Services Group
;//
;// Copyright (c) 2012, Synergex International, Inc. All rights reserved.
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
;;****************************************************************************
;; WARNING: This code was generated by CodeGen. Any changes that you
;;          make to this code will be overwritten if the code is regenerated!
;;
;; Template author:	Richard C. Morris, Synergex Professional Services Group
;;
;; Template Name:	Symphony Framework : <TEMPLATE>.tpl
;;****************************************************************************

import System
import System.Collections.Generic
import System.Text

import Symphony.Core
import Symphony.Conductor.Model
import Symphony.Conductor.DataIO

namespace <NAMESPACE>

	;;we will define a tag value, if we have tags fdefined for the structure
	

	<TAG_LOOP>
	.ifndef FILE_HAS_TAGS
	.define FILE_HAS_TAGS YESITDOES
	.endc
	</TAG_LOOP>

	public class <Structure_name>_FileIO extends FileIO

		;;; <summary>
		;;;  Default constructor openes the data file in input mode
		;;; </summary>
		public method <Structure_name>_FileIO
			endparams
			parent(<STRUCTURE_SIZE>)
		proc
			mOpenMode = FileOpenMode.Input
			openTheFile(<DATAFILENAME>)
		endmethod

		;;; <summary>
		;;;  Alternate constructor accepts the file open mode
		;;; </summary>
		public method <Structure_name>_FileIO
			in req openMode		,FileOpenMode
			endparams
			parent(<STRUCTURE_SIZE>)
		proc
			mOpenMode = openMode
			openTheFile(<DATAFILENAME>)
		endmethod

		protected override method checkInRange	,boolean
			in req <structure_name>Arg		,a
			endparams
			.include '<structure_name>' repository <RPSDATAFILES>, stack record = "<structure_name>", end
		proc
			<structure_name> = <structure_name>Arg
			;;do any tag values
			.ifdef FILE_HAS_TAGS
			if (
			<TAG_LOOP>
			&	<TAGLOOP_CONNECTOR_DBL> <TAGLOOP_FIELD_SQLNAME> <TAGLOOP_OPERATOR_DBL> <TAGLOOP_TAG_VALUE> 
			</TAG_LOOP>
			&	) then
				mreturn true
			else
				mreturn false
			.endc
			;;if we get here, we have no tag field!
			mreturn true
		endmethod
		
		;;this fixes when you are using tags as filters.
		.ifdef <TAGUNDEFINEOPTION>
		.undefine <TAGUNDEFINEOPTION>
		.endc
		
		;;this logic is only compiled if the structure has a tag value
		.ifdef FILE_HAS_TAGS

		;;; <summary>
		;;;  Read the first record from the file and assign the located record to a Symphony Data Object.
		;;; </summary>
		;;; <param name="dataObject">The _DATAOBJECT_ to propogate with the located data.</param>
		;;; <remarks>
		;;; The file will be read on the key index that was set by the last read operation, or the default of primary if no previous operation was performed.  The record will be locked if the file is opened in update mode and the record is successfully located.
		;;; </remarks>
		public override method ReadFirstRecord	,FileAccessResults
			in req dataObject			,@DataObjectBase
			endparams

		proc
			dataObject.InitData()
			<TAG_LOOP>
			<IF COMPARISON_EQ>
			((@<Structure_name>_Data)dataObject).<TAGLOOP_FIELD_SQLNAME> = <TAGLOOP_TAG_VALUE>
			</IF COMPARISON_EQ>
			</TAG_LOOP>
			mreturn parent.ReadRecord(dataObject)

		endmethod

		;;; <summary>
		;;;  Read the first record from the file and assign the located record to a Symphony Data Object.
		;;; </summary>
		;;; <param name="dataObject">The _DATAOBJECT_ to propogate with the located data.</param>
		;;; <remarks>
		;;; The file will be read on the key index that was set by the last read operation, or the default of primary if no previous operation was performed.
		;;; The record will not be locked.  To update the record you should use the UpdateRecordUsingGRFA method.
		;;; </remarks>
		public override method ReadFirstRecord	,FileAccessResults
			in req dataObject			,@DataObjectBase
			in req noLock				,Boolean
			endparams

		proc
			dataObject.InitData()
			<TAG_LOOP>
			<IF COMPARISON_EQ>
			((@<Structure_name>_Data)dataObject).<TAGLOOP_FIELD_SQLNAME> = <TAGLOOP_TAG_VALUE>
			</IF COMPARISON_EQ>
			</TAG_LOOP>
			mreturn parent.ReadRecord(dataObject, noLock)

		endmethod

		;;; <summary>
		;;;  Read the last record from the file and assign the located record to a Symphony Data Object.
		;;; </summary>
		;;; <param name="dataObject">The _DATAOBJECT_ to propogate with the located data.</param>
		;;; <remarks>
		;;; The file will be read on the key index that was set by the last read operation, or the default of primary if no previous operation was performed.  The record will be locked if the file is opened in update mode and the record is successfully located.
		;;; </remarks>
		public override method ReadLastRecord	,FileAccessResults
			in req dataObject			,@DataObjectBase
			endparams

		proc
			dataObject.InitData()
			<PRIMARY_KEY>
			<SEGMENT_LOOP>
<IF ALPHA>
			((@<Structure_name>_Data)dataObject).<Segment_name> = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
</IF ALPHA>
<IF NUMERIC>
			((@<Structure_name>_Data)dataObject).<Segment_name> = 99999999999999999999999999999999999999
</IF NUMERIC>
			</SEGMENT_LOOP>
			</PRIMARY_KEY>

			parent.ReadRecord(dataObject, true)
			mreturn parent.ReadPrevRecord(dataObject)

		endmethod

		;;; <summary>
		;;;  Read the last record from the file and assign the located record to a Symphony Data Object.
		;;; </summary>
		;;; <param name="dataObject">The _DATAOBJECT_ to propogate with the located data.</param>
		;;; <remarks>
		;;; The file will be read on the key index that was set by the last read operation, or the default of primary if no previous operation was performed.
		;;; The record will not be locked.  To update the record you should use the UpdateRecordUsingGRFA method.
		;;; </remarks>
		public override method ReadLastRecord	,FileAccessResults
			in req dataObject			,@DataObjectBase
			in req noLock				,Boolean
			endparams

			record
				far	,FileAccessResults
			endrecord

		proc
			dataObject.InitData()
			<PRIMARY_KEY>
			<SEGMENT_LOOP>
<IF ALPHA>
			((@<Structure_name>_Data)dataObject).<Segment_name> = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
</IF ALPHA>
<IF NUMERIC>
			((@<Structure_name>_Data)dataObject).<Segment_name> = 99999999999999999999999999999999999999
</IF NUMERIC>
			</SEGMENT_LOOP>
			</PRIMARY_KEY>

			parent.ReadRecord(dataObject, true)
			mreturn parent.ReadPrevRecord(dataObject)

		endmethod

		;;; <summary>
		;;;  Read a record from the file and assign the located record to a Symphony Data Object.
		;;; </summary>
		;;; <param name="dataObject">The _DATAOBJECT_ to use as the key value and to propogate with the located data.</param>
		;;; <remarks>
		;;; Given the passed _DATAOBJECT_ the key value will be extracted.  This key value will then be used to locate the matching record in the file.  The file will be read on the primary key index.
		;;; The record will be locked if the file is opened in update mode and the record is successfully located.
		;;; </remarks>
		public override method ReadRecord	,FileAccessResults
			in req dataObject		,@DataObjectBase
			endparams

		proc
			<TAG_LOOP>
			<IF COMPARISON_EQ>
			((@<Structure_name>_Data)dataObject).<TAGLOOP_FIELD_SQLNAME> = <TAGLOOP_TAG_VALUE>
			</IF COMPARISON_EQ>
			</TAG_LOOP>
			mreturn parent.ReadRecord(dataObject)

		endmethod

		;;; <summary>
		;;;  Read a record from the file and assign the located record to a Symphony Data Object, but do not lock the record.
		;;; </summary>
		;;; <param name="dataObject">The _DATAOBJECT_ to use as the key value and to propogate with the located data.</param>
		;;; <remarks>
		;;; Given the passed _DATAOBJECT_ the key value will be extracted.  This key value will them be used to locate the matching record in the file.  The file will be read on the primary key index. The
		;;; record will not be locked.  To subsequently perform an update, call the UpdateRecordUsingGRFA method.
		;;; </remarks>
		public override method ReadRecord	,FileAccessResults
			in req dataObject		,@DataObjectBase
			in req noLock			,Boolean
			endparams

		proc
			<TAG_LOOP>
			<IF COMPARISON_EQ>
			((@<Structure_name>_Data)dataObject).<TAGLOOP_FIELD_SQLNAME> = <TAGLOOP_TAG_VALUE>
			</IF COMPARISON_EQ>
			</TAG_LOOP>
			mreturn parent.ReadRecord(dataObject, noLock)

		endmethod

		;;; <summary>
		;;;  Update the currently locked record the file.
		;;; </summary>
		;;; <param name="dataObject">The _DATAOBJECT_ to use as the value and to update the locked record.</param>
		;;; <remarks>
		;;; Given the passed _DATAOBJECT_ the data will be extracted and used to update the currently locked record.
		;;; </remarks>
		public override method UpdateRecord	,FileAccessResults
			in req dataObject		,@DataObjectBase
			endparams

		proc
			mreturn parent.UpdateRecord(dataObject)
		endmethod

		;;; <summary>
		;;;  Update the record to referecned by it's Global RFA.
		;;; </summary>
		;;; <param name="dataObject">The _DATAOBJECT_ to use as the value and to locate and updated the record.</param>
		;;; <remarks>
		;;; Given the passed _DATAOBJECT_ the data will be extracted and used to loate and update the record.
		;;; </remarks>
		public override method UpdateRecordUsingGRFA	,FileAccessResults
			in req dataObject				,@DataObjectBase
			endparams

		proc
			mreturn parent.UpdateRecordUsingGRFA(dataObject)
		endmethod

		;;; <summary>
		;;;  Create a new record within the data files.
		;;; </summary>
		;;; <remarks>
		;;; The passed-in _DATAOBJECT_ will will be created in the data files.
		;;; </remarks>
		public override method CreateRecord	,FileAccessResults
			in req dataObject		,@DataObjectBase
			endparams

		proc
			mreturn parent.CreateRecord(dataObject)
		endmethod
		
		.ifdef FILE_HAS_TAGS
		.undefine FILE_HAS_TAGS
		.endc
		.endc
	endclass

endnamespace


