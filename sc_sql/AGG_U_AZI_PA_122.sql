/*
*** Variabile per l' opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Fatture", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Non crea il commento di riferimento alla destinazione diversa nelle fatture
*/

ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 AZI_NODSTFAT BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_NODSTFAT] DEFAULT (0) FOR [AZI_NODSTFAT]
go

UPDATE U_AZI_PA SET AZI_NODSTFAT = 0
