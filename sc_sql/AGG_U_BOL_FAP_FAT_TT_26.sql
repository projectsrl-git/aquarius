
/* 
**********************************************************************************************
INSERIMENTO CAMPO "TIPOLOGIA ORDINE" IN TESTATE ORDINI CLIENTI 
**********************************************************************************************
*/
ALTER TABLE [dbo].[U_BOL_TT] ADD 
	 ORD_TIPOLOGIA [varchar] (3) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_TT_ORD_TIPOLOGIA] DEFAULT ('') FOR [ORD_TIPOLOGIA]
go

UPDATE U_BOL_TT SET ORD_TIPOLOGIA = ''

ALTER TABLE [dbo].[U_FAP_TT] ADD 
	 ORD_TIPOLOGIA [varchar] (3) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAP_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_TT_ORD_TIPOLOGIA] DEFAULT ('') FOR [ORD_TIPOLOGIA]
go

UPDATE U_FAP_TT SET ORD_TIPOLOGIA = ''

ALTER TABLE [dbo].[U_FAT_TT] ADD 
	 ORD_TIPOLOGIA [varchar] (3) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_TIPOLOGIA] DEFAULT ('') FOR [ORD_TIPOLOGIA]
go

UPDATE U_FAT_TT SET ORD_TIPOLOGIA = ''

ALTER TABLE [dbo].[L_BOL_TT] ADD 
	 ORD_TIPOLOGIA [varchar] (3) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[L_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_L_BOL_TT_ORD_TIPOLOGIA] DEFAULT ('') FOR [ORD_TIPOLOGIA]
go

UPDATE L_BOL_TT SET ORD_TIPOLOGIA = ''




