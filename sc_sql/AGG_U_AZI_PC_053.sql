
/*
*** Variabile per il campo gestito nella scheda "Altro", sottoscheda "Documenti", sottoscheda "Tutti i documenti" dei parametri di sistema  nel "form\menu_azi000.scx":
***		- Percentuale minima di ricarico rispetto al prezzo ultimo carico per alert dettaglio ricambi in gestione interventi (0 = disattivo)
*/

        
ALTER TABLE [DBO].[U_AZI_PC] ADD 
	AZI_MPVPERC NUMERIC(10,2) NOT NULL CONSTRAINT [DF_U_AZI_PC_AZI_MPVPERC] DEFAULT (0)
GO
