
/* 
************************************************************************************************************
INSERIMENTO PARAMETRO PER POSSIBILITA' CREAZIONE ARTICOLI MANCANTI IN AVANZAMENTO PRESSA PANNELLI TRUCIOLARI
************************************************************************************************************
*/
ALTER TABLE [dbo].[u_azi_pa] ADD 
	AZI_GIANEG BIT NULL 
go

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_AZI_GIANEG] DEFAULT (0) FOR [AZI_GIANEG]
go

UPDATE u_azi_pa SET AZI_GIANEG = 0
