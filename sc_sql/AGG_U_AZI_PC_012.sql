
/*
*** Variabile per il campo gestito nella scheda "Contabilità", sottoscheda "Centri di costo" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Solo per documenti di vendita (Obbligatorietà del centro di costo su ogni riga del documento)
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_CCOOBLVEN bit NOT NULL  CONSTRAINT [DF_U_AZI_PC_AZI_CCOOBLVEN] DEFAULT (0)
GO
