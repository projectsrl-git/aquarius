/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AVA_SP] ADD 
	AVA_CODOPE VARCHAR(10) COLLATE Latin1_General_CI_AS NULL,
	AVA_DESOPE VARCHAR(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AVA_SP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AVA_SP_AVA_CODOPE] DEFAULT ('') FOR [AVA_CODOPE],
	CONSTRAINT [DF_U_AVA_SP_AVA_DESOPE] DEFAULT ('') FOR [AVA_DESOPE]
go

UPDATE U_AVA_SP SET AVA_CODOPE = SPACE(10)
UPDATE U_AVA_SP SET AVA_DESOPE = SPACE(50)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AVA_RI] ADD 
	AVA_CODOPE VARCHAR(10) COLLATE Latin1_General_CI_AS NULL,
	AVA_DESOPE VARCHAR(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AVA_RI] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AVA_RI_AVA_CODOPE] DEFAULT ('') FOR [AVA_CODOPE],
	CONSTRAINT [DF_U_AVA_RI_AVA_DESOPE] DEFAULT ('') FOR [AVA_DESOPE]
go

UPDATE U_AVA_RI SET AVA_CODOPE = SPACE(10)
UPDATE U_AVA_RI SET AVA_DESOPE = SPACE(50)


/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AVA_TG] ADD 
	AVA_CODOPE VARCHAR(10) COLLATE Latin1_General_CI_AS NULL,
	AVA_DESOPE VARCHAR(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AVA_TG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AVA_TG_AVA_CODOPE] DEFAULT ('') FOR [AVA_CODOPE],
	CONSTRAINT [DF_U_AVA_TG_AVA_DESOPE] DEFAULT ('') FOR [AVA_DESOPE]
go

UPDATE U_AVA_TG SET AVA_CODOPE = SPACE(10)
UPDATE U_AVA_TG SET AVA_DESOPE = SPACE(50)
