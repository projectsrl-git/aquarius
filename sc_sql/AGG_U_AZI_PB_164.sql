
/*
*** Variabile per campo gestito nella scheda "CONTABILITA'", sottocheda "Impostazioni varie 2" di "form\menu_azi000.scx":
***		- Imposta automaticamente la data di competenza della fattura
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_XLMDTC BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_XLMDTC] DEFAULT (0)
GO
