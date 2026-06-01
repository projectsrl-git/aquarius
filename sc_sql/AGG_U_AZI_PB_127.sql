
/*
*** Variabili per i campo gestiti nella scheda "ORDINI", seconda sottocartella dei parametri di sistema nel "form\menu_azi000.scx":
***		- Obbligatorietà canale di vendita su ordini clienti con controaggiornamento anagrafica clienti
*/


ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_CANVEN BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_CANVEN] DEFAULT (0)
GO

