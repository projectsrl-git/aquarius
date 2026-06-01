
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Documenti" , sottoschede dei relativi documenti dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Stampa il commento 'PESO NETTO+PESO LORDO+NUMERO COLLI' nelle fatture estero
*/

 
ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_STPPES_LOR_NET_IMB  BIT NULL
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_STPPES_LOR_NET_IMB ] DEFAULT (0) FOR [AZI_STPPES_LOR_NET_IMB ]
GO

UPDATE U_AZI_PB SET AZI_STPPES_LOR_NET_IMB  = 0