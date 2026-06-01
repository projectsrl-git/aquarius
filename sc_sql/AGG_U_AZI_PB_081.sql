
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "DDT clienti", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Ricalcola Peso Netto in DDT (solo se ZERO) in base al peso anagrafico degli articoli nei dettagli
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_RICPSNDDT BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_RICPSNDDT] DEFAULT (0)
GO
