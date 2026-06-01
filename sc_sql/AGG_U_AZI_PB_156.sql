
/*
*** Variabile per opzione gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Abilita controllo non bloccante su presenza Codice destinatario e/o PEC email anagrafici in fase di inserimento ordine cliente
*/



ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_CTRSDI BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_CTRSDI] DEFAULT (0)
GO
