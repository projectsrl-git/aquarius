/* 
****************************************************************************
INSERIMENTO NUOVO CAMPO PER PROGRAMMA DI PRODUZIONE:
	- Componente fittizia (per poter gestire prelievi e versamenti [es.PDM])
****************************************************************************
*/

ALTER TABLE [dbo].[PRODUZIONE] ADD 
	[DIS_FITTIZ] BIT NULL
go

ALTER TABLE [dbo].[PRODUZIONE] WITH NOCHECK ADD 
	CONSTRAINT [DF_PRODUZIONE_DIS_FITTIZ] DEFAULT (0) FOR [DIS_FITTIZ]
go


-- AGGIORNAMENTO PROPRIETA' DI COMPONENTE FITTIZIA
UPDATE PRODUZIONE SET DIS_FITTIZ = COALESCE((SELECT TOP 1 DIS_FITTIZ FROM U_DIS_DD WHERE DIS_CODART = PRODUZIONE.COMP),0)
