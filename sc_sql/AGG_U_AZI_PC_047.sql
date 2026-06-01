
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Produzione", sottoscheda "MAcchine industriali", nel "form\menu_azi000.scx":
***		- Valorizzazione versamento semilavorati/prodotti finiti:
***			1. Costo memorizzato al momento della creazione del  programma di produz.
***			2. Costo di ultimo carico ricalcolandolo al momento del versamento
***			3. Costo effettivo ricalcolato dalla somma costi dei componenti scaricati
*/
     
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_PMICSTVERS numeric(1,0) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_PMICSTVERS] DEFAULT (1)
GO
