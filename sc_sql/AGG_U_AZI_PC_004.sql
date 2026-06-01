
/*
*** Variabile per opzione gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Includi riferimenti protocollo interno azienda
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_FECOPL BIT NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_FECOPL] DEFAULT (0)
GO

UPDATE U_AZI_PC SET AZI_FECOPL = CASE WHEN COALESCE((SELECT AZI_PRDISP FROM U_AZI_PA),0) = 1 THEN 1 ELSE 0 END
