
/*
*** Variabile gestita nella scheda "terza cartella MAGAZZINI sezione GENERALE" del "form\menu_azi000.scx":
***		- Serve per attivare o meno in MENU_BFO000/MENU:BOL000 il carico/scarico tramite i BARCODE
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_DISCARSCAR bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_DISCARSCAR] DEFAULT (0)
GO

