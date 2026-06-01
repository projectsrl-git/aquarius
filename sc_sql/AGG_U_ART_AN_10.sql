/***************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
***************************************************************/

ALTER TABLE [dbo].[U_ART_AN] ADD 
	art_ccoacq varchar(13) COLLATE Latin1_General_CI_AS NULL,
	art_cgeacq varchar(13) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_ART_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_AN_art_ccoacq] DEFAULT ('') FOR [art_ccoacq],
	CONSTRAINT [DF_U_ART_AN_art_cgeacq] DEFAULT ('') FOR [art_cgeacq]
go


UPDATE U_ART_AN SET art_ccoacq = '' 
UPDATE U_ART_AN SET art_cgeacq = '' 
