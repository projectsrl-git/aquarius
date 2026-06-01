
/*  
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[VENDITE_TT] ADD 
	ORD_DTPROGR varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_DTPROGR] DEFAULT (''),
	ORD_ORAINIPRO varchar(8) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_ORAINIPRO] DEFAULT (''),
	ORD_ORAFINPRO varchar(8) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_ORAFINPRO] DEFAULT (''),
	ORD_ZONA varchar(6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_ZONA] DEFAULT ('')
GO


