/*
***		- ripartisce l'importo del movimento contabile della prima nota su più centri di costo
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_RIPACC BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_RIPACC] DEFAULT (0) FOR [AZI_RIPACC]
GO

UPDATE U_AZI_PA SET AZI_RIPACC = 0
