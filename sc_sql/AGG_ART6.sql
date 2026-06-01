
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ART_PR] ADD 
	 ART_DESGRE varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 ART_DESEDI varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 ART_DESCOA varchar(50) COLLATE Latin1_General_CI_AS NULL,
	 ART_DESLIN varchar(50) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_DESGRE] DEFAULT ('') FOR [ART_DESGRE],
	CONSTRAINT [DF_U_ART_PR_ART_DESEDI] DEFAULT ('') FOR [ART_DESEDI],
	CONSTRAINT [DF_U_ART_PR_ART_DESCOA] DEFAULT ('') FOR [ART_DESCOA],
	CONSTRAINT [DF_U_ART_PR_ART_DESLIN] DEFAULT ('') FOR [ART_DESLIN]
go