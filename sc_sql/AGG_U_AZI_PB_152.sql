
/*
*** VariabilI gestite nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Utilizza IBAN da campo banca presente in testata fattura
*/



ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_IBANFAT bit NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_IBANFAT] DEFAULT ('')

GO
