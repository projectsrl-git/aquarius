
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione", sezione "Distinte base" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Costo medio al secondo per determinaz. costi lavorazione interna
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_CSTSEC numeric(12,6) NULL 
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_CSTSEC] DEFAULT (0) FOR [AZI_CSTSEC]
GO

UPDATE U_AZI_PB SET AZI_CSTSEC = 0
