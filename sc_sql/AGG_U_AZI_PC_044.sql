
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Fatture clienti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Forza la numerazione fatture standard NUMFAT anche per i clienti FVS (Sospensione/Split payment)
*/
     
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_NFATFVS bit NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_NFATFVS] DEFAULT (0)
GO
