
/* Gestione e ricalcolo prezzi di costo vendita da distinta base , sottoscheda "Articoli", sottoscheda "Generale" 
*** dei parametri di sistama nel "form\menu_azi000.scx"
*/

ALTER TABLE [DBO].[U_AZI_PA] ADD 
	AZI_PRZDIB BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_PRZDIB] DEFAULT (0) FOR [AZI_PRZDIB]
GO

UPDATE U_AZI_PA SET AZI_PRZDIB = 0
