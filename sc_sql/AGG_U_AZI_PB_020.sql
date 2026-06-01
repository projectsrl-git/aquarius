
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Produzione", opzione "Distinte base" 
*** dei parametri di sistema  nel "form\menu_azi000.scx":
***		- 1 = Rivaluta i costi rispetto al prezzo standard in anagr. articoli; 2 = Rivaluta i costi rispetto al prezzo di ultimo carico in anagr. articoli
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_OPZDBCOST numeric(1,0) NULL 
GO

ALTER TABLE [DBO].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_OPZDBCOST] DEFAULT (0) FOR [AZI_OPZDBCOST]
GO

UPDATE U_AZI_PB SET AZI_OPZDBCOST = 1
