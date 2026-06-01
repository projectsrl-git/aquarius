
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
		 ORD_QTAPCK numeric (17,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ORD_DD_ORD_QTAPCK] DEFAULT ('0')    FOR [ORD_QTAPCK]
go


UPDATE U_ORD_DD SET ORD_QTAPCK 	= 0 
