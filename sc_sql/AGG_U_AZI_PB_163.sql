
/*
*** Variabile per campo gestito nella scheda "Altro", sottocheda "Settaggi tecnici" di "form\menu_azi000.scx" per la gestione della BlackBox:
***		- Escludi dalla BlackBox le operazioni SQL richiamate dai seguenti form
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_ESCLFORMBLBX TEXT COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_ESCLFORMBLBX] DEFAULT ('')
GO
