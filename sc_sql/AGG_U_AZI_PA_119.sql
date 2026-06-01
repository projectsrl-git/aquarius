
/*
*** Variabili per l' opzione gestita nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Carichi da fornitore", dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Aggiorna il lead time articolo fornitore in base alle ultima 4 consegne (solo per ordini a fornitore non pianificati)
*/


ALTER TABLE [dbo].[U_AZI_PA] DROP CONSTRAINT
      DF_U_AZI_PA_AZI_INTRA_PRSEDE
GO

ALTER TABLE [dbo].[U_AZI_PA] DROP COLUMN 
       AZI_INTRA_PRSEDE
GO
 

ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 AZI_INTRA_PRSEDE varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_INTRA_PRSEDE] DEFAULT ('') FOR [AZI_INTRA_PRSEDE]
go

UPDATE U_AZI_PA SET AZI_INTRA_PRSEDE = ''




