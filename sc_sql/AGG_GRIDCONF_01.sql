/* 
*****************************************************************************************************************************
INSERIMENTO NUOVO CAMPO PER CHIAVE OPZIONALE IN CONFIGURAZIONE PERSONALIZZATA GRIGLIA
*****************************************************************************************************************************
*/

ALTER TABLE [dbo].[GRIDCONF] ADD 
	[KEYOPZ] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[GRIDCONF] WITH NOCHECK ADD 
	CONSTRAINT [DF_GRIDCONF_KEYOPZ] DEFAULT ('') FOR [KEYOPZ]
go


UPDATE GRIDCONF SET KEYOPZ = ''
