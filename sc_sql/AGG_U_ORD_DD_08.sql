
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
		 ORD_PRODOT numeric (10,2) NULL,
	         ORD_INPROD bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_ORD_DD] WITH NOCHECK ADD 
        CONSTRAINT [DF_U_ORD_DD_ORD_PRODOT] DEFAULT ('0')    FOR [ORD_PRODOT],
        CONSTRAINT [DF_U_ORD_DD_ORD_INPROD] DEFAULT (0)      FOR [ORD_INPROD]
go

UPDATE U_ORD_DD SET ORD_PRODOT 	= 0 
UPDATE U_ORD_DD SET ORD_INPROD 	= 0 
