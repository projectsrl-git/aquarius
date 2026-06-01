
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CLI_FI] ADD 
	 FID_CODTDS varchar(03) COLLATE Latin1_General_CI_AS NULL,
	 FID_CODIDS varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_FI] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_FI_FID_CODTDS] DEFAULT ('') FOR [FID_CODTDS],
	CONSTRAINT [DF_U_CLI_FI_FID_CODIDS] DEFAULT ('') FOR [FID_CODIDS]
go
