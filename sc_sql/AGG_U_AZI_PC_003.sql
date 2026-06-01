
/*
*** Variabile per campo gestito nella scheda "Altro", sottocheda "Documenti", sottochede "Preventivi clienti"/"Ordini clienti" di "form\menu_azi000.scx":
***		- Obbliga la presenza di almeno un listino cliente per l'inserimento di un nuovo articolo in Ordini e Preventivi clienti
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_LISLCK BIT NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_LISLCK] DEFAULT (0)
GO

UPDATE U_AZI_PC SET AZI_LISLCK = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END
