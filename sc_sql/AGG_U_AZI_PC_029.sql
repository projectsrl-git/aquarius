
/*
*** Variabile gestita nella scheda "Documenti / Fatture clienti / terza cartella" del "form\menu_azi000.scx":
***		- Serve per calcolare le RA nelle fatture e per la creazione della prima nota in contabilità durante il trasferimento contabile
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_RACLI bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_RACLI] DEFAULT (0)
GO

