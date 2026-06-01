/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ART_PR] ADD 
	 ART_CDDIBA varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 ART_DSDIBA varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_CDDIBA] DEFAULT ('') FOR [ART_CDDIBA],
	CONSTRAINT [DF_U_ART_PR_ART_DSDIBA] DEFAULT ('') FOR [ART_DSDIBA]
go

UPDATE U_ART_PR SET ART_CDDIBA = SPACE(16)
UPDATE U_ART_PR SET ART_DSDIBA = SPACE(50)
