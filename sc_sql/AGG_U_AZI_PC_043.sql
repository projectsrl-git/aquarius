
/*
*** Variabile gestita nella scheda "Altro", sottoscheda "Documenti", Varie" del "form\menu_azi000.scx":
***		-  Gestione impianti industriali
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_IMPIANTI bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_IMPIANTI] DEFAULT (0)
GO

UPDATE U_AZI_PC SET AZI_IMPIANTI = 0