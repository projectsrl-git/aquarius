
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_CA] ADD 
	 CAS_NUMFAT varchar(6) COLLATE Latin1_General_CI_AS NULL,
	 CAS_DATFAT varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_CA_CAS_NUMFAT] DEFAULT ('') FOR [CAS_NUMFAT],
	CONSTRAINT [DF_U_PDV_CA_CAS_DATFAT] DEFAULT ('') FOR [CAS_DATFAT]
go
