
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_LOC_AN] ADD 
	 LOC_ATTENZIONE varchar(200) COLLATE Latin1_General_CI_AS NULL,
	 LOC_VARIE varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LOC_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LOC_AN_LOC_ATTENZIONE] DEFAULT ('') FOR [LOC_ATTENZIONE],
	CONSTRAINT [DF_U_LOC_AN_LOC_VARIE] DEFAULT ('') FOR [LOC_VARIE]
go

UPDATE U_LOC_AN SET LOC_ATTENZIONE = ''
UPDATE U_LOC_AN SET LOC_VARIE = ''
