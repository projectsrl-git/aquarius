/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_RIA_TT] ADD 
		 ORD_IMPSPESE numeric(17,3)  NULL,
		 ORD_IVASPESE numeric(17,3)  NULL,
	 	 ORD_CODIVA varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 	 ORD_CIVSPE varchar(03) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_RIA_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_RIA_TT_ORD_IMPSPESE]  DEFAULT (0) FOR [ORD_IMPSPESE],
	CONSTRAINT [DF_U_RIA_TT_ORD_IVASPESE]  DEFAULT (0) FOR [ORD_IVASPESE],
	CONSTRAINT [DF_U_RIA_TT_ORD_CODIVA]    DEFAULT ('   ') FOR [ORD_CODIVA],
	CONSTRAINT [DF_U_RIA_TT_ORD_CIVSPE]   DEFAULT ('   ') FOR [ORD_CIVSPE]

go

UPDATE U_RIA_TT SET ORD_IMPSPESE = 0
UPDATE U_RIA_TT SET ORD_IVASPESE = 0
UPDATE U_RIA_TT SET ORD_CODIVA = SPACE(03)
UPDATE U_RIA_TT SET ORD_CIVSPE = SPACE(03)