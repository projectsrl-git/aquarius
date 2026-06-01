
/*
*** Variabile per il campo gestito nella scheda "Top standard" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Ricevute bancarie clienti factor
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_RBFACTOR varchar(3) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_RBFACTOR] DEFAULT ('')
GO


