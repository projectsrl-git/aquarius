
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 IDAnaAzi varchar(32) COLLATE Latin1_General_CI_AS NULL,
	 Codice varchar(16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_IDAnaAzi] DEFAULT ('') FOR [IDAnaAzi],
	CONSTRAINT [DF_U_FOR_AN_Codice] DEFAULT ('') FOR [Codice]
go

UPDATE U_FOR_AN SET IDAnaAzi = ''
UPDATE U_FOR_AN SET Codice = ''