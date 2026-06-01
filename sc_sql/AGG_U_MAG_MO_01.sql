/* 
**************************************************************
INSERIMENTO NUOVO CAMPO PER U_MAG_MO
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	 MOV_DOCMOD BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_DOCMOD] DEFAULT (0) FOR [MOV_DOCMOD]
go

UPDATE U_MAG_MO SET MOV_DOCMOD = 0
