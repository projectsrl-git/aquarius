
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_AN] ADD 
	 PDV_CODCLI varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 PDV_DESCLI varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 PDV_CODFOR varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 PDV_DESFOR varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_AN_PDV_CODCLI] DEFAULT ('') FOR [PDV_CODCLI],
	CONSTRAINT [DF_U_PDV_AN_PDV_DESCLI] DEFAULT ('') FOR [PDV_DESCLI],
	CONSTRAINT [DF_U_PDV_AN_PDV_CODFOR] DEFAULT ('') FOR [PDV_CODFOR],
	CONSTRAINT [DF_U_PDV_AN_PDV_DESFOR] DEFAULT ('') FOR [PDV_DESFOR]
go
