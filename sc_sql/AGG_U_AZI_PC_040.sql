
/*
*** Variabile gestita nella scheda "LIPE", del "form\menu_azi000.scx":
***		-  Opzione per gestire la liquidazione trimestrale LIPE in modalità TRIMESTRE = 1 modalità MESE = 2
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_TIPO_MODULO_LIPE NUMERIC(1,0) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_TIPO_MODULO_LIPE] DEFAULT (0)
GO

UPDATE U_AZI_PC SET AZI_TIPO_MODULO_LIPE = 2