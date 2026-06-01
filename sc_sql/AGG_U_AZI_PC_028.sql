
/*
*** Variabile gestita nella scheda "Contabilità / Trasferimenti contabili" del "form\menu_azi000.scx":
***		- Durante il trasferimento usa sempre il codice iva spese bolli/incasso anche se il cliente è già in esenzione
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_IVABOLLI bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_IVABOLLI] DEFAULT (0)
GO

