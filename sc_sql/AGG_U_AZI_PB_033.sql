
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti" , sottoschede dei relativi documenti dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Stampa il commento 'PESO NETTO+PESO LORDO+NUMERO COLLI' nelle fatture estero
*/

 
ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_STPDESTINAZIONE  BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_STPDESTINAZIONE ] DEFAULT (0) FOR [AZI_STPDESTINAZIONE ]
GO

UPDATE U_AZI_PB SET AZI_STPDESTINAZIONE  = 0