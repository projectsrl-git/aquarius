
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ALT_DA] ADD 
	 ALT_ALTDDT numeric(7) NULL,
	 ALT_LUNDDT numeric(8) NULL,
	 ALT_COLDDT varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 ALT_PESDDT numeric(16,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ALT_DA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ALT_DA_ALT_ALTDDT] DEFAULT (0) FOR [ALT_ALTDDT],
	CONSTRAINT [DF_U_ALT_DA_ALT_LUNDDT] DEFAULT (0) FOR [ALT_LUNDDT],
	CONSTRAINT [DF_U_ALT_DA_ALT_COLDDT] DEFAULT ('') FOR [ALT_COLDDT],
	CONSTRAINT [DF_U_ALT_DA_ALT_PESDDT] DEFAULT (0) FOR [ALT_PESDDT]
go

UPDATE U_ALT_DA SET ALT_ALTDDT = 0
UPDATE U_ALT_DA SET ALT_LUNDDT = 0
UPDATE U_ALT_DA SET ALT_COLDDT = SPACE(3)
UPDATE U_ALT_DA SET ALT_PESDDT = 0
