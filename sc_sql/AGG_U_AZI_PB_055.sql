
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Ordini clienti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Solo su ordini con condizione di pagamento con anticipo (Gestione del polieco in ordini clienti)
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_ORD_POLIEC_ANT BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_ORD_POLIEC_ANT] DEFAULT (0)
GO

UPDATE U_AZI_PB SET AZI_ORD_POLIEC_ANT = 1


/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Tutti i documenti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Nelle intestazioni dei documenti (Fatturare a, Consegnare a...) non inserisce la nazione estera se già integrata in indirizzo/rag.sociale
*/

ALTER TABLE [DBO].[U_AZI_PB] ADD 
	AZI_NOSTPNAZ BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_NOSTPNAZ] DEFAULT (0)
GO

UPDATE U_AZI_PB SET AZI_NOSTPNAZ = 1

