
/*
*** Variabili per le opzioni gestite nella scheda "Impostazioni varie" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Proponi l'ultimo campo di ricerca utilizzato a livello di utente in tutte le ricerche da toolbar Aquarius
***		- Non convertire in maiuscolo le descrizioni delle anagrafiche
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_RICFLD BIT NULL,
	AZI_NOUPPER BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_RICFLD] DEFAULT (0) FOR [AZI_RICFLD],
	CONSTRAINT [DF_U_AZI_PB_AZI_NOUPPER] DEFAULT (0) FOR [AZI_NOUPPER]
GO

UPDATE U_AZI_PB SET AZI_RICFLD = 0
UPDATE U_AZI_PB SET AZI_NOUPPER = 0
