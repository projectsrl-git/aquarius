
/* 
************************************************************************************************************
INSERIMENTO PARAMETRO PER POSSIBILITA' CREAZIONE ARTICOLI MANCANTI IN AVANZAMENTO PRESSA PANNELLI TRUCIOLARI
************************************************************************************************************
*/
ALTER TABLE [dbo].[u_azi_pa] ADD 
	AZI_ARTPRE BIT NULL 
go

ALTER TABLE [dbo].[u_azi_pa] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_azi_pa_AZI_ARTPRE] DEFAULT (0) FOR [AZI_ARTPRE]
go

UPDATE u_azi_pa SET AZI_ARTPRE = 0
