
/*
*** Variabili gestite nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Progressivo alfanumerico per nomenclatura file
*/



ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_FEPROGR NUMERIC(1,0) NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_FEPROGR] DEFAULT (1)
GO
