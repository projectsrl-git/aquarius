
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
		 ORD_ALTEZD numeric (5,0) NULL,
		 ORD_LUNGHD numeric (6,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ORD_DD_ORD_ALTEZD] DEFAULT ('0')    FOR [ORD_ALTEZD],
        CONSTRAINT [DF_U_ORD_DD_ORD_LUNGHD] DEFAULT ('0')    FOR [ORD_LUNGHD]
go


UPDATE U_ORD_DD SET ORD_ALTEZD 	= 0 

UPDATE U_ORD_DD SET ORD_LUNGHD 	= 0 