
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_CA] ADD 
	 CAS_LEGSYS varchar(10) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_CA_CAS_LEGSYS] DEFAULT ('') FOR [CAS_LEGSYS]
go

UPDATE U_PDV_CA SET CAS_LEGSYS = SPACE(10)


