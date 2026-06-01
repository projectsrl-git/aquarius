
/*
*** Variabile per il campo gestito nella scheda "Impostazioni varie", sottoscheda "Codici di default", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Codice iva di default esenzione spese incasso
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_IVASPINC varchar(03) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_IVASPINC] DEFAULT ('')
GO


UPDATE U_AZI_PB SET AZI_IVASPINC = ''