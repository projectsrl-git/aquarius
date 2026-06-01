
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Tutti i documenti", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- In tutti i documenti NON calcola l'iva sulle spese incasso in quanto sono in esenzione articolo 15 (RIMBORSO)
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_NOIVASPINC  BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_NOIVASPINC] DEFAULT (0)
GO


UPDATE U_AZI_PB SET AZI_NOIVASPINC = 0