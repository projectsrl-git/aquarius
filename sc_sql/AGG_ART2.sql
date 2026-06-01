
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ART_PR] ADD 
	 ART_FLGRES bit NULL,
	 ART_NUMRES numeric(3) NULL,
	 ART_DATRES varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_FLGRES] DEFAULT (0) FOR [ART_FLGRES],
	CONSTRAINT [DF_U_ART_PR_ART_NUMRES] DEFAULT (0) FOR [ART_NUMRES],
	CONSTRAINT [DF_U_ART_PR_ART_DATRES] DEFAULT ('') FOR [ART_DATRES]
go