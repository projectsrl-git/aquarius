
/*
*** Variabili per l' opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Carichi da fornitore", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Aggiorna il lead time articolo fornitore in base alle ultima 4 consegne (solo per ordini a fornitore non pianificati)
*/

ALTER TABLE [DBO].[PARA] ADD 
	BENI_SERVIZI bit NULL
GO

ALTER TABLE [DBO].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_BENI_SERVIZI] DEFAULT (0) FOR [BENI_SERVIZI]
GO

UPDATE PARA SET BENI_SERVIZI = 0