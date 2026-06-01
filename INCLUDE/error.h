***************************************************************************************************************************
*-- Error handle
***************************************************************************************************************************
#DEFINE cnAERRORARRAY				7 			

***************************************************************************************************************************
*-- AERROR() array dimensions, including added extensions:
***************************************************************************************************************************
#DEFINE cnAERR_NUMBER				1
#DEFINE cnAERR_MESSAGE				2
#DEFINE cnAERR_OBJECT				3
#DEFINE cnAERR_WORKAREA				4
#DEFINE cnAERR_TRIGGER				5
#DEFINE cnAERR_EXTRA1				6
#DEFINE cnAERR_EXTRA2				7
#DEFINE cnAERR_METHOD				8
#DEFINE cnAERR_LINE					9
#DEFINE cnAERR_SOURCE				10
#DEFINE cnAERR_DATETIME				11
#DEFINE cnAERR_USER					12
#DEFINE cnAERR_MAX					cnAERR_USER

***************************************************************************************************************************
*-- VFP error numbers:
***************************************************************************************************************************
#DEFINE cnERR_FILE_NOT_FOUND		1	    &&-- File does not exist
#DEFINE cnERR_REC_OUT_OF_RANGE		5	    &&-- Record out of range
#DEFINE cnERR_ARGUMENT_INVALID      11	    &&-- Function argument value, type, or count is invalid
#DEFINE cnERR_ALIAS_NOTFOUND		13	    &&-- Alias is not found
#DEFINE cnERR_INDEX_FILE_TABLE      19	    &&-- Index file doesn't match table
#DEFINE cnERR_INVALID_SUBSCRIPT		31      &&-- Invalid subscrip reference
#DEFINE cnERR_NO_FIELDS             47	    &&-- No fields found to process
#DEFINE cnERR_NO_TABLE_SELECTED     52	    &&-- No table is open in the current work area
#DEFINE cnERR_FILEINUSE				108	    &&-- File in use by another user
#DEFINE cnERR_RECINUSE				109	    &&-- Record in use by another user
#DEFINE cnERR_INDEX_MATCH_TABLE     114	    &&-- Index doesn't match table
#DEFINE cnERR_ARRAYDIM				230	    &&-- Array dimensions are invalid
#DEFINE cnERR_USER_DEFINED			1098	&&-- User-DEFINEd error
#DEFINE cnERR_TOO_FEW_ARGS			1229	&&-- Too few arguments
#DEFINE cnERR_SUBSCRIPT_RANGE       1234	&&-- Subscript is outside DEFINEd range
#DEFINE cnERR_OLE_ERROR_IN_GEN_FLD  1420	&&-- OLE error in General field
#DEFINE cnERR_OLE_EXEC_FAIL         1426	&&-- OLE error: remote procedure call failed
#DEFINE cnERR_OLE_ERROR             1429	&&-- OLE error
#DEFINE cnERR_EXECUTION_CANCELED    1523	&&-- Execution was canceled by user
#DEFINE cnERR_TRIGGER_FAILED		1539	&&-- Trigger failed
#DEFINE cnERR_PROPERTY_INVALID      1560	&&-- Property value invalid
#DEFINE cnERR_PRIM_KEY_INVALID		1567	&&-- Primary key property invalid
#DEFINE cnERR_NONULLS				1581	&&-- Field does not accept null values
#DEFINE cnERR_FIELD_RULE_FAILED		1582	&&-- Field validation rule is violated
#DEFINE cnERR_TABLE_RULE_FAILED		1583	&&-- Record validation rule is violated
#DEFINE cnERR_RECMODIFIED			1585	&&-- Update conflict
#DEFINE cnERR_TAG_NOT_FOUND         1683	&&-- Index tag is not found
#DEFINE cnERR_ACCESS_DENIED			1705	&&-- File access is denied
#DEFINE cnERR_CDX_NOT_FOUND			1707	&&-- Structural CDX not found
#DEFINE cnERR_PROPERTY_TYPE_INVALID 1732	&&-- Data type invalid for this property
#DEFINE cnERR_PROPERTY_READ_ONLY	1743	&&-- Property is read-only
#DEFINE cnERR_DUPLKEY				1884	&&-- Uniqueness of index is violated
#DEFINE cnERR_DE_UNLOADED			1967	&&-- Data environment is already unloaded
#DEFINE cnERR_TABLE_IN_USE			1995	&&-- Error loading the data environment: table is in use
#DEFINE cnERR_TABLE_MOVED			2004	&&-- The table has moved
#DEFINE cnERR_CANT_SET_FOCUS        2012	&&-- Cannot call SetFocus from within a When, Valid ...

***************************************************************************************************************************
*-- Error resolution return values.
***************************************************************************************************************************
#DEFINE ccMSG_RETRY					'Retry'
#DEFINE ccMSG_CONTINUE				'Continue'
#DEFINE ccMSG_CLOSEFORM				'Close Form'
#DEFINE ccMSG_QUIT					'Quit'
#DEFINE ccMSG_CANCEL				'Cancel'
#DEFINE ccMSG_DEBUG                 'Debug'

***************************************************************************************************************************
*-- Error message strings.
***************************************************************************************************************************
#DEFINE ccMSG_ERROR_NUM				'Error #:'
#DEFINE ccMSG_MESSAGE				'Message:'
#DEFINE ccMSG_LINE_NUM				'Line #:'
#DEFINE ccMSG_CODE					'Code:'
#DEFINE ccMSG_METHOD				'Method:'

***************************************************************************************************************************
*--  Errorlogviewer class
***************************************************************************************************************************
#DEFINE ccERR_VIEWER_CAPTION_LOC     "Error Log Viewer"
#DEFINE ccERR_VIEWER_EMPTY_LOC       "The error log has no records."
#DEFINE ccERR_VIEWER_UNAVAILABLE_LOC "The error log is not available."
#DEFINE ccERR_VIEWER_IN_USE_LOC      "The error log is in use, please close before ontinuing."

***************************************************************************************************************************
*--  Form's errors
***************************************************************************************************************************
#DEFINE ccERR_FRM_CANNOT_RUN_LOC           "Form cannot run."                      
#DEFINE ccERR_TITLE_CANNOT_INSTANTIATE_LOC "Instantiation Error"

***************************************************************************************************************************
*--  DBC's errors
***************************************************************************************************************************
#DEFINE ccERR_UNIQUEKEY_LOC   		 "A unique key error violation has occurred."
#DEFINE ccERR_UNIQUEKEY2_LOC   		 "Would you like to revert changes?"
#DEFINE ccERR_TABLEINUSE_LOC   		 "Error: Table is in use. The table may already be opened exclusively."

***************************************************************************************************************************
*--  Expression Validtion's errors
***************************************************************************************************************************
#DEFINE ccERR_SYNTAX_ERROR           "Syntax error"
#DEFINE ccERR_IN_DATA_GROUP_EXPR     "Error in Data Grouping expression"






