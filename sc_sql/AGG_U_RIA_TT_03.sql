/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_RIA_TT] ADD 
		 ORD_PERENA numeric(10,3)  NULL,
		 ORD_IMPENA numeric(17,3)  NULL,
		 ORD_TOTENA numeric(17,3)  NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_RIA_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_RIA_TT_ORD_PERENA]  DEFAULT (0) FOR [ORD_PERENA],
	CONSTRAINT [DF_U_RIA_TT_ORD_IMPENA]  DEFAULT (0) FOR [ORD_IMPENA],
	CONSTRAINT [DF_U_RIA_TT_ORD_TOTENA]  DEFAULT (0) FOR [ORD_TOTENA]

go

UPDATE U_RIA_TT SET ORD_PERENA = 0
UPDATE U_RIA_TT SET ORD_TOTENA = 0
UPDATE U_RIA_TT SET ORD_IMPENA = 0