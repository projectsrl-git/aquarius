/*
*** Variabile per l' opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "DDT", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Abilita la gestione del nr. Colli in dettagli ddt (gestionale e creazione ddt da ordine)
*/

ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 AZI_NCLBOL BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_NCLBOL] DEFAULT (0) FOR [AZI_NCLBOL]
go

UPDATE U_AZI_PA SET AZI_NCLBOL = 0
