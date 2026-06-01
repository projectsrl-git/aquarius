
/*
*** Variabile per opzione gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Abilita inserimento riga automatica di riferimento alla lettera d'intento
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_FECOLI BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_FECOLI] DEFAULT (0)
GO

UPDATE U_AZI_PB SET AZI_FECOLI = 1
