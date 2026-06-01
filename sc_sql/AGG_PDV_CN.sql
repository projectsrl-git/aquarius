
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PDV_CN] ADD 
	 CAS_TIPO varchar(2) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_CN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_CN_CAS_TIPO] DEFAULT ('') FOR [CAS_TIPO]
go