
/*   
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	 MOV_QUAPRO varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 MOV_CLIENT varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_QUAPRO] DEFAULT ('') FOR [MOV_QUAPRO],
	CONSTRAINT [DF_U_MAG_MO_MOV_CLIENT] DEFAULT ('') FOR [MOV_CLIENT]
go

UPDATE U_MAG_MO SET MOV_QUAPRO = SPACE(03)
UPDATE U_MAG_MO SET MOV_CLIENT = SPACE(10)