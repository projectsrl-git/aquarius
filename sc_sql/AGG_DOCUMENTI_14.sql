/* 
***********************************************
INSERIMENTO NUOVO CAMPO "Motivazione scaduto"
***********************************************

*/
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_DATCOL varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_TT_ORD_DATCOL] DEFAULT ('')
go

ALTER TABLE [dbo].[U_BOL_TT] ADD 
	 ORD_DATCOL varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_BOL_TT_ORD_DATCOL] DEFAULT ('')
go

ALTER TABLE [dbo].[L_BOL_TT] ADD 
	 ORD_DATCOL varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_L_BOL_TT_ORD_DATCOL] DEFAULT ('')
go


ALTER TABLE [dbo].[U_FAT_TT] ADD 
	 ORD_DATCOL varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_FAT_TT_ORD_DATCOL] DEFAULT ('')
go
