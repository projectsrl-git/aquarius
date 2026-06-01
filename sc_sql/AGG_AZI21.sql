
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_AZI_AN] ADD 
	 AZI_DECQTA numeric(1) NULL,
	 AZI_DECPRZ numeric(1) NULL,
	 AZI_DECVAL numeric(1) NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_AN_AZI_DECQTA] DEFAULT (0) FOR [AZI_DECQTA],
	CONSTRAINT [DF_U_AZI_AN_AZI_DECPRZ] DEFAULT (0) FOR [AZI_DECPRZ],
	CONSTRAINT [DF_U_AZI_AN_AZI_DECVAL] DEFAULT (0) FOR [AZI_DECVAL]
go

UPDATE U_AZI_AN SET AZI_DECQTA = 0
UPDATE U_AZI_AN SET AZI_DECPRZ = 2
UPDATE U_AZI_AN SET AZI_DECVAL = 2
