
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Tutti i documenti" dei parametri di sistema nel "form\menu_azi000.scx":
***	Avvisa se al cliente/fornitore non è stata inviata l'informativa sulla privacy GDPR durante l'inserimento degli ordini
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_LISCASCA bit NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_LISCASCA] DEFAULT (0)
GO
