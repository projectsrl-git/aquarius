/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_SA] ADD 
	 SAL_PREVAL [numeric](17, 2) NULL,
	 SAL_PREQTA [numeric](17, 2) NULL,
	 SAL_EDITOR varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 SAL_DESEDI varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_SA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_SA_SAL_PREVAL] DEFAULT (0) FOR [SAL_PREVAL],
	CONSTRAINT [DF_U_PDV_SA_SAL_PREQTA] DEFAULT (0) FOR [SAL_PREQTA],
	CONSTRAINT [DF_U_PDV_SA_SAL_EDITOR] DEFAULT ('') FOR [SAL_EDITOR],
	CONSTRAINT [DF_U_PDV_SA_SAL_DESEDI] DEFAULT ('') FOR [SAL_DESEDI]
go
