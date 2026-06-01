
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Fatture clienti" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Allega alle e-mail della Ristampa Documenti eventuali DDT legati alle fatture selezionate
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_ATCHDDT BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_ATCHDDT] DEFAULT (0)
GO
