
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Fatture clienti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Top per scrittura contabile R.A. (se vuoto, usa lo stesso Top della Fattura)
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_CAUSRA TEXT COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_CAUSRA] DEFAULT ('')
GO
