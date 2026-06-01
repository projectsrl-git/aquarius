/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_ART_AN] ADD 
	ART_CODTSN varchar(3) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ART_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_AN_ART_CODTSN] DEFAULT ('') FOR [ART_CODTSN]
go


UPDATE U_ART_AN SET ART_CODTSN = ''
