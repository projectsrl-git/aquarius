
/*
*** Variabile per l'opzione gestita nella scheda "Altro", sottoscheda "Magazzino" , sottoscheda "Generale" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Nr. giorni degli ordini clienti da considerare nel calcolo della consistenza rispetto alla data odierna e alla data consegna (zero = nessun limite)
RELEASE PUB_GGCNSO
PUBLIC PUB_GGCNSO
PUB_GGCNSO = 0
*/

 
ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_GGCNSO NUMERIC(4,0) NOT NULL DEFAULT (0)
GO
