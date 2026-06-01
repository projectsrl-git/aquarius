
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BOL_TT] ADD 
	 ORD_ATTENZIONE varchar(200) COLLATE Latin1_General_CI_AS NULL,
	 ORD_VARIE varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_TT_ORD_ATTENZIONE] DEFAULT ('') FOR [ORD_ATTENZIONE],
	CONSTRAINT [DF_U_BOL_TT_ORD_VARIE] DEFAULT ('') FOR [ORD_VARIE]
go

UPDATE U_BOL_TT SET ORD_ATTENZIONE = ''
UPDATE U_BOL_TT SET ORD_VARIE = ''
