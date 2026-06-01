/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	MOV_NUMMOV VARCHAR(06) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_NUMMOV] DEFAULT ('') FOR [MOV_NUMMOV]	
go

UPDATE U_MAG_MO SET MOV_NUMMOV = SPACE(06)
