/*
*** Variabile per opzione gestita nella scheda "F.E. xlm", sottoscheda "Altro" di "form\menu_azi000.scx" per la fatturazione elettronica
***		- Disabilita inserimento Fattura di cortesia PDF negli allegati del file XML di fattura elettronica cliente
*/
        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_FENOATCH BIT NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_FENOATCH] DEFAULT (0)
	
GO
