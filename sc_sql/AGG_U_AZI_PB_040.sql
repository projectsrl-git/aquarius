
/*
*** Variabile per l' opzione gestita nella scheda "Sfondi" dei parametri di sistema nel "form\menu_azi000.scx":
***		- Colore di sfondo per i campi OBBLIGATORI nei Gestionali predisposti
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_OBLGBCKCOL NUMERIC(10,0) NOT NULL DEFAULT (0)
GO
