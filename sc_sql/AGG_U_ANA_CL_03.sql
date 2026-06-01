
/*
*** Variabili per le opzioni gestite nella scheda "Impostazioni varie" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Proponi l'ultimo campo di ricerca utilizzato a livello di utente in tutte le ricerche da toolbar Aquarius
***		- Non convertire in maiuscolo le descrizioni delle anagrafiche
*/

ALTER TABLE [DBO].[U_ANA_CL] ADD 
	CLI_FATELETT BIT NULL
GO

ALTER TABLE [DBO].[U_ANA_CL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ANA_CL_CLI_FATELETT] DEFAULT (0) FOR [CLI_FATELETT]
GO

UPDATE U_ANA_CL SET CLI_FATELETT = 0
