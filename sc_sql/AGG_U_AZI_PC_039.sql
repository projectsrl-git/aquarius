
/*
*** Variabile gestita nella scheda "Altro", sottoscheda "Produzione", sottoscheda "Produzione standard" del "form\menu_azi000.scx":
***		- Giorni della settimana per attribuzione automatica nuovo lotto di produzione
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_STDGSL TEXT COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_STDGSL] DEFAULT ('')
GO
