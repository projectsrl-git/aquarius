
/* 
**********************************************************************************************
INSERIMENTO CAMPO "TIPOLOGIA ORDINE" IN TESTATE ORDINI CLIENTI 
**********************************************************************************************
*/
ALTER TABLE [dbo].[U_OFF_TT] ADD 
	 ORD_TIPOLOGIA [varchar] (6) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_OFF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_OFF_TT_ORD_TIPOLOGIA] DEFAULT ('') FOR [ORD_TIPOLOGIA]
go

UPDATE U_OFF_TT SET ORD_TIPOLOGIA = ''

ALTER TABLE [dbo].[U_ORF_TT] ADD 
	 ORD_TIPOLOGIA [varchar] (6) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORF_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORF_TT_ORD_TIPOLOGIA] DEFAULT ('') FOR [ORD_TIPOLOGIA]
go

UPDATE U_ORF_TT SET ORD_TIPOLOGIA = ''

-- ALLARGAMENTO CAMPO ORD_TIPOLOGIA A 6 CARATTERI
ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN ORD_TIPOLOGIA  VARCHAR(06) COLLATE Latin1_General_CI_AS NULL
ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN ORD_TIPOLOGIA  VARCHAR(06) COLLATE Latin1_General_CI_AS NULL
ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN ORD_TIPOLOGIA  VARCHAR(06) COLLATE Latin1_General_CI_AS NULL
ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN ORD_TIPOLOGIA  VARCHAR(06) COLLATE Latin1_General_CI_AS NULL
ALTER TABLE [dbo].[L_BOL_TT] ALTER COLUMN ORD_TIPOLOGIA  VARCHAR(06) COLLATE Latin1_General_CI_AS NULL
