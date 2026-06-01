
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti" , sottoscheda "Rda" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Gerarchia autorizzazioni RDA per CENTRI DI COSTO
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_RDACCO BIT NOT NULL DEFAULT (0)
GO
