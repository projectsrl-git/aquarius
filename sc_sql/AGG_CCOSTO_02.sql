/* 
*************************************************************************
INSERIMENTO TIPO_CCOSTO = TIPO CENTRO DI COSTO, UTILE PER AGGREGAZIONI
IN TABELLA CCOSTO
*************************************************************************
*/
ALTER TABLE [dbo].[CCOSTO] ADD 
	 TIPO_CCOSTO  varchar(10) COLLATE Latin1_General_CI_AS NULL
GO

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[CCOSTO] WITH NOCHECK ADD 
	CONSTRAINT [DF_CCOSTO_TIPO_CCOSTO] DEFAULT ('') FOR [TIPO_CCOSTO]
go

UPDATE CCOSTO SET TIPO_CCOSTO = ''
