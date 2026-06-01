
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Tutti i documenti", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Codice testo standard proposto per default (tasto COMMENTO)
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_COMSTD varchar(16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ('')
GO
