
/*
*** Variabile per l' opzione gestita nella scheda "Altro", sottoscheda "Magazzino", sottoscheda "Generale" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Elimina automaticamente le giacenze negative a fronte di carico da fornitore e/o manuale
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_GNELAU BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_GNELAU] DEFAULT (0) FOR [AZI_GNELAU]
GO

UPDATE U_AZI_PB SET AZI_GNELAU = 0

