/*
*** Variabile per l' opzione gestita nella scheda "Top standard", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Causale di carico magazzino agente / deposito
*** Variabili per le opzioni gestite nella scheda "Altro", sottoscheda "Documenti", sottoscheda "DDT clienti", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Abilita selezione Serial Numbers su evasione DDT
***		- Commento automatico Serial Numbers selezionati
*/

ALTER TABLE [dbo].[U_AZI_PB] ADD 
	 azi_ivaintra bit NULL,
	 azi_noskaltrid bit NULL,
	 azi_nodatispe bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_azi_ivaintra] DEFAULT (0) FOR [azi_ivaintra],
	CONSTRAINT [DF_U_AZI_PB_azi_noskaltrid] DEFAULT (0) FOR [azi_noskaltrid],
	CONSTRAINT [DF_U_AZI_PB_azi_nodatispe] DEFAULT (0) FOR [azi_nodatispe]
go


UPDATE U_AZI_PB SET azi_ivaintra = 0
UPDATE U_AZI_PB SET azi_noskaltrid = 0
UPDATE U_AZI_PB SET azi_nodatispe = 0