
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_IVA_CR] ADD 
		 IVA_DARIPO numeric (17,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_IVA_CR] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_IVA_CR_IVA_DARIPO] DEFAULT ('0')    FOR [IVA_DARIPO]
go


UPDATE U_IVA_CR SET IVA_DARIPO 	= 0 
