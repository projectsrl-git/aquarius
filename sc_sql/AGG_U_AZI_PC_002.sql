
/*
*** Variabile per campo gestito nella scheda "Bollati iva", sottocheda "Impostazioni" di "form\menu_azi000.scx":
***		- Liquidazione iva in base all'anno registrazione e alla data documento (anzichè data di registrazione)
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_LIQDTDOC BIT NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_LIQDTDOC] DEFAULT (0)
GO

