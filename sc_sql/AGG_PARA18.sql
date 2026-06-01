/*
*** Variabile per l' opzione gestita nella scheda "Top standard", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Causale di carico magazzino agente / deposito
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Documenti", sottoscheda "DDT clienti", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Abilita selezione Serial Numbers su evasione DDT
***		- Commento automatico Serial Numbers selezionati
*/

ALTER TABLE [dbo].[PARA] ADD 
	 IVAESENTE bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_IVAESENTE] DEFAULT (0) FOR [IVAESENTE]
go



UPDATE PARA SET IVAESENTE = 0