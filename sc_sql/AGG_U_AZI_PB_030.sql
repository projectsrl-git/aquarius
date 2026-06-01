
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti" , sottoscheda "Ordini clienti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Proponi stampa Conferma d'ordine per magazzino
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_STPORDMAG BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_STPORDMAG] DEFAULT (0) FOR [AZI_STPORDMAG]
GO

UPDATE U_AZI_PB SET AZI_STPORDMAG = 0
