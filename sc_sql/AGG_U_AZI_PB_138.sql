
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Listini prezzi", dei parametri di sistema nel "form\menu_azi000.scx":
***		- Gestione sconti per cliente / canale di vendita / gruppo merc. ind. (u_sco_cv)
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_LISCV BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_LISCV] DEFAULT (0)
GO

-- SE AZIENDA PRODUZIONE PANNELLI TRUCIOLARI, SETTO IL VALORE PREDEFINITO
UPDATE U_AZI_PB SET AZI_LISCV = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END