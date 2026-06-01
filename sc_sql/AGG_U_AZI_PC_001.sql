
/*
*** Variabile per campo gestito nella scheda "Impostazioni varie", sottocheda "Impostazioni varie" di "form\menu_azi000.scx":
***		- Proponi l'ultimo testo di ricerca utilizzato a livello di utente in tutte le ricerche da toolbar Aquarius
*/

ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_RICTXT BIT NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_RICTXT] DEFAULT (0)
GO

UPDATE U_AZI_PC SET AZI_RICTXT = 1
