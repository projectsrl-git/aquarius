
/*   
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_GG] ADD 
	 MAG_QUAPRO varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GG_MAG_QUAPRO] DEFAULT ('') FOR [MAG_QUAPRO]
go

UPDATE U_MAG_GG SET MAG_QUAPRO = SPACE(03)