
/*
*** Variabile per il campo gestito nella scheda "Contabilità", sottoscheda "Partitari", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Attiva la possibilità di gestire il recupero crediti per singola scadenza (blocco per pagamenti e/o scadenziario)
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	azi_pnauto BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_azi_pnauto] DEFAULT (0)
GO


UPDATE U_AZI_PB SET azi_pnauto = 0