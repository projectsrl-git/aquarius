/*
*** Variabile per l' opzione gestita nella scheda "Top standard", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Causale di carico magazzino agente / deposito
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Documenti", sottoscheda "DDT clienti", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Abilita selezione Serial Numbers su evasione DDT
***		- Commento automatico Serial Numbers selezionati
*/

ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 AZI_CAUDEP varchar(3) COLLATE Latin1_General_CI_AS NULL,
	 AZI_SETSNO bit NULL,
	 AZI_COMSNO bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_CAUDEP] DEFAULT ('') FOR [AZI_CAUDEP],
	CONSTRAINT [DF_U_AZI_PA_AZI_SETSNO] DEFAULT (0) FOR [AZI_SETSNO],
	CONSTRAINT [DF_U_AZI_PA_AZI_COMSNO] DEFAULT (0) FOR [AZI_COMSNO]
go

UPDATE U_AZI_PA SET AZI_CAUDEP = ''
UPDATE U_AZI_PA SET AZI_SETSNO = 0
UPDATE U_AZI_PA SET AZI_COMSNO = 0
