/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_RIA_TT] ADD 
		 ORD_IMPCASPR numeric(17,3)  NULL,
		 ORD_IVACASPR numeric(17,3)  NULL,
	 	 ORD_CIVCASPR varchar(03) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_RIA_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_RIA_TT_ORD_IMPCASPR]  DEFAULT (0) FOR [ORD_IMPCASPR],
	CONSTRAINT [DF_U_RIA_TT_ORD_IVACASPR]  DEFAULT (0) FOR [ORD_IVACASPR],
	CONSTRAINT [DF_U_RIA_TT_ORD_CIVCASPR]   DEFAULT ('   ') FOR [ORD_CIVCASPR]

go

UPDATE U_RIA_TT SET ORD_IMPCASPR = 0
UPDATE U_RIA_TT SET ORD_IVACASPR = 0
UPDATE U_RIA_TT SET ORD_CIVCASPR = SPACE(03)