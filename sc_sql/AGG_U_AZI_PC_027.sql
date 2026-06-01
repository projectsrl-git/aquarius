
/*
*** Variabile gestita nella scheda "Contabilità / Impostazioni / Impostazioni varie" del "form\menu_azi000.scx":
***		- Nel calcolo del valore consumato per l'esenzione clienti considera anche i DDT per vendita non fatturati
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_PLAFCLIDDT bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_PLAFCLIDDT] DEFAULT (0)
GO

