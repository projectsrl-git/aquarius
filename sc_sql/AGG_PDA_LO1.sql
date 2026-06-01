
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDA_LO] ADD 
	 PDA_DADOVE varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDA_LO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDA_LO_PDA_DADOVE] DEFAULT ('') FOR [PDA_DADOVE]
go

UPDATE U_PDA_LO SET PDA_DADOVE = 'PDA'