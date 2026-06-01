/*
*** Variabile per opzione gestita nella scheda "F.E. xlm", di "form\menu_azi000.scx"  per la fatturazione elettronica
***		- Codice Cassa Previdenza
*/
        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_FECODCASSA VARCHAR(10) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_FECODCASSA] DEFAULT ('')
	
GO
