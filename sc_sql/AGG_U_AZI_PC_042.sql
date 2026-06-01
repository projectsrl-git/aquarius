
/*
*** Variabile gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "DDT clienti" del "form\menu_azi000.scx":
***		-  Proponi stampa etichette articoli in gestionale DDT
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_STPETIDDT bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_STPETIDDT] DEFAULT (0)
GO

UPDATE U_AZI_PC SET AZI_STPETIDDT = 0