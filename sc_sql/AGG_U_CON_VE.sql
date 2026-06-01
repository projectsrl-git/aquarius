/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_VE] ADD 
	 	 CON_CODNAZ varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 	 CON_DESNAZ varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_VE] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_VE_CON_CODNAZ] DEFAULT ('') FOR [CON_CODNAZ],
	CONSTRAINT [DF_U_CON_VE_CON_DESNAZ] DEFAULT ('') FOR [CON_DESNAZ]
go

UPDATE U_CON_VE SET CON_CODNAZ 	= 'ITA'
UPDATE U_CON_VE SET CON_DESNAZ 	= 'ITALIA'
