
/*  
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[VENDITE_TT] ADD 
	ORD_DATSCA varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_DATSCA] DEFAULT (''),
	ORD_DATCOM varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_DATCOM] DEFAULT (''),
	ORD_CDC varchar(13) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_CDC] DEFAULT (''),
	ORD_PROSPECT  BIT NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_PROSPECT] DEFAULT (0)
GO



