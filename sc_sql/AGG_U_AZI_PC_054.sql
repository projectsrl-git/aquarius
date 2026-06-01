
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Anagrafiche", sottoscheda "Anagrafica articoli" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Ricarico percentuale per ricalcolo automatico Prezzo di Vendita da Prezzo di Acquisto Standard
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_RICPERC NUMERIC(6,2) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_RICPERC] DEFAULT (0)
GO
